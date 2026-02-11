import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';

@LazySingleton()
class CallRemoteDataSource {
  final Dio _dio;

  CallRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> initiateCall(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/call/initiate', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> acceptCall(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/call/accept', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> rejectCall(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/call/reject', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endCall(Map<String, dynamic> body) async {
    final response = await _dio.post('/call/end', data: body);
    if (response.data == null) {
      throw ServerException('End call response is null', statusCode: response.statusCode);
    }
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinCall(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/call/join', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> setCallLanguage(
    List<Map<String, dynamic>> body,
  ) async {
    final response = await _dio.post('/call/language', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateAgoraToken(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/call/agora-token', data: body);
    return response.data as Map<String, dynamic>;
  }

  // Group Call Methods (using existing endpoints)
  Future<Map<String, dynamic>> initiateGroupCall(
    Map<String, dynamic> body,
  ) async {
    // Use the existing /call/initiate endpoint with group call parameters
    final response = await _dio.post('/call/initiate', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinGroupCall(
    Map<String, dynamic> body,
  ) async {
    // Use the existing /call/join endpoint
    final response = await _dio.post('/call/join', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> leaveGroupCall(
    Map<String, dynamic> body,
  ) async {
    // Use the existing /call/end endpoint for leaving group calls
    final response = await _dio.post('/call/end', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getGroupCallInfo(
    String callId,
  ) async {
    // For now, return a basic response. This might need a backend implementation
    return {
      'success': true,
      'groupCall': {
        'id': callId,
        'participants': [],
      }
    };
  }

  Future<Map<String, dynamic>> updateParticipantStatus(
    Map<String, dynamic> body,
  ) async {
    // This might need a backend implementation. For now, return success
    return {
      'success': true,
    };
  }

  // Translation Methods
  Future<Map<String, dynamic>> sendTranslation(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/translation/audio/translate', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSupportedLanguages() async {
    final response = await _dio.get('/translation/languages');
    return response.data as Map<String, dynamic>;
  }
}
