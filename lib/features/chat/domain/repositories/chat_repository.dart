import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_user.dart';
import '../entities/room.dart';
import '../entities/message.dart';

// 🎯 CHAT REPOSITORY INTERFACE - Contract
// Defines WHAT the repository must do (not HOW)

abstract class ChatRepository {
  // User search
  Future<Either<Failure, ChatUser>> searchUserByEmail(String email);
  
  // Presence
  Future<Either<Failure, void>> updatePresence(String userId, String status);
  
  // Typing indicator
  Future<Either<Failure, void>> sendTypingIndicator(String userId, String roomId, bool isTyping);
  
  // Rooms
  Future<Either<Failure, Room>> createRoom({
    String? name,
    required bool isGroup,
    required List<String> members,
    required String currentUserId,
  });
  Future<Either<Failure, List<Room>>> getRoomsForUser(String userId);
  
  // Group Management (Skype-style)
  Future<Either<Failure, Room>> createGroup({
    required String name,
    required List<String> memberIds,
    required String creatorId,
    String? description,
    String? imagePath,
  });
  Future<Either<Failure, Room>> getGroupDetails(String roomId, String userId);
  Future<Either<Failure, Room>> updateGroupInfo({
    required String roomId,
    required String userId,
    String? name,
    String? description,
    String? imagePath,
  });
  Future<Either<Failure, Room>> addGroupMembers({
    required String roomId,
    required String userId,
    required List<String> memberIds,
  });
  Future<Either<Failure, Room>> removeGroupMember({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<Either<Failure, void>> leaveGroup({
    required String roomId,
    required String userId,
  });
  Future<Either<Failure, Room>> makeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<Either<Failure, Room>> removeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<Either<Failure, List<ChatUser>>> searchUsers(String query);
  
  // Messages
  Future<Either<Failure, Message>> sendMessage(String roomId, String senderId, String message);
  Future<Either<Failure, Message>> sendMessageWithAttachments(
    String roomId,
    String senderId,
    String message,
    List<String> attachmentPaths,
  );
  Future<Either<Failure, List<Message>>> getMessagesForRoom(String roomId, String userId);
  
  // Dashboard
  Future<Either<Failure, List<Room>>> getDashboard(String userId);
  
  // Unread counts
  Future<Either<Failure, Map<String, int>>> getUnreadCounts(String userId);
  Future<Either<Failure, void>> markMessagesAsRead(String userId, String roomId);
  
  // File download
  Future<Either<Failure, String>> getDownloadUrl(String fileUrl);
}
