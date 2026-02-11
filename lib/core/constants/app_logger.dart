import 'package:logger/logger.dart';

// 🔍 APP LOGGER - Beautiful, colored console logs
// Makes debugging easier with formatted output

class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  // Singleton logger instance
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,              // No stack trace for normal logs
      errorMethodCount: 5,         // Show 5 lines for errors
      lineLength: 50,              // Width of log output
      colors: true,                // Colored output
      printEmojis: true,           // Add emojis (🐛 for debug, ⚠️ for warning)
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,  // Show time
    ),
  );

  // 🐛 DEBUG - Development info
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // ℹ️ INFO - General information
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // ⚠️ WARNING - Something unexpected but not critical
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // ❌ ERROR - Something went wrong
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}