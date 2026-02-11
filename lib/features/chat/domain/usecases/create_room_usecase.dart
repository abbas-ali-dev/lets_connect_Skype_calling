import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/room.dart';
import '../repositories/chat_repository.dart';

// 🎯 CREATE ROOM USE CASE - Business logic for creating chat rooms
// Single responsibility: Create a new chat room (1-to-1 or group)

@lazySingleton
class CreateRoomUseCase {
  final ChatRepository repository;

  CreateRoomUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    String? name,
    required bool isGroup,
    required List<String> members,
    required String currentUserId,
  }) async {
    if (currentUserId.isEmpty) {
      return Left(ValidationFailure('Current user ID cannot be empty'));
    }

    if (members.isEmpty) {
      return Left(ValidationFailure('Members list cannot be empty'));
    }

    if (isGroup && (name == null || name.trim().isEmpty)) {
      return Left(ValidationFailure('Group name is required for group chats'));
    }

    if (!isGroup && members.length != 2) {
      return Left(ValidationFailure('1-to-1 chat must have exactly 2 members'));
    }

    if (!members.contains(currentUserId)) {
      members.add(currentUserId);
    }

    return await repository.createRoom(
      name: name?.trim(),
      isGroup: isGroup,
      members: members,
      currentUserId: currentUserId,
    );
  }
}
