import 'package:equatable/equatable.dart';
import 'package:lets_connect/features/auth/domain/entities/user.dart';


// 🎯 AUTH STATES - Different states of authentication

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading state (during API calls)
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Authenticated state (user logged in)
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Unauthenticated state (user not logged in)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// OTP sent state
class AuthOtpSent extends AuthState {
  final String message;
  final String email;

  const AuthOtpSent(this.message, this.email);

  @override
  List<Object?> get props => [message, email];
}

// Password reset OTP sent state
class AuthPasswordResetOtpSent extends AuthState {
  final String message;
  final String email;

  const AuthPasswordResetOtpSent(this.message, this.email);

  @override
  List<Object?> get props => [message, email];
}

// Password reset success state
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}