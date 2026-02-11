import 'package:equatable/equatable.dart';

// 🎯 FAILURES - Returned to the UI Layer
// These are user-friendly errors that the UI can display

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server-related failures (API errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

/// Cache-related failures (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.statusCode});
}

/// Network-related failures (no internet)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.statusCode});
}

/// Validation failures (invalid input)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.statusCode});
}

/// Authentication failures (not logged in)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.statusCode});
}

/// Unknown failures (unexpected errors)
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.statusCode});
}