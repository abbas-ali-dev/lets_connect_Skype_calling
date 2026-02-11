import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../core/services/voice_recorder_service.dart';

/// Voice Message Recorder Widget - Skype-style voice recording UI
class VoiceMessageRecorder extends StatefulWidget {
  final Function(String filePath) onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceMessageRecorder({
    super.key,
    required this.onRecordingComplete,
    required this.onCancel,
  });

  @override
  State<VoiceMessageRecorder> createState() => _VoiceMessageRecorderState();
}

class _VoiceMessageRecorderState extends State<VoiceMessageRecorder>
    with SingleTickerProviderStateMixin {
  final VoiceRecorderService _recorderService = VoiceRecorderService();
  late AnimationController _pulseController;
  StreamSubscription<Duration>? _durationSubscription;
  Duration _duration = Duration.zero;
  bool _isRecording = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _startRecording();
  }

  Future<void> _startRecording() async {
    try {
      final started = await _recorderService.startRecording();
      if (started) {
        setState(() {
          _isRecording = true;
          _errorMessage = null;
        });
        _durationSubscription = _recorderService.durationStream.listen((duration) {
          setState(() => _duration = duration);
        });
      } else {
        // Permission denied or error
        setState(() {
          _errorMessage = kIsWeb 
              ? 'Voice recording requires microphone access. Please allow in browser.'
              : 'Microphone permission required for voice messages';
        });
        
        // Auto cancel after showing error
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            widget.onCancel();
          }
        });
      }
    } catch (e) {
      print('Recording error: $e');
      setState(() {
        _errorMessage = kIsWeb
            ? 'Voice recording not fully supported on web. Please use mobile app.'
            : 'Failed to start recording: $e';
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          widget.onCancel();
        }
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorderService.stopRecording();
    if (path != null) {
      widget.onRecordingComplete(path);
    } else {
      // Recording too short
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording too short. Hold longer to record.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      widget.onCancel();
    }
  }

  Future<void> _cancelRecording() async {
    await _recorderService.cancelRecording();
    widget.onCancel();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _pulseController.dispose();
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if there's an error
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border(
            top: BorderSide(color: Colors.orange.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),
            IconButton(
              onPressed: widget.onCancel,
              icon: const Icon(Icons.close, color: Colors.orange),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border(
          top: BorderSide(color: Colors.red.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Cancel button
          IconButton(
            onPressed: _cancelRecording,
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Cancel',
          ),
          
          // Recording indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.5 + _pulseController.value * 0.5),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          
          // Duration text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Recording...',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  VoiceRecorderService.formatDuration(_duration),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          
          // Send button
          FloatingActionButton(
            mini: true,
            onPressed: _isRecording ? _stopRecording : null,
            backgroundColor: Colors.red,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
