import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// 🌐 DIO CLIENT - Handles all HTTP requests
// This is a singleton that configures Dio with interceptors and logging

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        // TODO: Replace with your actual API URL
        baseUrl: 'https://lets-connect-sooty.vercel.app/api',
        
        // Timeout settings (30 seconds)
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        
        // Default headers for all requests
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logger interceptor (only shows in debug mode)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,   // Show request headers
        requestBody: true,     // Show request body
        responseBody: true,    // Show response body
        responseHeader: false, // Hide response headers (too verbose)
        error: true,           // Show errors
        compact: true,         // Compact format
      ),
    );
  }

  // Getter to access the Dio instance
  Dio get dio => _dio;

  // Set authentication token after login
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authentication token on logout
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}