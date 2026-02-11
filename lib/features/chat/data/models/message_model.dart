import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message.dart';
import 'attachment_model.dart';
import 'chat_user_model.dart';
import 'utc_datetime_converter.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

// 🎯 MESSAGE MODEL - Data transfer object
// Handles JSON serialization/deserialization

@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();
  
  const factory MessageModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'sender_id') required String senderId,
    required String message,
    @UtcDateTimeConverter() @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'has_attachments') @Default(false) bool hasAttachments,
    @JsonKey(name: 'message_attachments') @Default([]) List<AttachmentModel> attachments,
    ChatUserModel? sender, // API returns sender info in 'sender' field
    @Default(false) bool isRead,
  }) = _MessageModel;

  // From JSON (API response)
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  // Convert to domain entity
  Message toEntity() {
    return Message(
      id: id,
      roomId: roomId,
      senderId: senderId,
      message: message,
      createdAt: createdAt,
      hasAttachments: hasAttachments,
      attachments: attachments.map((a) => a.toEntity()).toList(),
      sender: sender?.toEntity(),
      isRead: isRead,
    );
  }

  // From domain entity
  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      roomId: entity.roomId,
      senderId: entity.senderId,
      message: entity.message,
      createdAt: entity.createdAt,
      hasAttachments: entity.hasAttachments,
      attachments: entity.attachments.map((a) => AttachmentModel.fromEntity(a)).toList(),
      sender: entity.sender != null ? ChatUserModel.fromEntity(entity.sender!) : null,
      isRead: entity.isRead,
    );
  }
}
