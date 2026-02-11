import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? _currentUserId;

  /// Initialize FCM
  Future<void> initialize(String userId) async {
    _currentUserId = userId;

    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ FCM Permission granted');

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      print('📱 FCM Token: $_fcmToken');
      print('📱 Token length: ${_fcmToken?.length}');
      print('📱 Token starts with: ${_fcmToken?.substring(0, 20)}...');
      
      // Check if this looks like a fresh token (not the old invalid one)
      final oldInvalidTokens = [
        'fPGddt7UQ4CL5B28NGHh',
        'fVS63kNGS2aFWUN74W_N',
      ];
      
      final isOldToken = oldInvalidTokens.any((old) => _fcmToken?.startsWith(old) == true);
      if (isOldToken) {
        print('⚠️ WARNING: This appears to be an old invalid token!');
        print('🔄 Force refreshing token...');
        await _firebaseMessaging.deleteToken();
        _fcmToken = await _firebaseMessaging.getToken();
        print('📱 New FCM Token: $_fcmToken');
        print('📱 New Token length: ${_fcmToken?.length}');
      }

      // Validate token format
      if (_fcmToken != null && _fcmToken!.length > 100) {
        print('✅ FCM Token format looks valid');
        await _registerTokenWithBackend(userId, _fcmToken!);
      } else {
        print('❌ Invalid FCM token format');
        // Try to get a new token
        await _firebaseMessaging.deleteToken();
        _fcmToken = await _firebaseMessaging.getToken();
        print('🔄 New FCM Token: $_fcmToken');
        if (_fcmToken != null) {
          await _registerTokenWithBackend(userId, _fcmToken!);
        }
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap (app opened from notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Handle initial message (app opened from terminated state)
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Setup CallKit listeners
      _setupCallKitListeners();

      print('✅ FCM Service initialized successfully');
      
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 FCM Token refreshed');
        print('📱 New token: $newToken');
        _fcmToken = newToken;
        if (_currentUserId != null) {
          _registerTokenWithBackend(_currentUserId!, newToken);
        }
      });
    } else {
      print('❌ FCM Permission denied');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create notification channels
    const AndroidNotificationChannel callsChannel = AndroidNotificationChannel(
      'calls',
      'Calls',
      description: 'Incoming call notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel messagesChannel =
        AndroidNotificationChannel(
      'messages',
      'Messages',
      description: 'New message notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(callsChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(messagesChannel);
  }

  /// Register FCM token with backend
  Future<void> _registerTokenWithBackend(String userId, String token) async {
    try {
      print('🔄 Registering FCM token with backend...');
      print('👤 User ID: $userId');
      print('📱 Token (first 20 chars): ${token.substring(0, 20)}...');
      
      final response = await http.post(
        Uri.parse('https://lets-connect-sooty.vercel.app/api/fcm/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'token': token,
          'deviceInfo': {
            'deviceType': 'android',
            'deviceModel': 'Flutter Device',
            'appVersion': '1.0.0',
          },
        }),
      );

      print('🔄 Response status: ${response.statusCode}');
      print('🔄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ FCM token registered successfully with backend');
        } else {
          print('⚠️ Backend returned success=false: ${responseData['message']}');
        }
      } else {
        print('❌ Failed to register FCM token: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error registering FCM token: $e');
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    print('📩 Foreground message received: ${message.messageId}');
    print('📩 Message data: ${message.data}');
    print('📩 Message notification: ${message.notification}');
    print('📩 Message title: ${message.notification?.title}');
    print('📩 Message body: ${message.notification?.body}');

    if (message.data['type'] == 'CALL') {
      print('📩 Processing CALL notification');
      _showIncomingCall(message.data);
    } else if (message.data['type'] == 'MESSAGE') {
      print('📩 Processing MESSAGE notification');
      _showMessageNotification(message.data);
    } else if (message.data['type'] == 'CALL_ENDED') {
      print('📩 Processing CALL_ENDED notification');
      FlutterCallkitIncoming.endAllCalls();
    } else {
      print('📩 Unknown message type: ${message.data['type']}');
    }
  }

  /// Show incoming call UI
  Future<void> _showIncomingCall(Map<String, dynamic> data) async {
    final callId = data['callId'];
    final callerName = data['callerName'];
    final callType = data['callType'];
    final channelName = data['channelName'];
    final callerId = data['callerId'];

    // Show native incoming call UI
    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: "Let's Connect",
        avatar: data['callerAvatar'] ?? '',
        handle: callerId,
        type: callType == 'video' ? 1 : 0, // 0: audio, 1: video
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: {
          'callId': callId,
          'channelName': channelName,
          'callType': callType,
        },
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          actionColor: '#4CAF50',
        ),
      ),
    );

    // Listen for call actions
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event?.event == Event.actionCallAccept) {
        print('✅ Call accepted: $callId');
        _acceptCall(callId, channelName, callType);
      } else if (event?.event == Event.actionCallDecline) {
        print('❌ Call declined: $callId');
        _rejectCall(callId);
      }
    });
  }

  /// Show message notification
  Future<void> _showMessageNotification(Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'New message notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      data['messageId'].hashCode,
      data['senderName'],
      data['messageText'] ?? 'Sent you a message',
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  /// Accept call via API
  Future<void> _acceptCall(String callId, String channelName, String callType) async {
    try {
      final response = await http.post(
        Uri.parse('https://lets-connect-sooty.vercel.app/api/call/accept'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'callId': callId,
          'receiverId': _currentUserId,
        }),
      );

      print('✅ Call accepted response: ${response.statusCode}');
    } catch (e) {
      print('Failed to accept call: $e');
    }
  }

  /// Reject call via API
  Future<void> _rejectCall(String callId) async {
    try {
      final response = await http.post(
        Uri.parse('https://lets-connect-sooty.vercel.app/api/call/reject'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'callId': callId,
          'receiverId': _currentUserId,
        }),
      );

      print('✅ Call rejected response: ${response.statusCode}');
    } catch (e) {
      print('Failed to reject call: $e');
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('📩 Notification tapped: ${message.data}');

    if (message.data['action'] == 'new_message') {
      // Navigate to chat room
      // Navigator.pushNamed(context, '/chat', arguments: {
      //   'roomId': message.data['roomId'],
      // });
    }
  }

  /// Get current FCM token
  String? get currentToken => _fcmToken;

  /// Force refresh and re-register FCM token
  Future<void> refreshToken() async {
    if (_currentUserId == null) {
      print('❌ Cannot refresh token: User not logged in');
      return;
    }

    try {
      print('🔄 Force refreshing FCM token...');
      
      // Delete current token
      await _firebaseMessaging.deleteToken();
      print('🗑️ Old token deleted');
      
      // Get new token
      _fcmToken = await _firebaseMessaging.getToken();
      print('📱 New FCM Token: $_fcmToken');
      print('📱 Token length: ${_fcmToken?.length}');
      
      // Register new token
      if (_fcmToken != null && _fcmToken!.length > 100) {
        await _registerTokenWithBackend(_currentUserId!, _fcmToken!);
        print('✅ Token refreshed and registered successfully');
        
        // Verify token format - should start with different prefix now
        if (_fcmToken!.startsWith('fVS63kNGS2aFWUN74W_N') || _fcmToken!.startsWith('fPGddt7UQ4CL5B28NGHh')) {
          print('⚠️ WARNING: This still looks like an old token!');
          print('🔄 Trying one more time...');
          await _firebaseMessaging.deleteToken();
          _fcmToken = await _firebaseMessaging.getToken();
          print('📱 Fresh token: $_fcmToken');
          await _registerTokenWithBackend(_currentUserId!, _fcmToken!);
        }
      } else {
        print('❌ Invalid new token format');
      }
    } catch (e) {
      print('❌ Error refreshing token: $e');
    }
  }

  /// Cleanup (call on logout)
  Future<void> cleanup() async {
    if (_currentUserId != null && _fcmToken != null) {
      try {
        await http.delete(
          Uri.parse('https://lets-connect-sooty.vercel.app/api/fcm/remove'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userId': _currentUserId,
            'token': _fcmToken,
          }),
        );
        print('✅ FCM token removed from backend');
      } catch (e) {
        print('Failed to remove FCM token: $e');
      }
    }
  }

  /// Setup CallKit event listeners
  void _setupCallKitListeners() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      if (event == null) return;
      
      print('📞 CallKit event: ${event.event}');
      print('📞 CallKit body: ${event.body}');

      switch (event.event) {
        case Event.actionCallAccept:
          final data = event.body;
          if (data != null && data['extra'] != null) {
            final extra = data['extra'] as Map<String, dynamic>;
            final callId = extra['callId'] as String? ?? '';
            final channelName = extra['channelName'] as String? ?? '';
            final callType = extra['callType'] as String? ?? 'audio';
            
            print('✅ Call accepted: $callId');
            _acceptCall(callId, channelName, callType);
          }
          break;

        case Event.actionCallDecline:
          final data = event.body;
          if (data != null && data['extra'] != null) {
            final extra = data['extra'] as Map<String, dynamic>;
            final callId = extra['callId'] as String? ?? '';
            
            print('❌ Call declined: $callId');
            _rejectCall(callId);
          }
          break;

        case Event.actionCallEnded:
          print('📞 Call ended from CallKit UI');
          // Call ended from the native UI
          break;

        case Event.actionCallTimeout:
          print('📞 Call timed out');
          FlutterCallkitIncoming.endAllCalls();
          break;

        default:
          print('📞 Unknown CallKit event: ${event.event}');
          break;
      }
    });
  }
}
