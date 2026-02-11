import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

// 🎯 AUTH REPOSITORY INTERFACE - Contract
// Defines WHAT the repository must do (not HOW)

abstract class AuthRepository {
  // Login user
  Future<Either<Failure, User>> login(String email, String password);
  
  // Signup - Request OTP
  Future<Either<Failure, String>> signup(
    String email,
    String username,
    String phone,
    String password,
  );
  
  // Verify OTP - Complete Signup
  Future<Either<Failure, User>> verifyOtp(String email, String otp);
  
  // Forget Password - Request OTP
  Future<Either<Failure, String>> forgetPassword(String email);
  
  // Reset Password
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
  
  // Logout user
  Future<Either<Failure, void>> logout();
  
  // Check if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();
  
  // Check auth status and return user data if logged in
  Future<Either<Failure, User?>> checkAuthStatus();
  
  // Get Ably Token
  Future<Either<Failure, Map<String, dynamic>>> getAblyToken();
}