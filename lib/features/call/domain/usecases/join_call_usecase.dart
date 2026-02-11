import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/agora_token.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class JoinCallUseCase {
  final CallRepository repository;

  JoinCallUseCase({required this.repository});

  Future<Either<Failure, AgoraToken>> call({
    required String callId,
    required String userId,
  }) async {
    return await repository.joinCall(
      callId: callId,
      userId: userId,
    );
  }
}
