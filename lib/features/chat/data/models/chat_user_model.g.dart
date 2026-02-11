// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatUserModelImpl _$$ChatUserModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatUserModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatUserModelImplToJson(_$ChatUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'isOnline': instance.isOnline,
    };
