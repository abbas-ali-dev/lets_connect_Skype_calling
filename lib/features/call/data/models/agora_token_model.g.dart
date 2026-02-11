// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgoraTokenModelImpl _$$AgoraTokenModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AgoraTokenModelImpl(
      token: json['token'] as String,
      channel: json['channel'] as String,
      channelName: json['channelName'] as String?,
      uid: (json['uid'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => CallLanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AgoraTokenModelImplToJson(
        _$AgoraTokenModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'channel': instance.channel,
      'channelName': instance.channelName,
      'uid': instance.uid,
      'languages': instance.languages,
    };

_$CallLanguageModelImpl _$$CallLanguageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CallLanguageModelImpl(
      callId: json['call_id'] as String,
      userId: json['user_id'] as String,
      inputLang: json['input_lang'] as String,
      outputLang: json['output_lang'] as String,
    );

Map<String, dynamic> _$$CallLanguageModelImplToJson(
        _$CallLanguageModelImpl instance) =>
    <String, dynamic>{
      'call_id': instance.callId,
      'user_id': instance.userId,
      'input_lang': instance.inputLang,
      'output_lang': instance.outputLang,
    };
