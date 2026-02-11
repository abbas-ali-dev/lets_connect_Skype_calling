import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_logger.dart';
import 'fcm_remote_data_source.dart';

// 🎯 FCM SERVICE - Handles Firebase Cloud Messaging for call and message notifications
// Manages push notifications, local notifications, and native incoming call UI

@LazySingleton()
class FCMService {
  final FCMRemoteDataSource _remoteDataSource;
  FirebaseMessaging? _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  String? _currentUserId;
  
  // Callbacks for handling events
  Function(Map<String, dynamic>)? onIncomingCall;
  Function(String, String, String)? onCallAccepted;
  Function(String)? onCallDeclined;
  Function(Map<String, dynamic>)? onNewMessage;
  
  FCMService(this._remoteDataSource);

  // Initialize FCM service with user ID
  Future<void> initialize(String userId) async {
    try {
      _currentUserId = userId;
      
      // Initialize FirebaseMessaging instance (Firebase already initialized in main.dart)
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // Request notification permissions
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        AppLogger.w('⚠️ Notification permissions not granted');
        return;
      }
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Get FCM token
      _fcmToken = await _firebaseMessaging!.getToken();
      AppLogger.i('📱 FCM Token: $_fcmToken');
      
      // Register token with backend
      if (_fcmToken != null) {
        await _registerTokenWithBackend(userId, _fcmToken!);
      }
      
      // Setup message handlers
      _setupMessageHandlers();
      
      // Listen for token refresh
      _firebaseMessaging!.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _registerTokenWithBackend(userId, newToken);
      });
      
      // Setup CallKit event listeners
      _setupCallKitListeners();
      
      AppLogger.i('✅ FCM Service initialized successfully');
    } catch (e) {
      AppLogger.e('❌ Failed to initialize FCM Service: $e');
      rethrow;
    }
  }

  // Request notification permissions
  Future<bool> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      AppLogger.i('FCM Permission status: ${settings.authorizationStatus}');
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      AppLogger.e('Failed to request FCM permissions: $e');
      return false;
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    const callsChannel = AndroidNotificationChannel(
      'calls',
      'Calls',
      description: 'Incoming call notifications',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: true,
    );
    
    const messagesChannel = AndroidNotificationChannel(
      'messages',
      'Messages',
      description: 'New message notifications',
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    await androidPlugin?.createNotificationChannel(callsChannel);
    await androidPlugin?.createNotificationChannel(messagesChannel);
  }

  // Register FCM token with backend
  Future<void> _registerTokenWithBackend(String userId, String token) async {
    try {
      await _remoteDataSource.registerToken(
        userId: userId,
        token: token,
        deviceInfo: {
          'deviceType': Platform.isAndroid ? 'android' : 'ios',
          'deviceModel': Platform.operatingSystem,
          'appVersion': '1.0.0',
        },
      );
      AppLogger.i('✅ FCM token registered with backend');
    } catch (e) {
      AppLogger.e('❌ Failed to register FCM token with backend: $e');
    }
  }
  
  // Setup message handlers for different app states
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle messages when app is terminated and opened from notification
    _firebaseMessaging!.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.i('📩 Foreground message: ${message.data}');
    
    final data = message.data;
    final type = data['type'];
    
    if (type == 'CALL') {
      _showIncomingCall(data);
    } else if (type == 'MESSAGE') {
      _showMessageNotification(data);
    } else if (type == 'CALL_ENDED') {
      _handleCallEnded(data);
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    AppLogger.i('📩 Notification tapped: ${message.data}');
    
    final data = message.data;
    final action = data['action'];
    
    if (action == 'new_message') {
      onNewMessage?.call(data);
    } else if (action == 'incoming_call') {
      onIncomingCall?.call(data);
    }
  }

  // Show incoming call using native CallKit UI
  Future<void> _showIncomingCall(Map<String, dynamic> data) async {
    final callId = data['callId'] ?? '';
    final callerName = data['callerName'] ?? 'Unknown';
    final callType = data['callType'] ?? 'audio';
    final channelName = data['channelName'] ?? '';
    final callerId = data['callerId'] ?? '';
    final callerAvatar = data['callerAvatar'] ?? '';

    AppLogger.i('📞 Showing incoming call from $callerName');

    // Show native incoming call UI
    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: "Let's Connect",
        avatar: callerAvatar,
        handle: callerId,
        type: callType == 'video' ? 1 : 0,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: {
          'callId': callId,
          'channelName': channelName,
          'callType': callType,
          'callerId': callerId,
        },
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          actionColor: '#4CAF50',
        ),
        ios: const IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          supportsUngrouping: false,
          ringtonePath: 'system_ringtone_default',
        ),
      ),
    );
    
    // Trigger callback
    onIncomingCall?.call(data);
  }
  
  // Setup CallKit event listeners
  void _setupCallKitListeners() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event == null) return;
      
      final callId = event.body['id'] as String?;
      final extra = event.body['extra'] as Map<String, dynamic>?;
      
      AppLogger.i('📞 CallKit event: ${event.event}, callId: $callId');
      
      switch (event.event) {
        case Event.actionCallAccept:
          if (callId != null && extra != null) {
            final channelName = extra['channelName'] as String? ?? '';
            final callType = extra['callType'] as String? ?? 'audio';
            onCallAccepted?.call(callId, channelName, callType);
          }
          break;
        case Event.actionCallDecline:
          if (callId != null) {
            onCallDeclined?.call(callId);
          }
          break;
        case Event.actionCallEnded:
          if (callId != null) {
            onCallDeclined?.call(callId);
          }
          break;
        default:
          break;
      }
    });
  }
  
  // Show message notification
  Future<void> _showMessageNotification(Map<String, dynamic> data) async {
    final messageId = data['messageId'] ?? '';
    final senderName = data['senderName'] ?? 'Unknown';
    final messageText = data['messageText'] ?? 'Sent you a message';
    final roomId = data['roomId'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'New message notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      threadIdentifier: 'messages',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      messageId.hashCode,
      senderName,
      messageText,
      notificationDetails,
      payload: jsonEncode({
        ...data,
        'action': 'new_message',
        'roomId': roomId,
      }),
    );
    
    // Trigger callback
    onNewMessage?.call(data);
  }
  
  // Handle call ended
  void _handleCallEnded(Map<String, dynamic> data) {
    final callId = data['callId'] ?? '';
    AppLogger.i('📞 Call ended: $callId');
    
    // End CallKit call
    FlutterCallkitIncoming.endAllCalls();
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final action = data['action'] as String?;
      
      if (action == 'new_message') {
        onNewMessage?.call(data);
      } else if (action == 'incoming_call') {
        onIncomingCall?.call(data);
      }
    } catch (e) {
      AppLogger.e('Failed to handle notification tap: $e');
    }
  }

  // Get FCM token
  Future<String?> getToken() async {
    return _fcmToken ?? await _firebaseMessaging?.getToken();
  }

  // Set callbacks
  void setCallbacks({
    Function(Map<String, dynamic>)? onIncomingCall,
    Function(String, String, String)? onCallAccepted,
    Function(String)? onCallDeclined,
    Function(Map<String, dynamic>)? onNewMessage,
  }) {
    this.onIncomingCall = onIncomingCall;
    this.onCallAccepted = onCallAccepted;
    this.onCallDeclined = onCallDeclined;
    this.onNewMessage = onNewMessage;
  }

  // Cleanup - call on logout
  Future<void> cleanup() async {
    if (_currentUserId != null && _fcmToken != null) {
      try {
        await _remoteDataSource.removeToken(
          userId: _currentUserId!,
          token: _fcmToken!,
        );
        AppLogger.i('✅ FCM token removed from backend');
      } catch (e) {
        AppLogger.e('Failed to remove FCM token: $e');
      }
    }
    
    // End all active calls
    await FlutterCallkitIncoming.endAllCalls();
    
    // Clear all notifications
    await _localNotifications.cancelAll();
    
    _currentUserId = null;
    _fcmToken = null;
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.i('📩 Background message: ${message.messageId}');
  
  final data = message.data;
  final type = data['type'];
  
  if (type == 'CALL') {
    // Show incoming call UI
    final callId = data['callId'] ?? '';
    final callerName = data['callerName'] ?? 'Unknown';
    final callType = data['callType'] ?? 'audio';
    final channelName = data['channelName'] ?? '';
    final callerId = data['callerId'] ?? '';
    final callerAvatar = data['callerAvatar'] ?? '';

    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: "Let's Connect",
        avatar: callerAvatar,
        handle: callerId,
        type: callType == 'video' ? 1 : 0,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: {
          'callId': callId,
          'channelName': channelName,
          'callType': callType,
          'callerId': callerId,
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
  } else if (type == 'MESSAGE') {
    // Show message notification
    final localNotifications = FlutterLocalNotificationsPlugin();
    
    const androidDetails = AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'New message notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final messageId = data['messageId'] ?? '';
    final senderName = data['senderName'] ?? 'Unknown';
    final messageText = data['messageText'] ?? 'Sent you a message';
    
    await localNotifications.show(
      messageId.hashCode,
      senderName,
      messageText,
      notificationDetails,
      payload: jsonEncode(data),
    );
  } else if (type == 'CALL_ENDED') {
    // End CallKit call
    await FlutterCallkitIncoming.endAllCalls();
  }
}
