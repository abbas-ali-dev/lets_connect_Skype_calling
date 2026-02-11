import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_logger.dart';
import '../config/agora_config.dart';

@LazySingleton()
class AgoraService {
  RtcEngine? _engine;
  bool _isInitialized = false;
  int? _remoteUid;
  final StreamController<int?> _remoteUidController = StreamController.broadcast();

  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;
  int? get remoteUid => _remoteUid;
  Stream<int?> get remoteUidStream => _remoteUidController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _engine = createAgoraRtcEngine();
      
      await _engine!.initialize(RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            AppLogger.i('Joined channel: ${connection.channelId}');
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            AppLogger.i('User joined: $remoteUid');
            _remoteUid = remoteUid;
            _remoteUidController.add(remoteUid);
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            AppLogger.i('User offline: $remoteUid');
            _remoteUid = null;
            _remoteUidController.add(null);
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            AppLogger.i('Left channel: ${connection.channelId}');
            _remoteUid = null;
            _remoteUidController.add(null);
          },
          onRemoteVideoStateChanged: (
            RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed,
          ) {
            AppLogger.i('Remote video state changed: $remoteUid - $state');
          },
          onError: (ErrorCodeType err, String msg) {
            AppLogger.e('Agora error: $err - $msg');
          },
        ),
      );

      _isInitialized = true;
      AppLogger.i('Agora service initialized successfully');
    } catch (e) {
      AppLogger.e('Failed to initialize Agora service: $e');
      rethrow;
    }
  }

  Future<bool> requestPermissions({required bool isVideoCall}) async {
    final permissions = <Permission>[Permission.microphone];
    if (isVideoCall) {
      permissions.add(Permission.camera);
    }

    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> enableAudio() async {
    await _engine?.enableAudio();
  }

  Future<void> disableAudio() async {
    await _engine?.disableAudio();
  }

  Future<void> enableVideo() async {
    await _engine?.enableVideo();
    await _engine?.startPreview();
  }

  Future<void> disableVideo() async {
    await _engine?.stopPreview();
    await _engine?.disableVideo();
  }

  Future<void> muteLocalAudioStream(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> muteLocalVideoStream(bool muted) async {
    await _engine?.muteLocalVideoStream(muted);
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> setEnableSpeakerphone(bool enabled) async {
    await _engine?.setEnableSpeakerphone(enabled);
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    required bool isVideoCall,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final hasPermissions = await requestPermissions(isVideoCall: isVideoCall);
      if (!hasPermissions) {
        throw Exception('Required permissions not granted');
      }

      if (isVideoCall) {
        await enableVideo();
      } else {
        await enableAudio();
      }

      final options = ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishMicrophoneTrack: true,
        publishCameraTrack: isVideoCall,
        autoSubscribeAudio: true,
        autoSubscribeVideo: isVideoCall,
      );

      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: options,
      );

      AppLogger.i('Joined Agora channel: $channelName');
    } catch (e) {
      AppLogger.e('Failed to join channel: $e');
      rethrow;
    }
  }

  Future<void> leaveChannel() async {
    try {
      await _engine?.leaveChannel();
      await _engine?.stopPreview();
      AppLogger.i('Left Agora channel');
    } catch (e) {
      AppLogger.e('Failed to leave channel: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await leaveChannel();
      await _engine?.release();
      _engine = null;
      _isInitialized = false;
      _remoteUidController.close();
      AppLogger.i('Agora service disposed');
    } catch (e) {
      AppLogger.e('Error disposing Agora service: $e');
    }
  }
}
