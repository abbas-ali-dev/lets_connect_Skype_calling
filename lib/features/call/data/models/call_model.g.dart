// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallModelImpl _$$CallModelImplFromJson(Map<String, dynamic> json) =>
    _$CallModelImpl(
      id: json['id'] as String,
      callerId: json['callerId'] as String,
      receiverId: json['receiverId'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      channelName: json['channelName'] as String,
      createdAt: json['created_at'] as String,
      acceptedAt: json['accepted_at'] as String?,
      endedAt: json['ended_at'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CallModelImplToJson(_$CallModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'callerId': instance.callerId,
      'receiverId': instance.receiverId,
      'type': instance.type,
      'status': instance.status,
      'channelName': instance.channelName,
      'created_at': instance.createdAt,
      'accepted_at': instance.acceptedAt,
      'ended_at': instance.endedAt,
      'duration': instance.duration,
    };
