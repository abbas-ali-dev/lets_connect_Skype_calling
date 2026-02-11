import 'package:equatable/equatable.dart';

class Translation extends Equatable {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String provider;
  final DateTime timestamp;

  const Translation({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.provider,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        originalText,
        translatedText,
        sourceLanguage,
        targetLanguage,
        provider,
        timestamp,
      ];
}

class CallTranslation extends Equatable {
  final String callId;
  final String speakerId;
  final String originalText;
  final Map<String, TranslatedMessage> translations;
  final DateTime timestamp;

  const CallTranslation({
    required this.callId,
    required this.speakerId,
    required this.originalText,
    required this.translations,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        callId,
        speakerId,
        originalText,
        translations,
        timestamp,
      ];
}

class TranslatedMessage extends Equatable {
  final String translatedText;
  final String targetLanguage;
  final String provider;

  const TranslatedMessage({
    required this.translatedText,
    required this.targetLanguage,
    required this.provider,
  });

  @override
  List<Object?> get props => [translatedText, targetLanguage, provider];
}

class LanguagePreference extends Equatable {
  final String callId;
  final String userId;
  final String inputLang;
  final String outputLang;

  const LanguagePreference({
    required this.callId,
    required this.userId,
    required this.inputLang,
    required this.outputLang,
  });

  @override
  List<Object?> get props => [callId, userId, inputLang, outputLang];
}

class SupportedLanguage extends Equatable {
  final String code;
  final String name;

  const SupportedLanguage({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
