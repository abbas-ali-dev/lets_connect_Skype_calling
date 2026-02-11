import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repositories.dart';

// 🎯 LOGIN USE CASE - Single responsibility: Login user

@lazySingleton
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    // Validation
    if (email.isEmpty || password.isEmpty) {
      return const Left(ValidationFailure('Email and password are required'));
    }
    
    // Call repository
    return await repository.login(email, password);
  }
}