import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ably_flutter/ably_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../features/call/domain/entities/translation.dart';
import '../constants/app_constants.dart';
import 'tts_service.dart';

@LazySingleton()
class CallTranslationService {
  final TTSService _tts;
  static const String _apiUrl = '${AppConstants.baseUrl}/api';
  
  Realtime? _ably;
  RealtimeChannel? _callChannel;
  
  String? _currentCallId;
  String? _currentUserId;
  
  bool _translationEnabled = false;
  bool _audioEnabled = true;

  CallTranslationService(this._tts);

  /// Initialize translation for a call
  Future<void> initializeForCall({
    required String callId,
    required String userId,
    required String inputLang,
    required String outputLang,
    required String ablyKey,
  }) async {
    _currentCallId = callId;
    _currentUserId = userId;

    // Set language preferences on backend
    await _setLanguagePreferences(callId, userId, inputLang, outputLang);

    // Initialize TTS with output language
    await _tts.initialize(outputLang);

    // Setup Ably to receive translations
    await _setupAblyListener(callId, ablyKey);
    
    print('✅ Translation initialized for call: $callId');
  }

  /// Set language preferences via API
  Future<void> _setLanguagePreferences(
    String callId,
    String userId,
    String inputLang,
    String outputLang,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/call/language'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'callId': callId,
          'userId': userId,
          'inputLanguage': inputLang,
          'outputLanguage': outputLang,
        }),
      );

      if (response.statusCode != 200) {
        print('⚠️ Warning: Failed to set language preferences (Server unavailable)');
      }
    } catch (e) {
      print('⚠️ Warning: Network error - using offline mode: $e');
      // Continue in offline mode - don't throw the error
    }
  }

  /// Setup Ably listener for incoming translations
  Future<void> _setupAblyListener(String callId, String ablyKey) async {
    try {
      _ably = Realtime(key: ablyKey);
      _callChannel = _ably!.channels.get('call_$callId');

      await _callChannel!.subscribe(name: 'translation').listen((message) {
        _handleTranslationMessage(message);
      });

      print('✅ Ably listener setup for call_$callId');
    } catch (e) {
      print('❌ Ably setup failed: $e');
    }
  }

  /// Handle incoming translation message
  void _handleTranslationMessage(Message message) {
    try {
      final data = message.data as Map<String, dynamic>;
      
      // Handle new message format (from our mock implementation)
      if (data['type'] == 'translation') {
        final senderId = data['userId'];
        final translatedText = data['translatedText'];
        final originalText = data['originalText'];
        
        // Don't process my own translations
        if (senderId == _currentUserId) {
          print('⏭️ Skipping own translation');
          return;
        }
        
        print('📥 Received translation from $senderId: "$originalText" -> "$translatedText"');
        
        // Speak the received translation
        _tts.speak(translatedText);
        
        // Optionally show subtitle too
        // You can emit an event here for UI to show subtitle
        return;
      }
      
      // Handle legacy message format (from backend)
      final speakerId = data['speakerId'];
      final translations = data['translations'] as Map<String, dynamic>;
      
      // Don't process my own translations
      if (speakerId == _currentUserId) {
        print('⏭️ Skipping own translation');
        return;
      }

      // Get my translation
      final myTranslation = translations[_currentUserId];
      
      if (myTranslation != null) {
        final translatedText = myTranslation['translated_text'];
        
        print('📩 Received translation: $translatedText');
        
        // Speak the translated text if audio is enabled
        if (_audioEnabled) {
          _tts.speak(translatedText);
        }
        
        // Optionally show subtitle too
        // You can emit an event here for UI to show subtitle
      }
    } catch (e) {
      print('❌ Error handling translation message: $e');
    }
  }

  /// Send translation to other participants
  Future<void> sendTranslation(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/translation/audio/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'callId': _currentCallId,
          'userId': _currentUserId,
          'text': text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Translation sent successfully');
      } else {
        print('❌ Translation failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Translation error: $e');
    }
  }

  /// Translate speech and play to receiver (real-time call translation)
  Future<void> translateAndPlay(String spokenText, String targetLanguage) async {
    try {
      // Use actual backend API for translation
      final response = await http.post(
        Uri.parse('$_apiUrl/translation/audio/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'callId': _currentCallId,
          'userId': _currentUserId,
          'text': spokenText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          // Get the translation for the receiver
          final translations = data['translations'] as Map<String, dynamic>;
          final myTranslation = translations[_currentUserId];
          
          if (myTranslation != null) {
            final translatedText = myTranslation['translated_text'];
            
            // Play translated audio to receiver
            await _tts.speak(translatedText);
            
            print('📞 Backend translation successful: "$spokenText" -> "$translatedText"');
            print('🔊 Playing translated audio to receiver');
            return;
          }
        }
      }
      
      print('❌ Backend translation failed');
    } catch (e) {
      print('❌ Translation error: $e');
    }
  }

  /// Get supported languages
  Future<List<SupportedLanguage>> getSupportedLanguages() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/translation/languages'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        final languages = data['languages'] as Map<String, dynamic>;
        
        return languages.entries.map((entry) {
          return SupportedLanguage(
            code: entry.key,
            name: entry.value,
          );
        }).toList();
      }
    }
    
    throw Exception('Failed to get supported languages');
  }

  /// Enable/disable audio playback
  void setAudioEnabled(bool enabled) {
    _audioEnabled = enabled;
    print('🔊 Audio ${enabled ? "enabled" : "disabled"}');
  }

  /// Enable/disable translation
  void setTranslationEnabled(bool enabled) {
    _translationEnabled = enabled;
    print('🌍 Translation ${enabled ? "enabled" : "disabled"}');
  }

  /// Check if translation is enabled
  bool get isTranslationEnabled => _translationEnabled;

  /// Check if audio is enabled
  bool get isAudioEnabled => _audioEnabled;

  /// Check if TTS is currently speaking
  bool get isSpeaking => _tts.isSpeaking;

  /// Cleanup
  Future<void> dispose() async {
    await _tts.dispose();
    await _callChannel?.detach();
    _ably?.close();
    print('✅ Translation service disposed');
  }
}
