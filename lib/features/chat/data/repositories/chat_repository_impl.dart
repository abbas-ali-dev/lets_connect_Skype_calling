import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_user.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

// 🎯 CHAT REPOSITORY IMPLEMENTATION
// Connects remote data source, handles errors

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ChatUser>> searchUserByEmail(String email) async {
    try {
      final userModel = await remoteDataSource.searchUserByEmail(email);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePresence(String userId, String status) async {
    try {
      await remoteDataSource.updatePresence(userId, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendTypingIndicator(String userId, String roomId, bool isTyping) async {
    try {
      await remoteDataSource.sendTypingIndicator(userId, roomId, isTyping);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> createRoom({
    String? name,
    required bool isGroup,
    required List<String> members,
    required String currentUserId,
  }) async {
    try {
      final roomModel = await remoteDataSource.createRoom(
        name: name,
        isGroup: isGroup,
        members: members,
        currentUserId: currentUserId,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Room>>> getRoomsForUser(String userId) async {
    try {
      final roomModels = await remoteDataSource.getRoomsForUser(userId);
      final rooms = roomModels.map((model) => model.toEntity()).toList();
      return Right(rooms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(String roomId, String senderId, String message) async {
    try {
      final messageModel = await remoteDataSource.sendMessage(roomId, senderId, message);
      return Right(messageModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessageWithAttachments(
    String roomId,
    String senderId,
    String message,
    List<String> attachmentPaths,
  ) async {
    try {
      final messageModel = await remoteDataSource.sendMessageWithAttachments(
        roomId,
        senderId,
        message,
        attachmentPaths,
      );
      return Right(messageModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessagesForRoom(String roomId, String userId) async {
    try {
      final messageModels = await remoteDataSource.getMessagesForRoom(roomId, userId);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Room>>> getDashboard(String userId) async {
    try {
      final roomModels = await remoteDataSource.getDashboard(userId);
      final rooms = roomModels.map((model) => model.toEntity()).toList();
      return Right(rooms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getUnreadCounts(String userId) async {
    try {
      final unreadCounts = await remoteDataSource.getUnreadCounts(userId);
      return Right(unreadCounts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String userId, String roomId) async {
    try {
      await remoteDataSource.markMessagesAsRead(userId, roomId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl(String fileUrl) async {
    try {
      final downloadUrl = await remoteDataSource.getDownloadUrl(fileUrl);
      return Right(downloadUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ==================== GROUP MANAGEMENT METHODS ====================

  @override
  Future<Either<Failure, Room>> createGroup({
    required String name,
    required List<String> memberIds,
    required String creatorId,
    String? description,
    String? imagePath,
  }) async {
    try {
      final roomModel = await remoteDataSource.createGroup(
        name: name,
        memberIds: memberIds,
        creatorId: creatorId,
        description: description,
        imagePath: imagePath,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> getGroupDetails(String roomId, String userId) async {
    try {
      final roomModel = await remoteDataSource.getGroupDetails(roomId, userId);
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> updateGroupInfo({
    required String roomId,
    required String userId,
    String? name,
    String? description,
    String? imagePath,
  }) async {
    try {
      final roomModel = await remoteDataSource.updateGroupInfo(
        roomId: roomId,
        userId: userId,
        name: name,
        description: description,
        imagePath: imagePath,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> addGroupMembers({
    required String roomId,
    required String userId,
    required List<String> memberIds,
  }) async {
    try {
      final roomModel = await remoteDataSource.addGroupMembers(
        roomId: roomId,
        userId: userId,
        memberIds: memberIds,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> removeGroupMember({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      final roomModel = await remoteDataSource.removeGroupMember(
        roomId: roomId,
        userId: userId,
        memberId: memberId,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup({
    required String roomId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.leaveGroup(roomId: roomId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> makeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      final roomModel = await remoteDataSource.makeAdmin(
        roomId: roomId,
        userId: userId,
        memberId: memberId,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Room>> removeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      final roomModel = await remoteDataSource.removeAdmin(
        roomId: roomId,
        userId: userId,
        memberId: memberId,
      );
      return Right(roomModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatUser>>> searchUsers(String query) async {
    try {
      final userModels = await remoteDataSource.searchUsers(query);
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
