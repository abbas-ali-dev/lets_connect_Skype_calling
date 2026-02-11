import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/call.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class RejectCallUseCase {
  final CallRepository repository;

  RejectCallUseCase({required this.repository});

  Future<Either<Failure, Call>> call({
    required String callId,
    required String receiverId,
  }) async {
    return await repository.rejectCall(
      callId: callId,
      receiverId: receiverId,
    );
  }
}
