import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_user.dart';
import '../repositories/chat_repository.dart';

// 🎯 SEARCH USER USE CASE - Business logic for searching users
// Single responsibility: Search for a user by email

@lazySingleton
class SearchUserUseCase {
  final ChatRepository repository;

  SearchUserUseCase(this.repository);

  Future<Either<Failure, ChatUser>> call(String email) async {
    if (email.isEmpty) {
      return Left(ValidationFailure('Email cannot be empty'));
    }

    if (!_isValidEmail(email)) {
      return Left(ValidationFailure('Invalid email format'));
    }

    return await repository.searchUserByEmail(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
