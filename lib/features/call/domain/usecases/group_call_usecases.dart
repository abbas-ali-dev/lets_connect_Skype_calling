import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/group_call.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class InitiateGroupCallUseCase {
  final CallRepository repository;

  InitiateGroupCallUseCase({required this.repository});

  Future<Either<Failure, GroupCall>> call({
    required String hostId,
    required String roomId,
    required String type,
  }) async {
    return await repository.initiateGroupCall(
      hostId: hostId,
      roomId: roomId,
      type: type,
    );
  }
}

@LazySingleton()
class JoinGroupCallUseCase {
  final CallRepository repository;

  JoinGroupCallUseCase({required this.repository});

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String callId,
    required String userId,
  }) async {
    return await repository.joinGroupCall(
      callId: callId,
      userId: userId,
    );
  }
}

@LazySingleton()
class LeaveGroupCallUseCase {
  final CallRepository repository;

  LeaveGroupCallUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String callId,
    required String userId,
  }) async {
    return await repository.leaveGroupCall(
      callId: callId,
      userId: userId,
    );
  }
}

@LazySingleton()
class GetGroupCallInfoUseCase {
  final CallRepository repository;

  GetGroupCallInfoUseCase({required this.repository});

  Future<Either<Failure, GroupCall>> call({
    required String callId,
  }) async {
    return await repository.getGroupCallInfo(callId: callId);
  }
}

@LazySingleton()
class UpdateParticipantStatusUseCase {
  final CallRepository repository;

  UpdateParticipantStatusUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String callId,
    required String userId,
    required bool isMuted,
    required bool isVideoOn,
  }) async {
    return await repository.updateParticipantStatus(
      callId: callId,
      userId: userId,
      isMuted: isMuted,
      isVideoOn: isVideoOn,
    );
  }
}
