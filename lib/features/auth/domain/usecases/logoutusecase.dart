import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repositories.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}