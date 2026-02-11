import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/voice_player_service.dart';
import '../../../../core/di/injections.dart';
import '../../data/services/voice_translation_service.dart';

/// Enhanced Voice Message Bubble with Translation Support
class VoiceMessageBubbleWithTranslation extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String time;
  final int? durationSeconds;
  final VoicePlayerService playerService;
  final String? messageId; // For caching translations

  const VoiceMessageBubbleWithTranslation({
    super.key,
    required this.audioUrl,
    required this.isMe,
    required this.time,
    this.durationSeconds,
    required this.playerService,
    this.messageId,
  });

  @override
  State<VoiceMessageBubbleWithTranslation> createState() => _VoiceMessageBubbleWithTranslationState();
}

class _VoiceMessageBubbleWithTranslationState extends State<VoiceMessageBubbleWithTranslation> {
  bool _isPlaying = false;
  bool _isCurrentAudio = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  
  // Translation state
  String? _transcribedText;
  String? _translatedText;
  String? _targetLanguage;
  bool _isTranscribing = false;
  bool _isTranslating = false;
  bool _showTranslation = false;
  
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _initListeners();
    
    if (widget.durationSeconds != null) {
      _duration = Duration(seconds: widget.durationSeconds!);
    }
  }

  void _initListeners() {
    _playingSubscription = widget.playerService.playingStateStream.listen((isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = isPlaying;
          // Check if this is the current audio by comparing with player's current state
          _isCurrentAudio = isPlaying;
        });
      }
    });

    _positionSubscription = widget.playerService.positionStream.listen((position) {
      if (mounted && _isPlaying) {
        setState(() => _position = position);
      }
    });

    _durationSubscription = widget.playerService.durationStream.listen((duration) {
      if (mounted && _isPlaying) {
        setState(() => _duration = duration);
      }
    });
  }

  @override
  void dispose() {
    _playingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isCurrentAudio && _isPlaying) {
      await widget.playerService.pause();
    } else {
      await widget.playerService.play(widget.audioUrl);
    }
  }

  Future<void> _transcribeAndTranslate() async {
    if (_transcribedText != null && _targetLanguage != null) {
      // Already transcribed, just toggle display
      setState(() => _showTranslation = !_showTranslation);
      return;
    }

    // Show language selection dialog
    final selectedLanguage = await _showLanguageSelectionDialog();
    if (selectedLanguage == null) return;

    setState(() {
      _targetLanguage = selectedLanguage;
      _isTranscribing = true;
    });

    try {
      final translationService = getIt<VoiceTranslationService>();
      
      // Step 1: Transcribe audio to text
      final transcription = await translationService.transcribeVoiceMessage(widget.audioUrl);
      
      setState(() {
        _transcribedText = transcription['text'];
        _isTranscribing = false;
        _isTranslating = true;
      });

      // Step 2: Translate text
      final translated = await translationService.translateText(
        text: _transcribedText!,
        targetLanguage: selectedLanguage,
        sourceLanguage: transcription['language'],
      );

      setState(() {
        _translatedText = translated;
        _isTranslating = false;
        _showTranslation = true;
      });
    } catch (e) {
      setState(() {
        _isTranscribing = false;
        _isTranslating = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showLanguageSelectionDialog() async {
    final translationService = getIt<VoiceTranslationService>();
    final languages = await translationService.getSupportedLanguages();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Translation Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final entry = languages.entries.elementAt(index);
              return ListTile(
                title: Text(entry.value),
                onTap: () => Navigator.pop(context, entry.key),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: widget.isMe ? const Color(0xFF0078D4) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Voice player controls
          Row(
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isMe ? Colors.white.withOpacity(0.2) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isCurrentAudio && _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.isMe ? Colors.white : Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Waveform/Progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                      ),
                      child: Slider(
                        value: _duration.inMilliseconds > 0
                            ? _position.inMilliseconds.toDouble()
                            : 0,
                        max: _duration.inMilliseconds.toDouble(),
                        activeColor: widget.isMe ? Colors.white : const Color(0xFF0078D4),
                        inactiveColor: widget.isMe ? Colors.white.withOpacity(0.3) : Colors.grey[400],
                        onChanged: null,
                      ),
                    ),
                    
                    // Duration text
                    Text(
                      '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                      style: TextStyle(
                        color: widget.isMe ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Translation button
              GestureDetector(
                onTap: _isTranscribing || _isTranslating ? null : _transcribeAndTranslate,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _showTranslation
                        ? (widget.isMe ? Colors.white.withOpacity(0.3) : Colors.blue.withOpacity(0.2))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isTranscribing || _isTranslating
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              widget.isMe ? Colors.white : const Color(0xFF0078D4),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.translate,
                          color: widget.isMe ? Colors.white : Colors.grey[700],
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
          
          // Translation text (if available)
          if (_showTranslation && _translatedText != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.isMe ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.translate,
                        size: 14,
                        color: widget.isMe ? Colors.white70 : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Translation',
                        style: TextStyle(
                          color: widget.isMe ? Colors.white70 : Colors.grey[600],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _translatedText!,
                    style: TextStyle(
                      color: widget.isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Time
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              widget.time,
              style: TextStyle(
                color: widget.isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
