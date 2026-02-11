import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/call.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class EndCallUseCase {
  final CallRepository repository;

  EndCallUseCase({required this.repository});

  Future<Either<Failure, Call>> call({
    required String callId,
  }) async {
    return await repository.endCall(callId: callId);
  }
}
