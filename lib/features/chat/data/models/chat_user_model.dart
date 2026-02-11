import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_user.dart';

part 'chat_user_model.freezed.dart';
part 'chat_user_model.g.dart';

// 🎯 CHAT USER MODEL - Data transfer object
// Handles JSON serialization/deserialization

@freezed
class ChatUserModel with _$ChatUserModel {
  const ChatUserModel._();
  
  const factory ChatUserModel({
    required String id,
    required String username,
    required String email,
    @Default(false) bool isOnline,
  }) = _ChatUserModel;

  // From JSON (API response)
  factory ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUserModelFromJson(json);

  // Convert to domain entity
  ChatUser toEntity() {
    return ChatUser(
      id: id,
      username: username,
      email: email,
      isOnline: isOnline,
    );
  }

  // From domain entity
  factory ChatUserModel.fromEntity(ChatUser entity) {
    return ChatUserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      isOnline: entity.isOnline,
    );
  }
}
