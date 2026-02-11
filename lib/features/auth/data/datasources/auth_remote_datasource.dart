import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_logger.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

// 🎯 AUTH REMOTE DATA SOURCE - API calls
// Handles all authentication-related network requests

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<String> signup(String email, String username, String phone, String password);
  Future<UserModel> verifyOtp(String email, String otp);
  Future<String> forgetPassword(String email);
  Future<void> resetPassword(String email, String otp, String newPassword);
  Future<void> logout();
  Future<Map<String, dynamic>> getAblyToken();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      AppLogger.i('Attempting login for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Login successful');
        final user = response.data['user'];
        final token = response.data['token'];
        
        // Create user model with token
        return UserModel(
          id: user['id'],
          email: user['email'],
          username: user['username'],
          phone: user['phone'],
          token: token,
        );
      } else {
        throw ServerException(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Login error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected login error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signup(
    String email,
    String username,
    String phone,
    String password,
  ) async {
    try {
      AppLogger.i('Attempting signup for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/signup',
        data: {
          'email': email,
          'username': username,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('OTP sent successfully');
        return response.data['message'] ?? 'OTP sent to your email';
      } else {
        throw ServerException(
          'Signup failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Signup error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected signup error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    try {
      AppLogger.i('Verifying OTP for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('OTP verified successfully');
        final profile = response.data['profile'];
        return UserModel(
          id: profile['id'],
          email: profile['email'],
          username: profile['username'],
          phone: profile['phone'],
          token: response.data['token'],
        );
      } else {
        throw ServerException(
          'OTP verification failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('OTP verification error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected OTP verification error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> forgetPassword(String email) async {
    try {
      AppLogger.i('Requesting password reset for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/forget-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Password reset OTP sent');
        return response.data['message'] ?? 'OTP sent to your email';
      } else {
        throw ServerException(
          'Password reset request failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Forget password error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected forget password error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    try {
      AppLogger.i('Resetting password for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Password reset successful');
      } else {
        throw ServerException(
          'Password reset failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Reset password error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected reset password error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.i('Attempting logout');
      
      await dioClient.dio.post('/auth/logout');
      
      AppLogger.i('Logout successful');
    } on DioException catch (e) {
      AppLogger.e('Logout error', e);
      // Even if logout fails on server, we'll clear local data
    }
  }

  @override
  Future<Map<String, dynamic>> getAblyToken() async {
    try {
      AppLogger.i('Requesting Ably token');
      
      final response = await dioClient.dio.get('/auth/ably-token');

      if (response.statusCode == 200) {
        AppLogger.i('Ably token retrieved successfully');
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(
          'Failed to get Ably token',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get Ably token error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected Ably token error', e);
      throw ServerException(e.toString());
    }
  }
}
