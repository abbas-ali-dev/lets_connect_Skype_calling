import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_logger.dart';

@LazySingleton()
class FCMRemoteDataSource {
  final Dio _dio;

  FCMRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> registerToken({
    required String userId,
    required String token,
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      final response = await _dio.post(
        '/fcm/register',
        data: {
          'userId': userId,
          'token': token,
          'deviceInfo': deviceInfo,
        },
      );
      AppLogger.i('✅ FCM token registered with backend: ${response.data}');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e('❌ Failed to register FCM token: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> removeToken({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await _dio.delete(
        '/fcm/remove',
        data: {
          'userId': userId,
          'token': token,
        },
      );
      AppLogger.i('✅ FCM token removed from backend: ${response.data}');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e('❌ Failed to remove FCM token: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserTokens(String userId) async {
    try {
      final response = await _dio.get('/fcm/tokens/$userId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      AppLogger.e('❌ Failed to get user tokens: $e');
      rethrow;
    }
  }
}
