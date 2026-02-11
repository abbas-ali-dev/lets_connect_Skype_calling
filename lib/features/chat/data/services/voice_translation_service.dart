import 'package:dio/dio.dart';
import '../../../../core/constants/app_logger.dart';
import '../../../../core/network/dio_client.dart';

class VoiceTranslationService {
  final DioClient dioClient;

  VoiceTranslationService(this.dioClient);

  /// Transcribe voice message to text
  Future<Map<String, dynamic>> transcribeVoiceMessage(String audioFilePath) async {
    try {
      AppLogger.i('Transcribing voice message: $audioFilePath');
      
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioFilePath),
      });

      final response = await dioClient.dio.post(
        '/voice/transcribe',
        data: formData,
      );

      if (response.statusCode == 200) {
        AppLogger.i('Transcription successful');
        return {
          'text': response.data['text'] as String,
          'language': response.data['language'] as String? ?? 'en',
        };
      } else {
        throw Exception('Transcription failed');
      }
    } catch (e) {
      AppLogger.e('Transcription error', e);
      rethrow;
    }
  }

  /// Translate text to target language
  Future<String> translateText({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    try {
      AppLogger.i('Translating text to $targetLanguage');
      
      final response = await dioClient.dio.post(
        '/voice/translate',
        data: {
          'text': text,
          'targetLanguage': targetLanguage,
          if (sourceLanguage != null) 'sourceLanguage': sourceLanguage,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Translation successful');
        return response.data['translatedText'] as String;
      } else {
        throw Exception('Translation failed');
      }
    } catch (e) {
      AppLogger.e('Translation error', e);
      rethrow;
    }
  }

  /// Get supported languages
  Future<Map<String, String>> getSupportedLanguages() async {
    try {
      final response = await dioClient.dio.get('/voice/languages');
      
      if (response.statusCode == 200) {
        return Map<String, String>.from(response.data['languages']);
      } else {
        // Fallback to common languages
        return _getDefaultLanguages();
      }
    } catch (e) {
      AppLogger.e('Failed to fetch languages', e);
      return _getDefaultLanguages();
    }
  }

  Map<String, String> _getDefaultLanguages() {
    return {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'ar': 'Arabic',
      'hi': 'Hindi',
      'ur': 'Urdu',
    };
  }
}
