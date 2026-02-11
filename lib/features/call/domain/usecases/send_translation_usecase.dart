import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class SendTranslationUseCase {
  final CallRepository repository;

  SendTranslationUseCase(this.repository);

  Future<Either<Failure, CallTranslation>> call({
    required String callId,
    required String userId,
    required String text,
  }) async {
    return await repository.sendTranslation(
      callId: callId,
      userId: userId,
      text: text,
    );
  }
}
