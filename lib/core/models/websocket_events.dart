// 🎯 WEBSOCKET EVENTS - Real-time event models

class WebSocketEvent {
  const WebSocketEvent();
}

class MessageReceivedEvent extends WebSocketEvent {
  final String id;
  final String roomId;
  final String senderId;
  final String message;
  final DateTime createdAt;
  final Map<String, dynamic>? sender;

  const MessageReceivedEvent({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.sender,
  });
}

class TypingIndicatorEvent extends WebSocketEvent {
  final String roomId;
  final String userId;
  final bool isTyping;
  final String? username;

  const TypingIndicatorEvent({
    required this.roomId,
    required this.userId,
    required this.isTyping,
    this.username,
  });
}

class PresenceUpdateEvent extends WebSocketEvent {
  final String userId;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? username;

  const PresenceUpdateEvent({
    required this.userId,
    required this.isOnline,
    this.lastSeen,
    this.username,
  });
}

class UserJoinedEvent extends WebSocketEvent {
  final String roomId;
  final String userId;
  final String? username;

  const UserJoinedEvent({
    required this.roomId,
    required this.userId,
    this.username,
  });
}

class UserLeftEvent extends WebSocketEvent {
  final String roomId;
  final String userId;
  final String? username;

  const UserLeftEvent({
    required this.roomId,
    required this.userId,
    this.username,
  });
}

class MessageReadEvent extends WebSocketEvent {
  final String roomId;
  final String messageId;
  final String userId;

  const MessageReadEvent({
    required this.roomId,
    required this.messageId,
    required this.userId,
  });
}

class RoomUpdatedEvent extends WebSocketEvent {
  final String roomId;
  final Map<String, dynamic> updates;

  const RoomUpdatedEvent({
    required this.roomId,
    required this.updates,
  });
}

class ErrorEvent extends WebSocketEvent {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const ErrorEvent({
    required this.message,
    this.code,
    this.details,
  });
}

class WebSocketEventFactory {
  // Factory method to create event from WebSocket message
  static WebSocketEvent fromWebSocketMessage(Map<String, dynamic> data) {
    final type = data['type'] as String;
    final payload = data['data'] as Map<String, dynamic>;

    switch (type) {
      case 'message_received':
        return MessageReceivedEvent(
          id: payload['id'] as String,
          roomId: payload['room_id'] as String,
          senderId: payload['sender_id'] as String,
          message: payload['message'] as String,
          createdAt: DateTime.parse(payload['created_at'] as String),
          sender: payload['sender'] as Map<String, dynamic>?,
        );

      case 'typing_indicator':
        return TypingIndicatorEvent(
          roomId: payload['room_id'] as String,
          userId: payload['user_id'] as String,
          isTyping: payload['is_typing'] as bool,
          username: payload['username'] as String?,
        );

      case 'presence_update':
        return PresenceUpdateEvent(
          userId: payload['user_id'] as String,
          isOnline: payload['is_online'] as bool,
          lastSeen: payload['last_seen'] != null 
            ? DateTime.parse(payload['last_seen'] as String)
            : null,
          username: payload['username'] as String?,
        );

      case 'user_joined':
        return UserJoinedEvent(
          roomId: payload['room_id'] as String,
          userId: payload['user_id'] as String,
          username: payload['username'] as String?,
        );

      case 'user_left':
        return UserLeftEvent(
          roomId: payload['room_id'] as String,
          userId: payload['user_id'] as String,
          username: payload['username'] as String?,
        );

      case 'message_read':
        return MessageReadEvent(
          roomId: payload['room_id'] as String,
          messageId: payload['message_id'] as String,
          userId: payload['user_id'] as String,
        );

      case 'room_updated':
        return RoomUpdatedEvent(
          roomId: payload['room_id'] as String,
          updates: payload['updates'] as Map<String, dynamic>,
        );

      case 'error':
        return ErrorEvent(
          message: payload['message'] as String,
          code: payload['code'] as String?,
          details: payload['details'] as Map<String, dynamic>?,
        );

      default:
        return ErrorEvent(
          message: 'Unknown WebSocket event type: $type',
          code: 'UNKNOWN_EVENT_TYPE',
          details: data,
        );
    }
  }
}
