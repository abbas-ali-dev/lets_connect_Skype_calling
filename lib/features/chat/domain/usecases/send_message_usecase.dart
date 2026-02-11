import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

// 🎯 SEND MESSAGE USE CASE - Business logic for sending messages
// Single responsibility: Send a text message to a room

@lazySingleton
class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, Message>> call(
    String roomId,
    String senderId,
    String message,
  ) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (senderId.isEmpty) {
      return Left(ValidationFailure('Sender ID cannot be empty'));
    }

    if (message.trim().isEmpty) {
      return Left(ValidationFailure('Message cannot be empty'));
    }

    return await repository.sendMessage(roomId, senderId, message.trim());
  }
}
