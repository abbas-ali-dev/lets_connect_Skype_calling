import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Voice Recorder Service - Handles audio recording for voice messages
class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  
  bool _isRecording = false;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  Timer? _durationTimer;
  Duration _currentDuration = Duration.zero;
  
  // Stream controller for recording duration updates
  final _durationController = StreamController<Duration>.broadcast();
  Stream<Duration> get durationStream => _durationController.stream;
  
  bool get isRecording => _isRecording;
  Duration get currentDuration => _currentDuration;
  
  /// Check if voice recording is supported on current platform
  static bool get isSupported => !kIsWeb;
  
  /// Request microphone permission
  Future<bool> requestPermission() async {
    if (kIsWeb) {
      // On web, permission is handled by the browser
      return await _recorder.hasPermission();
    }
    final status = await Permission.microphone.request();
    return status.isGranted;
  }
  
  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    if (kIsWeb) {
      return await _recorder.hasPermission();
    }
    return await Permission.microphone.isGranted;
  }
  
  /// Start recording voice message
  Future<bool> startRecording() async {
    try {
      // Check if platform supports recording
      if (kIsWeb) {
        print('Voice recording on web - using browser API');
        // On web, we'll use a different approach
        if (!await _recorder.hasPermission()) {
          return false;
        }
        
        // Start recording without file path (web uses blob)
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.opus,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: '', // Empty path for web - it will use blob
        );
      } else {
        // Native platforms
        // Check permission
        if (!await hasPermission()) {
          final granted = await requestPermission();
          if (!granted) {
            return false;
          }
        }
        
        // Check if recorder is available
        if (!await _recorder.hasPermission()) {
          return false;
        }
        
        // Generate file path for native platforms
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _currentRecordingPath = '${directory.path}/voice_message_$timestamp.m4a';
        
        // Configure and start recording
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _currentRecordingPath!,
        );
      }
      
      _isRecording = true;
      _recordingStartTime = DateTime.now();
      _currentDuration = Duration.zero;
      
      // Start duration timer
      _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_recordingStartTime != null) {
          _currentDuration = DateTime.now().difference(_recordingStartTime!);
          _durationController.add(_currentDuration);
        }
      });
      
      return true;
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }
  
  /// Stop recording and return the file path (native) or blob URL (web)
  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) {
        return null;
      }
      
      _durationTimer?.cancel();
      _durationTimer = null;
      
      final path = await _recorder.stop();
      _isRecording = false;
      
      print('Recording stopped, path: $path');
      
      // Check if recording is too short (less than 1 second)
      if (_currentDuration.inMilliseconds < 1000) {
        // On native platforms, delete the file if it exists
        if (!kIsWeb && path != null) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
        return null;
      }
      
      // On web, path will be a blob URL like "blob:http://..."
      // On native, path will be a file path
      return path;
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }
  
  /// Cancel recording without saving
  Future<void> cancelRecording() async {
    try {
      _durationTimer?.cancel();
      _durationTimer = null;
      
      if (_isRecording) {
        final path = await _recorder.stop();
        _isRecording = false;
        
        // Delete the recorded file
        if (path != null) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
      
      _currentRecordingPath = null;
      _currentDuration = Duration.zero;
    } catch (e) {
      print('Error canceling recording: $e');
      _isRecording = false;
    }
  }
  
  /// Format duration as mm:ss
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  /// Dispose resources
  void dispose() {
    _durationTimer?.cancel();
    _durationController.close();
    _recorder.dispose();
  }
}
