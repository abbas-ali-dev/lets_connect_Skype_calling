import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/room.dart';
import 'chat_user_model.dart';
import 'message_model.dart';
import 'message_model_converter.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

// 🎯 ROOM MODEL - Data transfer object
// Handles JSON serialization/deserialization for rooms (1-to-1 and groups)

@freezed
class RoomModel with _$RoomModel {
  const RoomModel._();
  
  const factory RoomModel({
    required String id,
    String? name,
    @JsonKey(name: 'is_group') required bool isGroup,
    @Default([]) List<ChatUserModel> members,
    @MessageModelConverter() @JsonKey(name: 'last_message') MessageModel? lastMessage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(0) int unreadCount,
    // Group-specific fields
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'admin_ids') @Default([]) List<String> adminIds,
    @JsonKey(name: 'max_members') int? maxMembers,
  }) = _RoomModel;

  // From JSON (API response)
  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  // Convert to domain entity
  Room toEntity() {
    return Room(
      id: id,
      name: name,
      isGroup: isGroup,
      members: members.map((m) => m.toEntity()).toList(),
      lastMessage: lastMessage?.toEntity(),
      createdAt: createdAt,
      unreadCount: unreadCount,
      description: description,
      imageUrl: imageUrl,
      createdBy: createdBy,
      adminIds: adminIds,
      maxMembers: maxMembers,
    );
  }

  // From domain entity
  factory RoomModel.fromEntity(Room entity) {
    return RoomModel(
      id: entity.id,
      name: entity.name,
      isGroup: entity.isGroup,
      members: entity.members.map((m) => ChatUserModel.fromEntity(m)).toList(),
      lastMessage: entity.lastMessage != null ? MessageModel.fromEntity(entity.lastMessage!) : null,
      createdAt: entity.createdAt,
      unreadCount: entity.unreadCount,
      description: entity.description,
      imageUrl: entity.imageUrl,
      createdBy: entity.createdBy,
      adminIds: entity.adminIds,
      maxMembers: entity.maxMembers,
    );
  }
}
