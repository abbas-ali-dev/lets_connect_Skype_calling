import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lets_connect/core/constants/app_logger.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

// 🎯 AUTH LOCAL DATA SOURCE - Local storage
// Handles secure storage of tokens and user data

abstract class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> saveUserId(String userId);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserId();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.keyAccessToken,
        value: token,
      );
      AppLogger.d('Access token saved');
    } catch (e) {
      AppLogger.e('Failed to save access token', e);
      throw CacheException('Failed to save access token');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.keyRefreshToken,
        value: token,
      );
      AppLogger.d('Refresh token saved');
    } catch (e) {
      AppLogger.e('Failed to save refresh token', e);
      throw CacheException('Failed to save refresh token');
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await secureStorage.write(
        key: AppConstants.keyUserId,
        value: userId,
      );
      AppLogger.d('User ID saved');
    } catch (e) {
      AppLogger.e('Failed to save user ID', e);
      throw CacheException('Failed to save user ID');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyAccessToken);
    } catch (e) {
      AppLogger.e('Failed to get access token', e);
      throw CacheException('Failed to get access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyRefreshToken);
    } catch (e) {
      AppLogger.e('Failed to get refresh token', e);
      throw CacheException('Failed to get refresh token');
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return await secureStorage.read(key: AppConstants.keyUserId);
    } catch (e) {
      AppLogger.e('Failed to get user ID', e);
      throw CacheException('Failed to get user ID');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await secureStorage.delete(key: AppConstants.keyAccessToken);
      await secureStorage.delete(key: AppConstants.keyRefreshToken);
      await secureStorage.delete(key: AppConstants.keyUserId);
      AppLogger.i('Auth data cleared');
    } catch (e) {
      AppLogger.e('Failed to clear auth data', e);
      throw CacheException('Failed to clear auth data');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}