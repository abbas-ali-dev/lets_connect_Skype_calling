import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

/// Voice Player Service - Handles audio playback for voice messages
/// Supports Web, Android, and iOS platforms
class VoicePlayerService {
  final AudioPlayer _player = AudioPlayer();
  
  String? _currentPlayingUrl;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  
  // Stream controllers for UI updates
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playingStateController = StreamController<bool>.broadcast();
  final _currentUrlController = StreamController<String?>.broadcast();
  
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<bool> get playingStateStream => _playingStateController.stream;
  Stream<String?> get currentUrlStream => _currentUrlController.stream;
  
  bool get isPlaying => _isPlaying;
  String? get currentPlayingUrl => _currentPlayingUrl;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  
  VoicePlayerService() {
    _initPlayer();
    _initListeners();
  }
  
  Future<void> _initPlayer() async {
    try {
      // Set player mode to media player (better for streaming)
      await _player.setPlayerMode(PlayerMode.mediaPlayer);
      
      // Configure audio context for Android
      // This fixes MEDIA_ERROR_UNKNOWN errors on Android
      await _player.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.mixWithOthers,
              AVAudioSessionOptions.duckOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
      
      // Set release mode to stop when playback completes
      await _player.setReleaseMode(ReleaseMode.stop);
      
      print('VoicePlayer: Audio context configured successfully');
    } catch (e) {
      print('VoicePlayer: Error configuring audio context: $e');
    }
  }
  
  void _initListeners() {
    // Listen to position changes
    _player.onPositionChanged.listen((position) {
      _currentPosition = position;
      if (!_positionController.isClosed) {
        _positionController.add(position);
      }
    });
    
    // Listen to duration changes
    _player.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      if (!_durationController.isClosed) {
        _durationController.add(duration);
      }
    });
    
    // Listen to player state changes
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (!_playingStateController.isClosed) {
        _playingStateController.add(_isPlaying);
      }
      
      if (state == PlayerState.completed) {
        _currentPlayingUrl = null;
        if (!_currentUrlController.isClosed) {
          _currentUrlController.add(null);
        }
        _currentPosition = Duration.zero;
        if (!_positionController.isClosed) {
          _positionController.add(Duration.zero);
        }
      }
    });
  }
  
  /// Play audio from URL or file path
  /// Supports: HTTP/HTTPS URLs, blob URLs (web), file paths (native)
  Future<void> play(String url) async {
    try {
      print('VoicePlayer: Attempting to play: $url');
      
      // If already playing the same audio, pause it
      if (_currentPlayingUrl == url && _isPlaying) {
        await pause();
        return;
      }
      
      // If playing different audio, stop current and play new
      if (_currentPlayingUrl != url) {
        await stop();
        _currentPlayingUrl = url;
        _currentUrlController.add(url);
        
        // Determine source type based on URL format and platform
        // Use setSourceUrl + resume pattern for better Android compatibility
        if (url.startsWith('blob:')) {
          // Web blob URL - use UrlSource on web
          print('VoicePlayer: Setting blob URL source');
          await _player.setSourceUrl(url);
        } else if (url.startsWith('http://') || url.startsWith('https://')) {
          // Remote URL - works on all platforms
          print('VoicePlayer: Setting remote URL source');
          await _player.setSourceUrl(url);
        } else if (url.startsWith('data:')) {
          // Data URL (base64) - use UrlSource
          print('VoicePlayer: Setting data URL source');
          await _player.setSourceUrl(url);
        } else {
          // Local file path - use DeviceFileSource (native only)
          print('VoicePlayer: Setting local file source');
          await _player.setSource(DeviceFileSource(url));
        }
        
        // Now play the audio after source is set
        print('VoicePlayer: Source set, starting playback');
        await _player.resume();
        print('VoicePlayer: Playback started successfully');
      } else {
        // Resume paused audio
        await _player.resume();
      }
    } on Exception catch (e) {
      print('AudioPlayers Exception: $e');
      print('VoicePlayer Error: Failed to play audio from URL: $url');
      _currentPlayingUrl = null;
      if (!_currentUrlController.isClosed) {
        _currentUrlController.add(null);
      }
      _isPlaying = false;
      if (!_playingStateController.isClosed) {
        _playingStateController.add(false);
      }
      rethrow;
    } catch (e) {
      print('VoicePlayer Error: $e');
      _currentPlayingUrl = null;
      if (!_currentUrlController.isClosed) {
        _currentUrlController.add(null);
      }
      _isPlaying = false;
      if (!_playingStateController.isClosed) {
        _playingStateController.add(false);
      }
    }
  }
  
  /// Pause current playback
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }
  
  /// Stop current playback
  Future<void> stop() async {
    try {
      await _player.stop();
      _currentPlayingUrl = null;
      if (!_currentUrlController.isClosed) {
        _currentUrlController.add(null);
      }
      _currentPosition = Duration.zero;
      if (!_positionController.isClosed) {
        _positionController.add(Duration.zero);
      }
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }
  
  /// Seek to position
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
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
    _player.dispose();
    _positionController.close();
    _durationController.close();
    _playingStateController.close();
    _currentUrlController.close();
  }
}
