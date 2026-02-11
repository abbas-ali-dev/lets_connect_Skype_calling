import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'dart:convert';
import 'package:lets_connect/core/di/injections.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/call/presentation/pages/active_call_screen.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background message: ${message.messageId}');

  final data = message.data;
  final type = data['type'];

  if (type == 'CALL') {
    await _handleIncomingCall(data);
  } else if (type == 'MESSAGE') {
    await _handleMessageNotification(data);
  } else if (type == 'CALL_ENDED') {
    await _handleCallEnded(data);
  }
}

// Handle incoming call in background
Future<void> _handleIncomingCall(Map<String, dynamic> data) async {
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
}

// Handle message notification in background
Future<void> _handleMessageNotification(Map<String, dynamic> data) async {
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'messages',
    'Messages',
    channelDescription: 'New message notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

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
}

// Handle call ended in background
Future<void> _handleCallEnded(Map<String, dynamic> data) async {
  await FlutterCallkitIncoming.endAllCalls();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize DI
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
      ],
      child: MaterialApp(
        title: 'Let\'s Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/active-call': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
            return ActiveCallScreen(
              callId: args?['callId'] ?? '',
              userId: args?['userId'] ?? '',
              isVideoCall: args?['isVideoCall'] ?? false,
              isInitiator: args?['isInitiator'] ?? false,
              callerName: args?['callerName'],
              channel: args?['channel'],
            );
          },
        },
      ),
    );
  }
}
