import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repositories.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

@lazySingleton
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String email,
    String otp,
  ) async {
    // Validation
    if (email.isEmpty || otp.isEmpty) {
      return const Left(ValidationFailure('Email and OTP are required'));
    }
    
    if (otp.length != 6) {
      return const Left(ValidationFailure('OTP must be 6 digits'));
    }
    
    return await repository.verifyOtp(email, otp);
  }
}
