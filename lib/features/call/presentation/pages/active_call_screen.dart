import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/agora_service.dart';
import '../../../../core/services/ably_service.dart';
import '../../../../core/services/call_translation_service.dart';
import '../../../../core/di/injections.dart';
import '../../domain/usecases/join_call_usecase.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../bloc/call_bloc.dart';

class ActiveCallScreen extends StatefulWidget {
  final String callId;
  final String userId;
  final bool isVideoCall;
  final bool isInitiator;
  final String? receiverId;
  final String? receiverName;
  final String? callerName;
  final String? channel;

  const ActiveCallScreen({
    super.key,
    required this.callId,
    required this.userId,
    required this.isVideoCall,
    this.isInitiator = false,
    this.receiverId,
    this.receiverName,
    this.callerName,
    this.channel,
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  Timer? _callTimer;
  int _callDuration = 0;
  AgoraService? _agoraService;
  AblyService? _ablyService;
  StreamSubscription? _callEndedSubscription;
  StreamSubscription? _userCallEndedSubscription;
  StreamSubscription? _remoteUidSubscription;
  bool _isCallEnding = false;
  VideoViewController? _localViewController;
  VideoViewController? _remoteViewController;

  // Translation state
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _translationEnabled = false;
  bool _audioEnabled = true;
  bool _isListening = false;
  String _recognizedText = '';
  String _myInputLanguage = 'en'; // What I speak
  String _myOutputLanguage = 'es'; // What I want to hear
  CallTranslationService? _translationService;
  CallBloc? _callBloc;

  @override
  void initState() {
    super.initState();
    _initializeCall();
    _initializeSpeech();
    _startCallTimer();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      print('❌ Speech recognition not available');
    }
  }

  Future<void> _initializeCall() async {
    try {
      print('🔄 Initializing call services...');
      print('🔄 Call ID: ${widget.callId}');
      print('🔄 User ID: ${widget.userId}');
      
      // Validate required parameters
      if (widget.callId.isEmpty) {
        throw Exception('Call ID is empty');
      }
      if (widget.userId.isEmpty) {
        throw Exception('User ID is empty');
      }
      
      // Create services
      _agoraService = AgoraService();
      print('✅ AgoraService created');
      
      _ablyService = getIt<AblyService>();
      print('✅ AblyService retrieved');
      
      // Initialize AblyService if not already initialized
      await _ablyService!.initialize('ZliWLA.MV5xLg:m68RKqPnByrQQOFuqh_R7SdpiiZGDAJOsmRa6Xs_nGU');
      print('✅ AblyService initialized');
      
      await _agoraService!.initialize();
      print('✅ AgoraService initialized');
      
      // Listen for call-ended events
      _listenForCallEndedEvents();
      print('✅ Call-ended event listener setup');
      
      // Get Agora token and join the call
      print('🔄 Getting JoinCallUseCase...');
      final joinCallUseCase = getIt<JoinCallUseCase>();
      print('✅ JoinCallUseCase retrieved');
      
      print('🔄 Calling JoinCallUseCase with callId: ${widget.callId}, userId: ${widget.userId}');
      final result = await joinCallUseCase(
        callId: widget.callId,
        userId: widget.userId,
      );
      print('✅ JoinCallUseCase completed');
      
      result.fold(
        (failure) {
          print('❌ Failed to get Agora token: $failure');
          print('❌ This will end the call automatically');
          // Show error and end call
          _endCall();
        },
        (agoraToken) {
          print('✅ Got Agora token, joining call...');
          print('✅ Token: ${agoraToken.token.substring(0, 20)}...');
          print('✅ Channel: ${agoraToken.channel}');
          print('✅ UID: ${agoraToken.uid}');
          _joinAgoraCall(agoraToken);
        },
      );
      
      // Use callerName if this user is the receiver, otherwise use receiverName
      final displayName = widget.isInitiator ? widget.receiverName : widget.callerName;
      print('Call screen initialized for ${displayName ?? "Unknown"}');
    } catch (e) {
      print('Error initializing call: $e');
      _endCall();
    }
  }
  
  void _listenForCallEndedEvents() {
    try {
      // Use the actual channel name from the call data, not the call ID
      final channelName = widget.channel ?? 'call_${widget.callId}';
      print('🔄 Setting up call-ended event listener for channel: $channelName');
      print('🔄 widget.channel: ${widget.channel}');
      print('🔄 widget.callId: ${widget.callId}');
      print('🔄 Using channel: $channelName');
      
      // Listen for call-ended events on the call channel
      final callEventStream = _ablyService!.onCallEvent(channelName, 'call-ended');
      
      _callEndedSubscription = callEventStream.listen((data) {
        print('🔴 ABLY: Received call-ended event in ActiveCallScreen: $data');
        // End the call when we receive the event from the other participant
        if (!_isCallEnding) {
          _endCall();
        } else {
          print('🔴 Call is already ending, ignoring event');
        }
      });
      
      // Also listen for call-ended events on our user channel (more reliable)
      if (widget.receiverId != null) {
        final userChannelName = 'user:${widget.userId}';
        print('🔄 Setting up call-ended event listener for user channel: $userChannelName');
        
        final userCallEventStream = _ablyService!.onCallEvent(userChannelName, 'call-ended');
        
        _userCallEndedSubscription = userCallEventStream.listen((data) {
          print('🔴 ABLY: Received call-ended event on user channel: $data');
          // End the call when we receive the event from the other participant
          if (!_isCallEnding) {
            _endCall();
          } else {
            print('🔴 Call is already ending, ignoring user channel event');
          }
        });
      }
      
      print('✅ Call-ended event listener setup completed');
    } catch (e) {
      print('❌ Error setting up call-ended event listener: $e');
      // Don't end the call here, just log the error
    }
  }
  
  Future<void> _joinAgoraCall(agoraToken) async {
    try {
      print('🔄 Attempting to join Agora channel...');
      print('🔄 Channel: ${agoraToken.channel}');
      print('🔄 UID: ${agoraToken.uid}');
      print('🔄 Video: ${widget.isVideoCall}');
      
      // Join the Agora channel with the token
      await _agoraService!.joinChannel(
        token: agoraToken.token,
        channelName: agoraToken.channel,
        uid: agoraToken.uid,
        isVideoCall: widget.isVideoCall,
      );
      
      // Initialize video controllers for video calls
      if (widget.isVideoCall) {
        _initializeVideoControllers(agoraToken.channel);
      }
      
      print('✅ Successfully joined Agora call');
    } catch (e) {
      print('❌ Error joining Agora call: $e');
      print('❌ This will end the call automatically');
      _endCall();
    }
  }

  void _initializeVideoControllers(String channelName) {
    // Initialize local video controller
    _localViewController = VideoViewController(
      rtcEngine: _agoraService!.engine!,
      canvas: VideoCanvas(uid: 0, sourceType: VideoSourceType.videoSourceCamera),
    );

    // Listen for remote user changes
    _remoteUidSubscription = _agoraService!.remoteUidStream.listen((uid) {
      setState(() {
        if (uid != null) {
          // Initialize remote video controller when user joins
          _remoteViewController = VideoViewController.remote(
            rtcEngine: _agoraService!.engine!,
            connection: RtcConnection(channelId: channelName),
            canvas: VideoCanvas(uid: uid, sourceType: VideoSourceType.videoSourceCamera),
          );
        } else {
          _remoteViewController = null;
        }
      });
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _callEndedSubscription?.cancel();
    _userCallEndedSubscription?.cancel();
    _remoteUidSubscription?.cancel();
    _localViewController?.dispose();
    _remoteViewController?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _agoraService?.muteLocalAudioStream(_isMuted);
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    // Add error handling for speakerphone toggle
    _agoraService?.setEnableSpeakerphone(_isSpeakerOn).catchError((e) {
      print('Error toggling speakerphone: $e');
      // Don't crash the app, just continue with the state change
    });
  }

  void _toggleVideo() {
    setState(() {
      _isVideoOn = !_isVideoOn;
    });
    _agoraService?.muteLocalVideoStream(!_isVideoOn);
  }

  void _switchCamera() {
    _agoraService?.switchCamera();
  }

  // Translation methods
  void _toggleTranslation() {
    setState(() {
      _translationEnabled = !_translationEnabled;
    });
    
    if (_translationEnabled) {
      _initializeTranslation();
    } else {
      _translationService?.setTranslationEnabled(false);
    }
  }

  void _toggleTranslationAudio() {
    setState(() {
      _audioEnabled = !_audioEnabled;
    });
    _translationService?.setAudioEnabled(_audioEnabled);
  }

  Future<void> _initializeTranslation() async {
    try {
      _translationService = getIt<CallTranslationService>();
      _callBloc = getIt<CallBloc>();
      
      await _translationService!.initializeForCall(
        callId: widget.callId,
        userId: widget.userId,
        inputLang: _myInputLanguage,
        outputLang: _myOutputLanguage,
        ablyKey: 'ZliWLA.MV5xLg:m68RKqPnByrQQOFuqh_R7SdpiiZGDAJOsmRa6Xs_nGU',
      );
      
      _translationService!.setTranslationEnabled(true);
      _translationService!.setAudioEnabled(_audioEnabled);
      
      print('✅ Translation initialized');
    } catch (e) {
      print('❌ Failed to initialize translation: $e');
      setState(() {
        _translationEnabled = false;
      });
    }
  }

  void _startListening() async {
    if (_isListening || !_translationEnabled) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });

        if (result.finalResult && _recognizedText.isNotEmpty) {
          // Translate and play to receiver
          _translationService?.translateAndPlay(_recognizedText, _myOutputLanguage);
          
          setState(() {
            _isListening = false;
          });
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: _getSTTLocale(_myInputLanguage),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  String _getSTTLocale(String code) {
    switch (code) {
      case 'ur': return 'ur_PK';
      case 'en': return 'en_US';
      case 'es': return 'es_ES';
      case 'fr': return 'fr_FR';
      case 'de': return 'de_DE';
      case 'ar': return 'ar_SA';
      case 'hi': return 'hi_IN';
      case 'zh': return 'zh_CN';
      case 'ja': return 'ja_JP';
      case 'ko': return 'ko_KR';
      case 'pt': return 'pt_BR';
      case 'ru': return 'ru_RU';
      case 'it': return 'it_IT';
      case 'tr': return 'tr_TR';
      default: return 'en_US';
    }
  }

  void _endCall() async {
    // Prevent multiple calls to _endCall
    if (_isCallEnding) {
      print('🔴 Call already ending, skipping...');
      return;
    }
    
    _isCallEnding = true;
    
    try {
      print('🔴 ENDING CALL: ${widget.callId}');
      
      // Broadcast call-ended event to all participants via Ably
      try {
        final channelName = widget.channel ?? 'call_${widget.callId}';
        await _ablyService?.publishMessage(
          channelName,
          'call-ended',
          {
            'callId': widget.callId,
            'endedBy': widget.userId,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        print('✅ Broadcast call-ended event to all participants');
      } catch (e) {
        print('⚠️ Failed to broadcast call-ended event: $e');
      }
      
      // Also send to specific user channels to ensure they receive it
      if (widget.receiverId != null) {
        try {
          await _ablyService?.publishMessage(
            'user:${widget.receiverId}',
            'call-ended',
            {
              'callId': widget.callId,
              'endedBy': widget.userId,
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
          print('✅ Sent call-ended event to receiver: ${widget.receiverId}');
        } catch (e) {
          print('⚠️ Failed to send call-ended event to receiver: $e');
        }
      }
      
      // Call backend to end the call and notify other participant via FCM
      final endCallUseCase = getIt<EndCallUseCase>();
      final result = await endCallUseCase(callId: widget.callId);
      
      result.fold(
        (failure) {
          print('Failed to end call: $failure');
        },
        (success) {
          print('Call ended successfully');
        },
      );
      
      // Leave Agora channel
      await _agoraService?.leaveChannel();
      
      // End CallKit call if active
      await FlutterCallkitIncoming.endAllCalls();
      
      // Navigate back
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error ending call: $e');
      // Still navigate back even if there's an error
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
          child: Stack(
            children: [
              if (widget.isVideoCall)
                _buildVideoView()
              else
                _buildAudioView(),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatDuration(_callDuration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Translation controls
                    _buildTranslationControls(),
                    const SizedBox(height: 20),
                    // Recognized text display
                    if (_recognizedText.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Text(
                          'You said: $_recognizedText',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Main control buttons
                    _buildControlButtons(),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildVideoView() {
    return Stack(
      children: [
        // Remote video (full screen)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _remoteViewController != null
              ? AgoraVideoView(controller: _remoteViewController!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[700],
                        child: Text(
                          (widget.isInitiator ? widget.receiverName : widget.callerName)?.isNotEmpty == true
                              ? (widget.isInitiator ? widget.receiverName : widget.callerName)![0].toUpperCase()
                              : 'U',
                          style: const TextStyle(fontSize: 48, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.isInitiator ? widget.receiverName ?? 'Unknown' : widget.callerName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Waiting for video...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        // Local video (picture-in-picture)
        Positioned(
          top: 60,
          right: 20,
          width: 120,
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _localViewController != null
                  ? AgoraVideoView(controller: _localViewController!)
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.videocam_off, color: Colors.white, size: 24),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioView() {
    // Use callerName if this user is the receiver, otherwise use receiverName
    final displayName = widget.isInitiator ? widget.receiverName : widget.callerName;
    final displayInitial = displayName?.isNotEmpty == true 
      ? displayName![0].toUpperCase() 
      : 'U';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[700],
            child: Text(
              displayInitial,
              style: const TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            displayName ?? 'Unknown',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Audio Call',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            label: _isMuted ? 'Unmute' : 'Mute',
            onPressed: _toggleMute,
            color: _isMuted ? Colors.white : Colors.grey[800]!,
          ),
          if (widget.isVideoCall) ...[
            _buildControlButton(
              icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
              label: _isVideoOn ? 'Video Off' : 'Video On',
              onPressed: _toggleVideo,
              color: _isVideoOn ? Colors.grey[800]! : Colors.white,
            ),
            _buildControlButton(
              icon: Icons.flip_camera_ios,
              label: 'Flip',
              onPressed: _switchCamera,
              color: Colors.grey[800]!,
            ),
          ] else
            _buildControlButton(
              icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
              label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
              onPressed: _toggleSpeaker,
              color: _isSpeakerOn ? Colors.grey[800]! : Colors.white,
            ),
          _buildControlButton(
            icon: Icons.call_end,
            label: 'End',
            onPressed: _endCall,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: color,
          heroTag: label,
          child: Icon(icon, color: color == Colors.red ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTranslationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Language selection row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageSelector(
                label: 'Input: ${_getLanguageName(_myInputLanguage)}',
                onPressed: _showInputLanguageSelector,
                color: Colors.blue,
              ),
              _buildLanguageSelector(
                label: 'Output: ${_getLanguageName(_myOutputLanguage)}',
                onPressed: _showOutputLanguageSelector,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Control buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Translation toggle
              _buildControlButton(
                icon: _translationEnabled ? Icons.translate : Icons.translate_outlined,
                label: _translationEnabled ? 'Translation ON' : 'Translation OFF',
                onPressed: _toggleTranslation,
                color: _translationEnabled ? Colors.green : Colors.grey[800]!,
              ),
              
              // Audio toggle
              _buildControlButton(
                icon: _audioEnabled ? Icons.volume_up : Icons.volume_off,
                label: _audioEnabled ? 'Audio ON' : 'Audio OFF',
                onPressed: _toggleTranslationAudio,
                color: _audioEnabled ? Colors.blue : Colors.grey[800]!,
              ),
              
              // Microphone button for speech input
              _buildMicrophoneButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => _startListening(),
          onTapUp: (_) => _stopListening(),
          onTapCancel: () => _stopListening(),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening ? Colors.red : Colors.blue,
              boxShadow: _isListening ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ] : null,
            ),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isListening ? 'Listening...' : 'Speak',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    final languages = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'zh': 'Chinese',
      'ja': 'Japanese',
      'ko': 'Korean',
      'ar': 'Arabic',
      'hi': 'Hindi',
    };
    return languages[languageCode] ?? languageCode.toUpperCase();
  }

  void _showInputLanguageSelector() {
    _showLanguageSelectorDialog(
      title: 'Select Input Language',
      currentLanguage: _myInputLanguage,
      onLanguageSelected: (language) {
        setState(() {
          _myInputLanguage = language;
        });
        _updateTranslationLanguages();
      },
    );
  }

  void _showOutputLanguageSelector() {
    _showLanguageSelectorDialog(
      title: 'Select Output Language',
      currentLanguage: _myOutputLanguage,
      onLanguageSelected: (language) {
        setState(() {
          _myOutputLanguage = language;
        });
        _updateTranslationLanguages();
      },
    );
  }

  void _showLanguageSelectorDialog({
    required String title,
    required String currentLanguage,
    required Function(String) onLanguageSelected,
  }) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'it', 'name': 'Italian'},
      {'code': 'pt', 'name': 'Portuguese'},
      {'code': 'ru', 'name': 'Russian'},
      {'code': 'zh', 'name': 'Chinese'},
      {'code': 'ja', 'name': 'Japanese'},
      {'code': 'ko', 'name': 'Korean'},
      {'code': 'ar', 'name': 'Arabic'},
      {'code': 'hi', 'name': 'Hindi'},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final code = language['code']!;
                final name = language['name']!;
                final isSelected = code == currentLanguage;

                return ListTile(
                  title: Text(name),
                  subtitle: Text(code.toUpperCase()),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    onLanguageSelected(code);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateTranslationLanguages() {
    if (_translationService != null && widget.callId.isNotEmpty && widget.userId.isNotEmpty) {
      _translationService!.initializeForCall(
        callId: widget.callId,
        userId: widget.userId,
        inputLang: _myInputLanguage,
        outputLang: _myOutputLanguage,
        ablyKey: 'your_ably_key_here', // You should get this from your config
      );
    }
  }
}
