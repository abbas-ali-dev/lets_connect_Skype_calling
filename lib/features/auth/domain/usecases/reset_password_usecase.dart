import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repositories.dart';

import '../../../../core/error/failures.dart';

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String email,
    String otp,
    String newPassword,
  ) async {
    // Validation
    if (email.isEmpty || otp.isEmpty || newPassword.isEmpty) {
      return const Left(ValidationFailure('All fields are required'));
    }
    
    if (otp.length != 6) {
      return const Left(ValidationFailure('OTP must be 6 digits'));
    }
    
    if (newPassword.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }
    
    return await repository.resetPassword(email, otp, newPassword);
  }
}
