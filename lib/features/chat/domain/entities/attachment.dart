import 'package:equatable/equatable.dart';

// 🎯 ATTACHMENT ENTITY - Domain model for message attachments
// Pure Dart class, no external dependencies

class Attachment extends Equatable {
  final String id;
  final String messageId;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String fileUrl;
  final DateTime createdAt;

  const Attachment({
    required this.id,
    required this.messageId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.fileUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        messageId,
        fileName,
        fileType,
        fileSize,
        fileUrl,
        createdAt,
      ];

  Attachment copyWith({
    String? id,
    String? messageId,
    String? fileName,
    String? fileType,
    int? fileSize,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return Attachment(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Check if attachment is an image
  bool get isImage {
    return fileType.startsWith('image/');
  }

  // Check if attachment is a document
  bool get isDocument {
    return fileType == 'application/pdf' ||
        fileType.contains('document') ||
        fileType.contains('text');
  }

  // Check if attachment is an audio/voice message
  bool get isAudio {
    return fileType.startsWith('audio/') ||
        fileType == 'audio/m4a' ||
        fileType == 'audio/mp3' ||
        fileType == 'audio/wav' ||
        fileType == 'audio/aac' ||
        fileName.endsWith('.m4a') ||
        fileName.endsWith('.mp3') ||
        fileName.endsWith('.wav');
  }

  // Check if attachment is a voice message (audio with specific naming)
  bool get isVoiceMessage {
    return isAudio && (fileName.contains('voice_message') || fileName.contains('voice_'));
  }

  // Get formatted file size
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '${fileSize}B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }
}
