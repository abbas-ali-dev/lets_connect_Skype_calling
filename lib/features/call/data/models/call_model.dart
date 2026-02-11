import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/call.dart';

part 'call_model.freezed.dart';
part 'call_model.g.dart';

@freezed
class CallModel with _$CallModel {
  const factory CallModel({
    required String id,
    @JsonKey(name: 'callerId') required String callerId,
    @JsonKey(name: 'receiverId') required String receiverId,
    required String type,
    required String status,
    @JsonKey(name: 'channelName') required String channelName,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'accepted_at') String? acceptedAt,
    @JsonKey(name: 'ended_at') String? endedAt,
    int? duration,
  }) = _CallModel;

  factory CallModel.fromJson(Map<String, dynamic> json) =>
      _$CallModelFromJson(json);
}

extension CallModelX on CallModel {
  Call toEntity() {
    return Call(
      id: id,
      callerId: callerId,
      receiverId: receiverId,
      type: type,
      status: status,
      channelName: channelName,
      createdAt: DateTime.parse(createdAt),
      acceptedAt: acceptedAt != null ? DateTime.parse(acceptedAt!) : null,
      endedAt: endedAt != null ? DateTime.parse(endedAt!) : null,
      duration: duration,
    );
  }
}
