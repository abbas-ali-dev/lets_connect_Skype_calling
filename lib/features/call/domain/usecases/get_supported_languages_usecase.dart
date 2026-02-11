import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/call_repository.dart';

@LazySingleton()
class GetSupportedLanguagesUseCase {
  final CallRepository repository;

  GetSupportedLanguagesUseCase(this.repository);

  Future<Either<Failure, List<SupportedLanguage>>> call() async {
    return await repository.getSupportedLanguages();
  }
}
