import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

// 🎯 GET MESSAGES USE CASE - Business logic for getting room messages
// Single responsibility: Get all messages for a specific room

@lazySingleton
class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<Message>>> call(String roomId, String userId) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }
    
    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.getMessagesForRoom(roomId, userId);
  }
}
