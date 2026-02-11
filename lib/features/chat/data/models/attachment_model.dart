import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/attachment.dart';

part 'attachment_model.freezed.dart';
part 'attachment_model.g.dart';

// 🎯 ATTACHMENT MODEL - Data transfer object
// Handles JSON serialization/deserialization

@freezed
class AttachmentModel with _$AttachmentModel {
  const AttachmentModel._();
  
  const factory AttachmentModel({
    String? id,
    @JsonKey(name: 'message_id') String? messageId,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'file_type') String? fileType,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _AttachmentModel;

  // From JSON (API response)
  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);

  // Convert to domain entity
  Attachment toEntity() {
    return Attachment(
      id: id ?? '',
      messageId: messageId ?? '',
      fileName: fileName ?? '',
      fileType: fileType ?? 'application/octet-stream',
      fileSize: fileSize ?? 0,
      fileUrl: fileUrl ?? '',
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
    );
  }

  // From domain entity
  factory AttachmentModel.fromEntity(Attachment entity) {
    return AttachmentModel(
      id: entity.id.isNotEmpty ? entity.id : null,
      messageId: entity.messageId.isNotEmpty ? entity.messageId : null,
      fileName: entity.fileName.isNotEmpty ? entity.fileName : null,
      fileType: entity.fileType.isNotEmpty ? entity.fileType : null,
      fileSize: entity.fileSize > 0 ? entity.fileSize : null,
      fileUrl: entity.fileUrl.isNotEmpty ? entity.fileUrl : null,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
