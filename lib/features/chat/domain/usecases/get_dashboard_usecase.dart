import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/room.dart';
import '../repositories/chat_repository.dart';

// 🎯 GET DASHBOARD USE CASE - Business logic for getting user's chat dashboard
// Single responsibility: Get all chats for a user with last messages

@lazySingleton
class GetDashboardUseCase {
  final ChatRepository repository;

  GetDashboardUseCase(this.repository);

  Future<Either<Failure, List<Room>>> call(String userId) async {
    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.getDashboard(userId);
  }
}
