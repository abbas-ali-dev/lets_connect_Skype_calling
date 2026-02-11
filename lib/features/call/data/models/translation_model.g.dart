// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationModelImpl _$$TranslationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationModelImpl(
      original: json['original'] as String,
      translated: json['translated'] as String,
      source_language: json['source_language'] as String,
      target_language: json['target_language'] as String,
      provider: json['provider'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$$TranslationModelImplToJson(
        _$TranslationModelImpl instance) =>
    <String, dynamic>{
      'original': instance.original,
      'translated': instance.translated,
      'source_language': instance.source_language,
      'target_language': instance.target_language,
      'provider': instance.provider,
      'timestamp': instance.timestamp,
    };

_$CallTranslationModelImpl _$$CallTranslationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CallTranslationModelImpl(
      callId: json['callId'] as String,
      speakerId: json['speakerId'] as String,
      original: json['original'] as String,
      translations: json['translations'] as Map<String, dynamic>,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$$CallTranslationModelImplToJson(
        _$CallTranslationModelImpl instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'speakerId': instance.speakerId,
      'original': instance.original,
      'translations': instance.translations,
      'timestamp': instance.timestamp,
    };

_$LanguagePreferenceModelImpl _$$LanguagePreferenceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguagePreferenceModelImpl(
      callId: json['callId'] as String,
      userId: json['userId'] as String,
      inputLang: json['inputLang'] as String,
      outputLang: json['outputLang'] as String,
    );

Map<String, dynamic> _$$LanguagePreferenceModelImplToJson(
        _$LanguagePreferenceModelImpl instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'userId': instance.userId,
      'inputLang': instance.inputLang,
      'outputLang': instance.outputLang,
    };

_$SupportedLanguagesResponseImpl _$$SupportedLanguagesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SupportedLanguagesResponseImpl(
      success: json['success'] as bool,
      languages: Map<String, String>.from(json['languages'] as Map),
    );

Map<String, dynamic> _$$SupportedLanguagesResponseImplToJson(
        _$SupportedLanguagesResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'languages': instance.languages,
    };
