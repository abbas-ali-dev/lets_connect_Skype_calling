// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      message: json['message'] as String,
      createdAt:
          const UtcDateTimeConverter().fromJson(json['created_at'] as String),
      hasAttachments: json['has_attachments'] as bool? ?? false,
      attachments: (json['message_attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sender: json['sender'] == null
          ? null
          : ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'sender_id': instance.senderId,
      'message': instance.message,
      'created_at': const UtcDateTimeConverter().toJson(instance.createdAt),
      'has_attachments': instance.hasAttachments,
      'message_attachments': instance.attachments,
      'sender': instance.sender,
      'isRead': instance.isRead,
    };
