import 'package:equatable/equatable.dart';

class Call extends Equatable {
  final String id;
  final String callerId;
  final String receiverId;
  final String type;
  final String status;
  final String channelName;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? endedAt;
  final int? duration;

  const Call({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.channelName,
    required this.createdAt,
    this.acceptedAt,
    this.endedAt,
    this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        callerId,
        receiverId,
        type,
        status,
        channelName,
        createdAt,
        acceptedAt,
        endedAt,
        duration,
      ];
}
