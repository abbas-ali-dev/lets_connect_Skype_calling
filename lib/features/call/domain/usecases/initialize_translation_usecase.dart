import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class InitializeTranslationUseCase {
  final CallRepository repository;

  InitializeTranslationUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String callId,
    required String userId,
    required String inputLang,
    required String outputLang,
  }) async {
    return await repository.setCallLanguage(
      callId: callId,
      userId: userId,
      inputLang: inputLang,
      outputLang: outputLang,
    );
  }
}
