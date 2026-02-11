import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lets_connect/core/constants/app_logger.dart';
import 'package:lets_connect/features/auth/domain/usecases/login_usecases.dart';
import 'package:lets_connect/features/auth/domain/usecases/logoutusecase.dart';
import 'package:lets_connect/features/auth/presentation/bloc/auth_state/auth_state.dart';


import '../../domain/usecases/register_usecases.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/forget_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'auth_event.dart';
// 🎯 AUTH BLOC - Handles authentication business logic and state

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.verifyOtpUseCase,
    required this.forgetPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ForgetPasswordEvent>(_onForgetPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  // Handle login event
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Login event received for: ${event.email}');
    emit(const AuthLoading());

    final result = await loginUseCase.call(event.email, event.password);

    result.fold(
      (failure) {
        AppLogger.e('Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        AppLogger.i('Login successful: ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Handle signup event - Request OTP
  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Signup event received for: ${event.email}');
    emit(const AuthLoading());

    final result = await signupUseCase.call(
      event.email,
      event.username,
      event.phone,
      event.password,
    );

    result.fold(
      (failure) {
        AppLogger.e('Signup failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (message) {
        AppLogger.i('OTP sent successfully');
        emit(AuthOtpSent(message, event.email));
      },
    );
  }

  // Handle verify OTP event
  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Verify OTP event received for: ${event.email}');
    emit(const AuthLoading());

    final result = await verifyOtpUseCase.call(event.email, event.otp);

    result.fold(
      (failure) {
        AppLogger.e('OTP verification failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        AppLogger.i('OTP verified successfully: ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // Handle forget password event
  Future<void> _onForgetPassword(ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Forget password event received for: ${event.email}');
    emit(const AuthLoading());

    final result = await forgetPasswordUseCase.call(event.email);

    result.fold(
      (failure) {
        AppLogger.e('Forget password failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (message) {
        AppLogger.i('Password reset OTP sent successfully');
        emit(AuthPasswordResetOtpSent(message, event.email));
      },
    );
  }

  // Handle reset password event
  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Reset password event received for: ${event.email}');
    emit(const AuthLoading());

    final result = await resetPasswordUseCase.call(
      event.email,
      event.otp,
      event.newPassword,
    );

    result.fold(
      (failure) {
        AppLogger.e('Password reset failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        AppLogger.i('Password reset successful');
        emit(const AuthPasswordResetSuccess());
      },
    );
  }

  // Handle logout event
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    AppLogger.i('Logout event received');
    emit(const AuthLoading());

    final result = await logoutUseCase.call();

    result.fold(
      (failure) {
        AppLogger.e('Logout failed: ${failure.message}');
        // Even if logout fails, go to unauthenticated state
        emit(const AuthUnauthenticated());
      },
      (_) {
        AppLogger.i('Logout successful');
        emit(const AuthUnauthenticated());
      },
    );
  }

  // Handle check auth status event
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i('Checking auth status');
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase.call();

    result.fold(
      (failure) {
        AppLogger.e('Auth status check failed: ${failure.message}');
        emit(const AuthUnauthenticated());
      },
      (user) {
        if (user != null) {
          AppLogger.i('User is authenticated: ${user.id}');
          emit(AuthAuthenticated(user));
        } else {
          AppLogger.i('User is not authenticated');
          emit(const AuthUnauthenticated());
        }
      },
    );
  }
}