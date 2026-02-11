import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TTSService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String? _currentLanguage;

  /// Initialize TTS with language
  Future<void> initialize(String languageCode) async {
    if (_isInitialized && _currentLanguage == languageCode) {
      return;
    }

    try {
      // Set language (e.g., 'en-US', 'ur-PK', 'ar-SA')
      await _tts.setLanguage(_getFullLanguageCode(languageCode));
      
      // Configure TTS settings
      await _tts.setSpeechRate(0.5); // Speed (0.0 to 1.0)
      await _tts.setVolume(1.0); // Volume (0.0 to 1.0)
      await _tts.setPitch(1.0); // Pitch (0.5 to 2.0)
      
      // Set voice quality
      if (await _tts.isLanguageAvailable(_getFullLanguageCode(languageCode))) {
        print('✅ TTS language available: $languageCode');
      } else {
        print('⚠️ TTS language not available: $languageCode, using default');
      }

      // Callbacks
      _tts.setStartHandler(() {
        print('🔊 TTS started speaking');
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        print('✅ TTS finished speaking');
        _isSpeaking = false;
      });

      _tts.setErrorHandler((msg) {
        print('❌ TTS error: $msg');
        _isSpeaking = false;
      });

      _currentLanguage = languageCode;
      _isInitialized = true;
      
      print('✅ TTS initialized for language: $languageCode');
    } catch (e) {
      print('❌ TTS initialization failed: $e');
    }
  }

  /// Speak translated text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      print('⚠️ TTS not initialized');
      return;
    }

    if (text.isEmpty) {
      print('⚠️ Empty text, skipping TTS');
      return;
    }

    try {
      // Stop any ongoing speech
      if (_isSpeaking) {
        await stop();
      }

      print('🔊 Speaking: $text');
      await _tts.speak(text);
    } catch (e) {
      print('❌ TTS speak failed: $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      print('❌ TTS stop failed: $e');
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      print('❌ TTS pause failed: $e');
    }
  }

  /// Check if currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  /// Get available voices for language
  Future<List<dynamic>> getVoices() async {
    return await _tts.getVoices ?? [];
  }

  /// Convert short language code to full code
  String _getFullLanguageCode(String code) {
    switch (code) {
      case 'en':
        return 'en-US';
      case 'ur':
        return 'ur-PK';
      case 'ar':
        return 'ar-SA';
      case 'es':
        return 'es-ES';
      case 'fr':
        return 'fr-FR';
      case 'de':
        return 'de-DE';
      case 'hi':
        return 'hi-IN';
      case 'zh':
        return 'zh-CN';
      case 'ja':
        return 'ja-JP';
      case 'ko':
        return 'ko-KR';
      case 'pt':
        return 'pt-BR';
      case 'ru':
        return 'ru-RU';
      case 'it':
        return 'it-IT';
      case 'tr':
        return 'tr-TR';
      default:
        return 'en-US';
    }
  }

  /// Cleanup
  Future<void> dispose() async {
    await stop();
    _isInitialized = false;
  }
}
