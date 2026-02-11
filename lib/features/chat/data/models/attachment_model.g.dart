// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentModelImpl _$$AttachmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttachmentModelImpl(
      id: json['id'] as String?,
      messageId: json['message_id'] as String?,
      fileName: json['file_name'] as String?,
      fileType: json['file_type'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      fileUrl: json['file_url'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$AttachmentModelImplToJson(
        _$AttachmentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message_id': instance.messageId,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'file_url': instance.fileUrl,
      'created_at': instance.createdAt,
    };
