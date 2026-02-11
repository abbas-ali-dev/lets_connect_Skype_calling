import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/call.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class AcceptCallUseCase {
  final CallRepository repository;

  AcceptCallUseCase({required this.repository});

  Future<Either<Failure, Call>> call({
    required String callId,
    required String receiverId,
  }) async {
    return await repository.acceptCall(
      callId: callId,
      receiverId: receiverId,
    );
  }
}
