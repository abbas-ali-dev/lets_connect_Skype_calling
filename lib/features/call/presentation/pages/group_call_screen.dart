import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../../core/services/agora_service.dart';
import '../../../../core/services/ably_service.dart';
import '../../../../core/di/injections.dart';
import '../../domain/entities/group_call.dart';
import '../../domain/usecases/group_call_usecases.dart';

class GroupCallScreen extends StatefulWidget {
  final String callId;
  final String userId;
  final String username;
  final bool isVideoCall;
  final bool isHost;
  final GroupCall? initialGroupCall;

  const GroupCallScreen({
    super.key,
    required this.callId,
    required this.userId,
    required this.username,
    required this.isVideoCall,
    this.isHost = false,
    this.initialGroupCall,
  });

  @override
  State<GroupCallScreen> createState() => _GroupCallScreenState();
}

class _GroupCallScreenState extends State<GroupCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  Timer? _callTimer;
  int _callDuration = 0;
  AgoraService? _agoraService;
  AblyService? _ablyService;
  StreamSubscription? _callEndedSubscription;
  StreamSubscription? _participantUpdateSubscription;
  bool _isCallEnding = false;
  Map<int, String> _remoteUids = {}; // uid -> userId mapping
  Map<String, VideoViewController> _remoteVideoControllers = {}; // userId -> controller
  VideoViewController? _localViewController;

  @override
  void initState() {
    super.initState();
    _initializeCall();
    _startCallTimer();
  }

  Future<void> _initializeCall() async {
    try {
      print('🔄 Initializing group call services...');
      print('🔄 Call ID: ${widget.callId}');
      print('🔄 User ID: ${widget.userId}');
      
      // Create services
      _agoraService = AgoraService();
      _ablyService = getIt<AblyService>();
      
      // Initialize AblyService if not already initialized
      await _ablyService!.initialize('ZliWLA.MV5xLg:m68RKqPnByrQQOFuqh_R7SdpiiZGDAJOsmRa6Xs_nGU');
      await _agoraService!.initialize();
      
      // Listen for call events
      _listenForCallEvents();
      
      // Join the group call
      print('🔄 Joining group call...');
      final joinGroupCallUseCase = getIt<JoinGroupCallUseCase>();
      final result = await joinGroupCallUseCase(
        callId: widget.callId,
        userId: widget.userId,
      );
      
      result.fold(
        (failure) {
          print('❌ Failed to join group call: $failure');
          _endCall();
        },
        (joinData) {
          print('✅ Joined group call successfully');
          print('✅ Token: ${joinData['token']?.toString().substring(0, 20)}...');
          print('✅ Channel: ${joinData['channel']}');
          print('✅ UID: ${joinData['uid']}');
          _joinAgoraCall(joinData);
        },
      );
    } catch (e) {
      print('Error initializing group call: $e');
      _endCall();
    }
  }

  void _listenForCallEvents() {
    try {
      final channelName = 'call_${widget.callId}';
      print('🔄 Setting up group call event listeners for channel: $channelName');
      
      // Listen for call-ended events
      _callEndedSubscription = _ablyService!.onCallEvent(channelName, 'call-ended').listen((data) {
        print('🔴 Group call ended event received: $data');
        if (!_isCallEnding) {
          _endCall();
        }
      });
      
      // Listen for participant-left events
      _ablyService!.onCallEvent(channelName, 'participant-left').listen((data) {
        print('👋 Participant left event received: $data');
        final userId = data['userId'] as String?;
        final username = data['username'] as String?;
        
        if (userId != null && userId != widget.userId) {
          setState(() {
            // Remove participant's video controller
            _remoteVideoControllers.remove(userId);
            // Remove from UID mapping
            _remoteUids.removeWhere((key, value) => value == userId);
          });
          
          print('👋 Removed participant: $username ($userId)');
          
          // Show snackbar notification
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$username left the call'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      });
      
      // Listen for participant updates
      _participantUpdateSubscription = _ablyService!.onCallEvent(channelName, 'participant-updated').listen((data) {
        print('🔄 Participant update event received: $data');
        _handleParticipantUpdate(data);
      });
      
      print('✅ Group call event listeners setup completed');
    } catch (e) {
      print('❌ Error setting up group call event listeners: $e');
    }
  }

  void _handleParticipantUpdate(Map<String, dynamic> data) {
    // Handle participant join/leave, mute/unmute, video on/off
    final participantId = data['participantId'] as String?;
    final action = data['action'] as String?;
    
    if (participantId != null && action != null) {
      setState(() {
        // Update local participant state based on event
        switch (action) {
          case 'joined':
            // Refresh group call info to get updated participants
            _refreshGroupCallInfo();
            break;
          case 'left':
            // Remove participant video controller if exists
            _remoteVideoControllers.remove(participantId);
            // Refresh group call info
            _refreshGroupCallInfo();
            break;
          case 'muted':
          case 'unmuted':
          case 'video_on':
          case 'video_off':
            // Update participant status
            _refreshGroupCallInfo();
            break;
        }
      });
    }
  }

  Future<void> _refreshGroupCallInfo() async {
    try {
      // This would need a use case to get current group call info
      // For now, we'll skip this to keep the implementation simple
    } catch (e) {
      print('Error refreshing group call info: $e');
    }
  }

  Future<void> _joinAgoraCall(Map<String, dynamic> joinData) async {
    try {
      print('🔄 Joining Agora channel for group call...');
      
      // Join the Agora channel with the token
      await _agoraService!.joinChannel(
        token: joinData['token'],
        channelName: joinData['channel'],
        uid: joinData['uid'],
        isVideoCall: widget.isVideoCall,
      );
      
      // Initialize video controllers for video calls
      if (widget.isVideoCall) {
        _initializeVideoControllers(joinData['channel']);
      }
      
      print('✅ Successfully joined Agora group call');
    } catch (e) {
      print('❌ Error joining Agora group call: $e');
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
    _agoraService!.remoteUidStream.listen((uid) {
      setState(() {
        if (uid != null) {
          // Add new remote participant
          final userId = _getUserIdFromUid(uid);
          _remoteUids[uid] = userId;
          
          // Initialize remote video controller
          _remoteVideoControllers[userId] = VideoViewController.remote(
            rtcEngine: _agoraService!.engine!,
            connection: RtcConnection(channelId: channelName),
            canvas: VideoCanvas(uid: uid, sourceType: VideoSourceType.videoSourceCamera),
          );
        } else {
          // Handle user leaving
          final removedUid = _remoteUids.keys.firstWhere((k) => _remoteUids[k] == null, orElse: () => -1);
          if (removedUid != -1) {
            final userId = _remoteUids[removedUid];
            _remoteVideoControllers.remove(userId);
            _remoteUids.remove(removedUid);
          }
        }
      });
    });
  }

  String _getUserIdFromUid(int uid) {
    // This is a placeholder - in a real implementation, you'd map UIDs to user IDs
    // For now, we'll use the UID as a string
    return uid.toString();
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
    _participantUpdateSubscription?.cancel();
    _localViewController?.dispose();
    _remoteVideoControllers.values.forEach((controller) => controller.dispose());
    _agoraService?.leaveChannel();
    _isCallEnding = false;
    super.dispose();
  }

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    _agoraService?.muteLocalAudioStream(_isMuted);
    
    // Update participant status
    await _updateParticipantStatus();
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    _agoraService?.setEnableSpeakerphone(_isSpeakerOn).catchError((e) {
      print('Error toggling speakerphone: $e');
    });
  }

  void _toggleVideo() async {
    setState(() {
      _isVideoOn = !_isVideoOn;
    });
    _agoraService?.muteLocalVideoStream(!_isVideoOn);
    
    // Update participant status
    await _updateParticipantStatus();
  }

  void _switchCamera() {
    _agoraService?.switchCamera();
  }

  Future<void> _updateParticipantStatus() async {
    try {
      final updateStatusUseCase = getIt<UpdateParticipantStatusUseCase>();
      await updateStatusUseCase(
        callId: widget.callId,
        userId: widget.userId,
        isMuted: _isMuted,
        isVideoOn: _isVideoOn,
      );
    } catch (e) {
      print('Error updating participant status: $e');
    }
  }

  void _endCall() async {
    if (_isCallEnding) return;
    
    _isCallEnding = true;
    
    try {
      print('🔴 ENDING GROUP CALL: ${widget.callId}');
      
      // Notify all participants that this user is leaving
      try {
        final channelName = 'call_${widget.callId}';
        await _ablyService?.publishMessage(
          channelName,
          'participant-left',
          {
            'callId': widget.callId,
            'userId': widget.userId,
            'username': widget.username,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        print('✅ Notified participants that ${widget.username} left');
      } catch (e) {
        print('⚠️ Failed to notify participants: $e');
      }
      
      // Leave group call on backend
      final leaveGroupCallUseCase = getIt<LeaveGroupCallUseCase>();
      final result = await leaveGroupCallUseCase(
        callId: widget.callId,
        userId: widget.userId,
      );
      
      result.fold(
        (failure) => print('Failed to leave group call: $failure'),
        (success) => print('Left group call successfully'),
      );
      
      // If this is the host or last person, end the call for everyone
      if (widget.isHost || _remoteVideoControllers.isEmpty) {
        try {
          final channelName = 'call_${widget.callId}';
          await _ablyService?.publishMessage(
            channelName,
            'call-ended',
            {
              'callId': widget.callId,
              'endedBy': widget.userId,
              'reason': widget.isHost ? 'host_ended' : 'last_participant_left',
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
          print('✅ Broadcast call-ended event to all participants');
        } catch (e) {
          print('⚠️ Failed to broadcast call-ended event: $e');
        }
      }
      
      // Leave Agora channel
      await _agoraService?.leaveChannel();
      
      // Navigate back
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error ending group call: $e');
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_formatDuration(_callDuration)} • ${_remoteVideoControllers.length + 1} participants',
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
              child: _buildControlButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView() {
    return Stack(
      children: [
        // Main video area - show remote participants or placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _remoteVideoControllers.isNotEmpty
              ? _buildRemoteVideoGrid()
              : _buildWaitingScreen(),
        ),
        // Local video (picture-in-picture)
        if (_localViewController != null)
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
                child: AgoraVideoView(controller: _localViewController!),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRemoteVideoGrid() {
    final participants = _remoteVideoControllers.entries.toList();
    
    if (participants.length == 1) {
      // Single participant - full screen
      return AgoraVideoView(controller: participants.first.value);
    } else if (participants.length == 2) {
      // Two participants - split screen
      return Row(
        children: participants.map((entry) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AgoraVideoView(controller: entry.value),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Multiple participants - grid layout
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(2),
        children: participants.map((entry) {
          return Container(
            margin: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AgoraVideoView(controller: entry.value),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[700],
            child: const Icon(
              Icons.group,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Group Call',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Waiting for participants...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[700],
            child: const Icon(
              Icons.group,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Group Audio Call',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_remoteVideoControllers.length + 1} participants',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
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
}
