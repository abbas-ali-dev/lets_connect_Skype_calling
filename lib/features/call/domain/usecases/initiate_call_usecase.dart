import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/call.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class InitiateCallUseCase {
  final CallRepository repository;

  InitiateCallUseCase({required this.repository});

  Future<Either<Failure, Call>> call({
    required String callerId,
    required String receiverId,
    required String type,
  }) async {
    return await repository.initiateCall(
      callerId: callerId,
      receiverId: receiverId,
      type: type,
    );
  }
}
