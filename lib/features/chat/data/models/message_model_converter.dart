import 'package:json_annotation/json_annotation.dart';
import 'message_model.dart';

// Converter for MessageModel to handle custom JSON parsing
class MessageModelConverter implements JsonConverter<MessageModel?, Map<String, dynamic>?> {
  const MessageModelConverter();

  @override
  MessageModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return MessageModel.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(MessageModel? object) {
    if (object == null) return null;
    // Freezed generates toJson automatically
    return {
      'id': object.id,
      'room_id': object.roomId,
      'sender_id': object.senderId,
      'message': object.message,
      'created_at': object.createdAt.toIso8601String(),
      'has_attachments': object.hasAttachments,
      'message_attachments': object.attachments,
      'sender': object.sender,
      'isRead': object.isRead,
    };
  }
}
