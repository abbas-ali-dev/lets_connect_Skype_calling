// 🎯 EXCEPTIONS - Thrown in the Data Layer
// These are technical errors that happen during data operations

/// Thrown when the API returns an error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Thrown when local storage operations fail
class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there's no internet connection
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when user is not authorized
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}