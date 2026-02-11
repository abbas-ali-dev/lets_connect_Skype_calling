import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repositories.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class ForgetPasswordUseCase {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    // Validation
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }
    
    if (!email.contains('@')) {
      return const Left(ValidationFailure('Invalid email format'));
    }
    
    return await repository.forgetPassword(email);
  }
}
