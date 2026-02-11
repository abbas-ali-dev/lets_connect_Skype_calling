import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_user.dart';
import '../entities/room.dart';
import '../repositories/chat_repository.dart';

// 🎯 GROUP USE CASES - Business logic for Skype-style group management

// ==================== CREATE GROUP ====================
@lazySingleton
class CreateGroupUseCase {
  final ChatRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String name,
    required List<String> memberIds,
    required String creatorId,
    String? description,
    String? imagePath,
  }) async {
    if (creatorId.isEmpty) {
      return Left(ValidationFailure('Creator ID cannot be empty'));
    }

    if (name.trim().isEmpty) {
      return Left(ValidationFailure('Group name is required'));
    }

    if (name.trim().length < 2) {
      return Left(ValidationFailure('Group name must be at least 2 characters'));
    }

    if (memberIds.isEmpty) {
      return Left(ValidationFailure('At least one member is required'));
    }

    // Ensure creator is included in members
    final allMembers = [...memberIds];
    if (!allMembers.contains(creatorId)) {
      allMembers.add(creatorId);
    }

    return await repository.createGroup(
      name: name.trim(),
      memberIds: allMembers,
      creatorId: creatorId,
      description: description?.trim(),
      imagePath: imagePath,
    );
  }
}

// ==================== GET GROUP DETAILS ====================
@lazySingleton
class GetGroupDetailsUseCase {
  final ChatRepository repository;

  GetGroupDetailsUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.getGroupDetails(roomId, userId);
  }
}

// ==================== UPDATE GROUP INFO ====================
@lazySingleton
class UpdateGroupInfoUseCase {
  final ChatRepository repository;

  UpdateGroupInfoUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
    String? name,
    String? description,
    String? imagePath,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (name == null && description == null && imagePath == null) {
      return Left(ValidationFailure('At least one field must be updated'));
    }

    if (name != null && name.trim().isEmpty) {
      return Left(ValidationFailure('Group name cannot be empty'));
    }

    return await repository.updateGroupInfo(
      roomId: roomId,
      userId: userId,
      name: name?.trim(),
      description: description?.trim(),
      imagePath: imagePath,
    );
  }
}

// ==================== ADD GROUP MEMBERS ====================
@lazySingleton
class AddGroupMembersUseCase {
  final ChatRepository repository;

  AddGroupMembersUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
    required List<String> memberIds,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (memberIds.isEmpty) {
      return Left(ValidationFailure('At least one member must be added'));
    }

    return await repository.addGroupMembers(
      roomId: roomId,
      userId: userId,
      memberIds: memberIds,
    );
  }
}

// ==================== REMOVE GROUP MEMBER ====================
@lazySingleton
class RemoveGroupMemberUseCase {
  final ChatRepository repository;

  RemoveGroupMemberUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (memberId.isEmpty) {
      return Left(ValidationFailure('Member ID cannot be empty'));
    }

    return await repository.removeGroupMember(
      roomId: roomId,
      userId: userId,
      memberId: memberId,
    );
  }
}

// ==================== LEAVE GROUP ====================
@lazySingleton
class LeaveGroupUseCase {
  final ChatRepository repository;

  LeaveGroupUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String roomId,
    required String userId,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.leaveGroup(
      roomId: roomId,
      userId: userId,
    );
  }
}

// ==================== MAKE ADMIN ====================
@lazySingleton
class MakeAdminUseCase {
  final ChatRepository repository;

  MakeAdminUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (memberId.isEmpty) {
      return Left(ValidationFailure('Member ID cannot be empty'));
    }

    return await repository.makeAdmin(
      roomId: roomId,
      userId: userId,
      memberId: memberId,
    );
  }
}

// ==================== REMOVE ADMIN ====================
@lazySingleton
class RemoveAdminUseCase {
  final ChatRepository repository;

  RemoveAdminUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    if (roomId.isEmpty) {
      return Left(ValidationFailure('Room ID cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (memberId.isEmpty) {
      return Left(ValidationFailure('Member ID cannot be empty'));
    }

    return await repository.removeAdmin(
      roomId: roomId,
      userId: userId,
      memberId: memberId,
    );
  }
}

// ==================== SEARCH USERS ====================
@lazySingleton
class SearchUsersUseCase {
  final ChatRepository repository;

  SearchUsersUseCase(this.repository);

  Future<Either<Failure, List<ChatUser>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Left(ValidationFailure('Search query cannot be empty'));
    }

    if (query.trim().length < 2) {
      return Left(ValidationFailure('Search query must be at least 2 characters'));
    }

    return await repository.searchUsers(query.trim());
  }
}
