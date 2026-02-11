import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../constants/app_logger.dart';

// 🎯 WEBSOCKET SERVICE - Real-time communication
class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  
  String? _url;
  String? _token;
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // Stream for incoming messages
  Stream<Map<String, dynamic>> get messageStream => 
      _messageController?.stream ?? const Stream.empty();

  bool get isConnected => _isConnected;

  // Connect to WebSocket server
  Future<void> connect({
    required String url,
    required String token,
    required String userId,
  }) async {
    try {
      _url = url;
      _token = token;
      
      AppLogger.i('Connecting to WebSocket: $url');
      
      // Create WebSocket connection with auth headers
      final uri = Uri.parse('$url?token=$token&userId=$userId');
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Initialize message controller if not exists
      _messageController ??= StreamController<Map<String, dynamic>>.broadcast();

      // Listen to WebSocket messages
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      
      // Start heartbeat to keep connection alive
      _startHeartbeat();
      
      AppLogger.i('WebSocket connected successfully');
      
      // Send initial presence update
      _sendPresenceUpdate(true);
      
    } catch (e) {
      AppLogger.e('WebSocket connection failed', e);
      _scheduleReconnect();
    }
  }

  // Disconnect from WebSocket
  void disconnect() {
    AppLogger.i('Disconnecting WebSocket');
    
    _shouldReconnect = false;
    _isConnected = false;
    
    // Send offline presence before disconnecting
    _sendPresenceUpdate(false);
    
    // Clean up timers
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    
    // Close connection
    _channel?.sink.close();
    _channel = null;
    
    AppLogger.i('WebSocket disconnected');
  }

  // Send message through WebSocket
  void sendMessage({
    required String type,
    required Map<String, dynamic> data,
  }) {
    if (!_isConnected || _channel == null) {
      AppLogger.w('Cannot send message: WebSocket not connected');
      return;
    }

    try {
      final message = {
        'type': type,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel!.sink.add(jsonEncode(message));
      AppLogger.i('WebSocket message sent: $type');
    } catch (e) {
      AppLogger.e('Failed to send WebSocket message', e);
    }
  }

  // Send chat message
  void sendChatMessage({
    required String roomId,
    required String senderId,
    required String message,
  }) {
    sendMessage(
      type: 'chat_message',
      data: {
        'room_id': roomId,
        'sender_id': senderId,
        'message': message,
      },
    );
  }

  // Send typing indicator
  void sendTypingIndicator({
    required String roomId,
    required String userId,
    required bool isTyping,
  }) {
    sendMessage(
      type: 'typing_indicator',
      data: {
        'room_id': roomId,
        'user_id': userId,
        'is_typing': isTyping,
      },
    );
  }

  // Send call notification
  void sendCallNotification({
    required String receiverId,
    required String callId,
    required String callerName,
    required String channelName,
    required String callType,
  }) {
    sendMessage(
      type: 'call_notification',
      data: {
        'receiver_id': receiverId,
        'call_id': callId,
        'caller_name': callerName,
        'channel_name': channelName,
        'call_type': callType,
      },
    );
  }

  // Join room for real-time updates
  void joinRoom(String roomId) {
    sendMessage(
      type: 'join_room',
      data: {'room_id': roomId},
    );
  }

  // Leave room
  void leaveRoom(String roomId) {
    sendMessage(
      type: 'leave_room',
      data: {'room_id': roomId},
    );
  }

  // Handle incoming WebSocket messages
  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString()) as Map<String, dynamic>;
      AppLogger.i('WebSocket message received: ${data['type']}');
      
      // Handle heartbeat response
      if (data['type'] == 'pong') {
        return; // Just acknowledge heartbeat
      }
      
      // Emit message to listeners
      _messageController?.add(data);
      
    } catch (e) {
      AppLogger.e('Failed to parse WebSocket message', e);
    }
  }

  // Handle WebSocket errors
  void _onError(error) {
    AppLogger.e('WebSocket error', error);
    _isConnected = false;
    _scheduleReconnect();
  }

  // Handle WebSocket disconnection
  void _onDisconnected() {
    AppLogger.w('WebSocket disconnected');
    _isConnected = false;
    
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  // Schedule reconnection attempt
  void _scheduleReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      AppLogger.e('Max reconnection attempts reached');
      return;
    }

    _reconnectAttempts++;
    AppLogger.i('Scheduling reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_url != null && _token != null) {
        // Extract userId from previous connection (you may need to store this)
        connect(url: _url!, token: _token!, userId: 'current_user_id');
      }
    });
  }

  // Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected) {
        sendMessage(type: 'ping', data: {});
      } else {
        timer.cancel();
      }
    });
  }

  // Send presence update
  void _sendPresenceUpdate(bool isOnline) {
    if (_isConnected) {
      sendMessage(
        type: 'presence_update',
        data: {'is_online': isOnline},
      );
    }
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _messageController?.close();
    _messageController = null;
  }
}
