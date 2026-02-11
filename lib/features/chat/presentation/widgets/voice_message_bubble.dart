import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/voice_player_service.dart';

/// Voice Message Bubble Widget - Displays playable voice message in chat
class VoiceMessageBubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String time;
  final int? durationSeconds;
  final VoicePlayerService playerService;

  const VoiceMessageBubble({
    super.key,
    required this.audioUrl,
    required this.isMe,
    required this.time,
    this.durationSeconds,
    required this.playerService,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  bool _isPlaying = false;
  bool _isCurrentAudio = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<String?>? _currentUrlSubscription;

  @override
  void initState() {
    super.initState();
    _initListeners();
    
    // Set initial duration if provided
    if (widget.durationSeconds != null) {
      _duration = Duration(seconds: widget.durationSeconds!);
    }
  }

  void _initListeners() {
    _currentUrlSubscription = widget.playerService.currentUrlStream.listen((url) {
      if (mounted) {
        final isCurrentAudio = url == widget.audioUrl;
        setState(() {
          _isCurrentAudio = isCurrentAudio;
          if (!isCurrentAudio) {
            _isPlaying = false;
            _position = Duration.zero;
          }
        });
      }
    });
    
    _playingSubscription = widget.playerService.playingStateStream.listen((isPlaying) {
      if (mounted && _isCurrentAudio) {
        setState(() => _isPlaying = isPlaying);
      }
    });
    
    _positionSubscription = widget.playerService.positionStream.listen((position) {
      if (mounted && _isCurrentAudio) {
        setState(() => _position = position);
      }
    });
    
    _durationSubscription = widget.playerService.durationStream.listen((duration) {
      if (mounted && _isCurrentAudio) {
        setState(() => _duration = duration);
      }
    });
    
    // Check if this audio is currently playing
    _isCurrentAudio = widget.playerService.currentPlayingUrl == widget.audioUrl;
    if (_isCurrentAudio) {
      _isPlaying = widget.playerService.isPlaying;
      _position = widget.playerService.currentPosition;
      _duration = widget.playerService.totalDuration;
    }
  }

  @override
  void dispose() {
    _playingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentUrlSubscription?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    print('VoiceMessageBubble: Toggle play/pause for: ${widget.audioUrl}');
    widget.playerService.play(widget.audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 280),
      decoration: BoxDecoration(
        color: widget.isMe ? const Color(0xFF0078D4) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isMe 
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFF0078D4).withOpacity(0.1),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.isMe ? Colors.white : const Color(0xFF0078D4),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Waveform/Progress indicator
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: widget.isMe 
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          widget.isMe ? Colors.white : const Color(0xFF0078D4),
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Duration text
                    Text(
                      _isPlaying || _position.inSeconds > 0
                          ? '${VoicePlayerService.formatDuration(_position)} / ${VoicePlayerService.formatDuration(_duration)}'
                          : VoicePlayerService.formatDuration(_duration),
                      style: TextStyle(
                        color: widget.isMe ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Microphone icon
              const SizedBox(width: 8),
              Icon(
                Icons.mic,
                color: widget.isMe ? Colors.white54 : Colors.grey[400],
                size: 16,
              ),
            ],
          ),
          
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
}
