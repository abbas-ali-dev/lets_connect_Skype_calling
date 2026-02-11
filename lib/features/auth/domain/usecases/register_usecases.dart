import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repositories.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, String>> call(
    String email,
    String username,
    String phone,
    String password,
  ) async {
    // Validation
    if (email.isEmpty || password.isEmpty || username.isEmpty || phone.isEmpty) {
      return const Left(ValidationFailure('All fields are required'));
    }
    
    if (password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }
    
    if (!email.contains('@')) {
      return const Left(ValidationFailure('Invalid email format'));
    }
    
    return await repository.signup(email, username, phone, password);
  }
}