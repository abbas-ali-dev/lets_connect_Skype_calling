import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/translation.dart';

part 'translation_model.freezed.dart';
part 'translation_model.g.dart';

@freezed
class TranslationModel with _$TranslationModel {
  const factory TranslationModel({
    required String original,
    required String translated,
    required String source_language,
    required String target_language,
    required String provider,
    required int timestamp,
  }) = _TranslationModel;

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);
}

@freezed
class CallTranslationModel with _$CallTranslationModel {
  const factory CallTranslationModel({
    required String callId,
    required String speakerId,
    required String original,
    required Map<String, dynamic> translations,
    required int timestamp,
  }) = _CallTranslationModel;

  factory CallTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$CallTranslationModelFromJson(json);
}

@freezed
class LanguagePreferenceModel with _$LanguagePreferenceModel {
  const factory LanguagePreferenceModel({
    required String callId,
    required String userId,
    required String inputLang,
    required String outputLang,
  }) = _LanguagePreferenceModel;

  factory LanguagePreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$LanguagePreferenceModelFromJson(json);
}

@freezed
class SupportedLanguagesResponse with _$SupportedLanguagesResponse {
  const factory SupportedLanguagesResponse({
    required bool success,
    required Map<String, String> languages,
  }) = _SupportedLanguagesResponse;

  factory SupportedLanguagesResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportedLanguagesResponseFromJson(json);
}

extension TranslationModelX on TranslationModel {
  Translation toEntity() {
    return Translation(
      originalText: original,
      translatedText: translated,
      sourceLanguage: source_language,
      targetLanguage: target_language,
      provider: provider,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}

extension CallTranslationModelX on CallTranslationModel {
  CallTranslation toEntity() {
    final translationsMap = <String, TranslatedMessage>{};
    
    translations.forEach((userId, translationData) {
      if (translationData is Map<String, dynamic>) {
        translationsMap[userId] = TranslatedMessage(
          translatedText: translationData['translated_text'] ?? '',
          targetLanguage: translationData['target_language'] ?? '',
          provider: translationData['provider'] ?? '',
        );
      }
    });

    return CallTranslation(
      callId: callId,
      speakerId: speakerId,
      originalText: original,
      translations: translationsMap,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}

extension LanguagePreferenceModelX on LanguagePreferenceModel {
  LanguagePreference toEntity() {
    return LanguagePreference(
      callId: callId,
      userId: userId,
      inputLang: inputLang,
      outputLang: outputLang,
    );
  }
}

extension SupportedLanguagesResponseX on SupportedLanguagesResponse {
  List<SupportedLanguage> toEntityList() {
    return languages.entries.map((entry) {
      return SupportedLanguage(
        code: entry.key,
        name: entry.value,
      );
    }).toList();
  }
}
