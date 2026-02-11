// 🎯 APP CONSTANTS - Centralized configuration
// All app-wide constants in one place for easy management

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ============ API Configuration ============
  static const String baseUrl = 'https://api.letsconnect.com';
  static const int connectionTimeout = 30000;  // 30 seconds
  static const int receiveTimeout = 30000;     // 30 seconds

  // ============ Storage Keys ============
  // Used for SharedPreferences and SecureStorage
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';

  // ============ App Information ============
  static const String appName = 'Let\'s Connect';
  static const String appVersion = '1.0.0';

  // ============ Pagination ============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============ Media ============
  static const int maxImageSizeMB = 5;
  static const int maxVideoSizeMB = 50;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi'];

  // ============ Call Settings ============
  static const int maxCallDurationMinutes = 60;
  static const int callRingDurationSeconds = 30;
}