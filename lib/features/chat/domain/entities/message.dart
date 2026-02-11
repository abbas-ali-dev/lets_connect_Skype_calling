import 'package:equatable/equatable.dart';
import 'attachment.dart';
import 'chat_user.dart';

// 🎯 MESSAGE ENTITY - Domain model for chat messages
// Pure Dart class, no external dependencies

class Message extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String message;
  final DateTime createdAt;
  final bool hasAttachments;
  final List<Attachment> attachments;
  final ChatUser? sender;
  final bool isRead;

  const Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.hasAttachments = false,
    this.attachments = const [],
    this.sender,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        message,
        createdAt,
        hasAttachments,
        attachments,
        sender,
        isRead,
      ];

  Message copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? message,
    DateTime? createdAt,
    bool? hasAttachments,
    List<Attachment>? attachments,
    ChatUser? sender,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      attachments: attachments ?? this.attachments,
      sender: sender ?? this.sender,
      isRead: isRead ?? this.isRead,
    );
  }

  // Check if message is sent by current user
  bool isSentByMe(String currentUserId) {
    return senderId == currentUserId;
  }

  // Get formatted time
  String getFormattedTime() {
    // Convert createdAt to local time if it's in UTC
    final localCreatedAt = createdAt.isUtc ? createdAt.toLocal() : createdAt;
    final now = DateTime.now();
    final difference = now.difference(localCreatedAt);

    // Debug logging
    print('DEBUG TIME: createdAt=$createdAt, isUtc=${createdAt.isUtc}, localCreatedAt=$localCreatedAt, now=$now, difference=${difference.inMinutes}m');

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${localCreatedAt.day}/${localCreatedAt.month}/${localCreatedAt.year}';
    }
  }
}
