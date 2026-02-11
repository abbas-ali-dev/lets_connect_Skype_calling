import 'dart:async';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:injectable/injectable.dart';
import '../constants/app_logger.dart';

@LazySingleton()
class AblyService {
  ably.Realtime? _realtime;
  final Map<String, ably.RealtimeChannel> _channels = {};
  final Map<String, StreamController<Map<String, dynamic>>> _eventControllers = {};

  Future<void> initialize(String apiKey) async {
    try {
      final clientOptions = ably.ClientOptions(key: apiKey);
      _realtime = ably.Realtime(options: clientOptions);
      
      _realtime!.connection.on().listen((ably.ConnectionStateChange stateChange) {
        AppLogger.i('🔗 ABLY: Connection state changed: ${stateChange.current} from ${stateChange.previous}');
        if (stateChange.current == ably.ConnectionState.failed) {
          AppLogger.e('🔗 ABLY: Connection failed: ${stateChange.reason}');
        } else if (stateChange.current == ably.ConnectionState.connected) {
          AppLogger.i('🔗 ABLY: Successfully connected to Ably');
        }
      });
      
      AppLogger.i('🔗 ABLY: Service initialized successfully with API key');
    } catch (e) {
      AppLogger.e('Failed to initialize Ably service: $e');
      rethrow;
    }
  }

  Future<void> initializeWithToken(String token) async {
    try {
      final tokenDetails = ably.TokenDetails(token);
      final clientOptions = ably.ClientOptions.fromKey('');
      clientOptions.tokenDetails = tokenDetails;
      _realtime = ably.Realtime(options: clientOptions);
      
      _realtime!.connection.on().listen((ably.ConnectionStateChange stateChange) {
        AppLogger.i('Ably connection state: ${stateChange.current}');
      });
      
      AppLogger.i('Ably service initialized with token successfully');
    } catch (e) {
      AppLogger.e('Failed to initialize Ably service with token: $e');
      rethrow;
    }
  }

  Future<void> initializeWithTokenDetails(Map<String, dynamic> tokenData) async {
    try {
      // Backend returns: {keyName, clientId, timestamp, nonce, mac}
      final clientOptions = ably.ClientOptions(
        authCallback: (ably.TokenParams tokenParams) async {
          return ably.TokenRequest.fromMap(tokenData);
        },
      );
      
      _realtime = ably.Realtime(options: clientOptions);
      
      _realtime!.connection.on().listen((ably.ConnectionStateChange stateChange) {
        AppLogger.i('Ably connection state: ${stateChange.current}');
      });
      
      AppLogger.i('Ably service initialized with token details successfully');
    } catch (e) {
      AppLogger.e('Failed to initialize Ably service with token details: $e');
      rethrow;
    }
  }

  Future<void> subscribeToUserChannel(String userId) async {
    try {
      final channelName = 'user:$userId';
      final channel = _realtime!.channels.get(channelName);
      _channels[channelName] = channel;

      await channel.attach();
      AppLogger.i('Subscribed to channel: $channelName');
    } catch (e) {
      AppLogger.e('Failed to subscribe to user channel: $e');
      rethrow;
    }
  }

  Stream<Map<String, dynamic>> onIncomingCall(String userId) {
    final channelName = 'user:$userId';
    final eventName = 'incoming-call';
    final key = '$channelName:$eventName';

    AppLogger.i('Setting up incoming call listener for user: $userId, channel: $channelName');

    if (!_eventControllers.containsKey(key)) {
      _eventControllers[key] = StreamController<Map<String, dynamic>>.broadcast();
      
      final channel = _channels[channelName];
      if (channel != null) {
        AppLogger.i('Channel found, subscribing to $eventName event');
        channel.subscribe(name: eventName).listen((ably.Message message) {
          AppLogger.i('🔔 ABLY: Received incoming-call event on user channel: ${message.data}');
          // Handle type casting properly - Ably sends Map<Object?, Object?>
          final data = Map<String, dynamic>.from(message.data as Map);
          _eventControllers[key]!.add(data);
        });
      } else {
        AppLogger.e('Channel not found: $channelName. Make sure subscribeToUserChannel was called first.');
      }
    }

    return _eventControllers[key]!.stream;
  }

  Stream<Map<String, dynamic>> onCallEvent(String channelName, String eventName) {
    final key = '$channelName:$eventName';

    if (!_eventControllers.containsKey(key)) {
      _eventControllers[key] = StreamController<Map<String, dynamic>>.broadcast();
      
      ably.RealtimeChannel? channel = _channels[channelName];
      if (channel == null) {
        channel = _realtime!.channels.get(channelName);
        _channels[channelName] = channel;
        channel.attach();
      }

      channel.subscribe(name: eventName).listen((ably.Message message) {
        // Handle type casting properly - Ably sends Map<Object?, Object?>
        final data = Map<String, dynamic>.from(message.data as Map);
        _eventControllers[key]!.add(data);
      });
    }

    return _eventControllers[key]!.stream;
  }

  Future<void> publishMessage(String channelName, String eventName, Map<String, dynamic> data) async {
    try {
      if (_realtime == null) {
        AppLogger.w('⚠️ ABLY: Cannot publish message - Ably not initialized');
        return;
      }

      ably.RealtimeChannel? channel = _channels[channelName];
      if (channel == null) {
        channel = _realtime!.channels.get(channelName);
        _channels[channelName] = channel;
        await channel.attach();
      }

      await channel.publish(name: eventName, data: data);
      AppLogger.i('📤 ABLY: Published message to channel $channelName with event $eventName');
    } catch (e) {
      AppLogger.e('Failed to publish message to channel $channelName: $e');
      rethrow;
    }
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    try {
      final channel = _channels[channelName];
      if (channel != null) {
        await channel.detach();
        _channels.remove(channelName);
        
        _eventControllers.keys
            .where((key) => key.startsWith('$channelName:'))
            .toList()
            .forEach((key) {
          _eventControllers[key]?.close();
          _eventControllers.remove(key);
        });
        
        AppLogger.i('Unsubscribed from channel: $channelName');
      }
    } catch (e) {
      AppLogger.e('Failed to unsubscribe from channel: $e');
    }
  }

  Future<void> dispose() async {
    try {
      for (var controller in _eventControllers.values) {
        await controller.close();
      }
      _eventControllers.clear();
      
      for (var channel in _channels.values) {
        await channel.detach();
      }
      _channels.clear();
      
      await _realtime?.close();
      _realtime = null;
      
      AppLogger.i('Ably service disposed');
    } catch (e) {
      AppLogger.e('Error disposing Ably service: $e');
    }
  }
}
