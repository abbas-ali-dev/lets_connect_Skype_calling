import 'package:equatable/equatable.dart';

class GroupCall extends Equatable {
  final String id;
  final String hostId;
  final String roomId;
  final String type; // 'audio' or 'video'
  final String status; // 'initiated', 'active', 'ended'
  final String channelName;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;
  final List<GroupCallParticipant> participants;
  final Map<String, dynamic>? settings;

  const GroupCall({
    required this.id,
    required this.hostId,
    required this.roomId,
    required this.type,
    required this.status,
    required this.channelName,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.participants = const [],
    this.settings,
  });

  @override
  List<Object?> get props => [
        id,
        hostId,
        roomId,
        type,
        status,
        channelName,
        createdAt,
        startedAt,
        endedAt,
        duration,
        participants,
        settings,
      ];

  GroupCall copyWith({
    String? id,
    String? hostId,
    String? roomId,
    String? type,
    String? status,
    String? channelName,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
    List<GroupCallParticipant>? participants,
    Map<String, dynamic>? settings,
  }) {
    return GroupCall(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      roomId: roomId ?? this.roomId,
      type: type ?? this.type,
      status: status ?? this.status,
      channelName: channelName ?? this.channelName,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      participants: participants ?? this.participants,
      settings: settings ?? this.settings,
    );
  }

  int get activeParticipantCount {
    return participants.where((p) => p.isActive).length;
  }

  bool get isActive => status == 'active';
  bool get isEnded => status == 'ended';
}

class GroupCallParticipant extends Equatable {
  final String userId;
  final String username;
  final String? avatar;
  final bool isActive;
  final bool isMuted;
  final bool isVideoOn;
  final DateTime? joinedAt;
  final DateTime? leftAt;

  const GroupCallParticipant({
    required this.userId,
    required this.username,
    this.avatar,
    this.isActive = false,
    this.isMuted = false,
    this.isVideoOn = false,
    this.joinedAt,
    this.leftAt,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        avatar,
        isActive,
        isMuted,
        isVideoOn,
        joinedAt,
        leftAt,
      ];

  GroupCallParticipant copyWith({
    String? userId,
    String? username,
    String? avatar,
    bool? isActive,
    bool? isMuted,
    bool? isVideoOn,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) {
    return GroupCallParticipant(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      isMuted: isMuted ?? this.isMuted,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
    );
  }
}
