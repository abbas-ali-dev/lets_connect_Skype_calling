// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomModelImpl _$$RoomModelImplFromJson(Map<String, dynamic> json) =>
    _$RoomModelImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => ChatUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastMessage: const MessageModelConverter()
          .fromJson(json['last_message'] as Map<String, dynamic>?),
      createdAt: DateTime.parse(json['created_at'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      createdBy: json['created_by'] as String?,
      adminIds: (json['admin_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxMembers: (json['max_members'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RoomModelImplToJson(_$RoomModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_group': instance.isGroup,
      'members': instance.members,
      'last_message':
          const MessageModelConverter().toJson(instance.lastMessage),
      'created_at': instance.createdAt.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'created_by': instance.createdBy,
      'admin_ids': instance.adminIds,
      'max_members': instance.maxMembers,
    };
