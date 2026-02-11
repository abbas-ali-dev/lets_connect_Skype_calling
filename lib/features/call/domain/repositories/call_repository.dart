import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/call.dart';
import '../entities/agora_token.dart';
import '../entities/group_call.dart';
import '../entities/translation.dart';

abstract class CallRepository {
  Future<Either<Failure, Call>> initiateCall({
    required String callerId,
    required String receiverId,
    required String type,
  });

  Future<Either<Failure, Call>> acceptCall({
    required String callId,
    required String receiverId,
  });

  Future<Either<Failure, Call>> rejectCall({
    required String callId,
    required String receiverId,
  });

  Future<Either<Failure, Call>> endCall({
    required String callId,
  });

  Future<Either<Failure, AgoraToken>> joinCall({
    required String callId,
    required String userId,
  });

  Future<Either<Failure, void>> setCallLanguage({
    required String callId,
    required String userId,
    required String inputLang,
    required String outputLang,
  });

  Future<Either<Failure, String>> generateAgoraToken({
    required String channelName,
    required int uid,
  });

  // Group Call Methods
  Future<Either<Failure, GroupCall>> initiateGroupCall({
    required String hostId,
    required String roomId,
    required String type,
  });

  Future<Either<Failure, Map<String, dynamic>>> joinGroupCall({
    required String callId,
    required String userId,
  });

  Future<Either<Failure, void>> leaveGroupCall({
    required String callId,
    required String userId,
  });

  Future<Either<Failure, GroupCall>> getGroupCallInfo({
    required String callId,
  });

  Future<Either<Failure, void>> updateParticipantStatus({
    required String callId,
    required String userId,
    required bool isMuted,
    required bool isVideoOn,
  });

  // Translation Methods
  Future<Either<Failure, CallTranslation>> sendTranslation({
    required String callId,
    required String userId,
    required String text,
  });

  Future<Either<Failure, List<SupportedLanguage>>> getSupportedLanguages();
}
