import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lets_connect/core/constants/app_logger.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

// 🎯 AUTH REMOTE DATA SOURCE - API calls
// Handles all authentication-related network requests

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
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
        return UserModel.fromJson(response.data['user']);
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
  Future<UserModel> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      AppLogger.i('Attempting registration for: $email');
      
      final response = await dioClient.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        AppLogger.i('Registration successful');
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Registration error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected registration error', e);
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
}