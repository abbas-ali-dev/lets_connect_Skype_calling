import 'package:equatable/equatable.dart';

// 🎯 AUTH EVENTS - User actions that trigger state changes

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Login event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Signup event - Request OTP
class SignupEvent extends AuthEvent {
  final String email;
  final String username;
  final String phone;
  final String password;

  const SignupEvent({
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [email, username, phone, password];
}

// Verify OTP event
class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

// Forget Password event
class ForgetPasswordEvent extends AuthEvent {
  final String email;

  const ForgetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

// Reset Password event
class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

// Logout event
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

// Check if logged in event
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}