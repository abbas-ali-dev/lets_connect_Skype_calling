import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AblyAuthRemoteDataSource {
  final Dio _dio;

  AblyAuthRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> getAblyToken(String userId) async {
    final response = await _dio.post(
      '/call/ably-token',
      data: {'userId': userId},
    );
    return response.data as Map<String, dynamic>;
  }
}
