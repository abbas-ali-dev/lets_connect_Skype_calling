import 'package:equatable/equatable.dart';

// 🎯 CHAT EVENTS - User actions that trigger state changes

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Load dashboard
class LoadDashboardEvent extends ChatEvent {
  final String userId;

  const LoadDashboardEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Refresh dashboard without loader
class RefreshDashboardEvent extends ChatEvent {
  final String userId;

  const RefreshDashboardEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Search user
class SearchUserEvent extends ChatEvent {
  final String email;

  const SearchUserEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

// Create room
class CreateRoomEvent extends ChatEvent {
  final String? name;
  final bool isGroup;
  final List<String> members;
  final String currentUserId;

  const CreateRoomEvent({
    this.name,
    required this.isGroup,
    required this.members,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [name, isGroup, members, currentUserId];
}

// Load messages for room
class LoadMessagesEvent extends ChatEvent {
  final String roomId;
  final String userId;

  const LoadMessagesEvent({required this.roomId, required this.userId});

  @override
  List<Object?> get props => [roomId, userId];
}

// Send message
class SendMessageEvent extends ChatEvent {
  final String roomId;
  final String senderId;
  final String message;

  const SendMessageEvent({
    required this.roomId,
    required this.senderId,
    required this.message,
  });

  @override
  List<Object?> get props => [roomId, senderId, message];
}

// Send message with attachments
class SendMessageWithAttachmentsEvent extends ChatEvent {
  final String roomId;
  final String senderId;
  final String message;
  final List<String> attachmentPaths;

  const SendMessageWithAttachmentsEvent({
    required this.roomId,
    required this.senderId,
    required this.message,
    required this.attachmentPaths,
  });

  @override
  List<Object?> get props => [roomId, senderId, message, attachmentPaths];
}

// Update presence
class UpdatePresenceEvent extends ChatEvent {
  final String userId;
  final String status;

  const UpdatePresenceEvent({
    required this.userId,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, status];
}

// Send typing indicator
class SendTypingIndicatorEvent extends ChatEvent {
  final String userId;
  final String roomId;
  final bool isTyping;

  const SendTypingIndicatorEvent({
    required this.userId,
    required this.roomId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [userId, roomId, isTyping];
}

// Mark messages as read
class MarkMessagesAsReadEvent extends ChatEvent {
  final String userId;
  final String roomId;

  const MarkMessagesAsReadEvent({
    required this.userId,
    required this.roomId,
  });

  @override
  List<Object?> get props => [userId, roomId];
}

// Clear chat state
class ClearChatStateEvent extends ChatEvent {
  const ClearChatStateEvent();
}

// WebSocket Events
class ConnectWebSocketEvent extends ChatEvent {
  final String userId;
  final String token;

  const ConnectWebSocketEvent({
    required this.userId,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, token];
}

class DisconnectWebSocketEvent extends ChatEvent {
  const DisconnectWebSocketEvent();
}

class JoinRoomEvent extends ChatEvent {
  final String roomId;

  const JoinRoomEvent({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class LeaveRoomEvent extends ChatEvent {
  final String roomId;

  const LeaveRoomEvent({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class WebSocketMessageReceivedEvent extends ChatEvent {
  final Map<String, dynamic> data;

  const WebSocketMessageReceivedEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

// ==================== GROUP MANAGEMENT EVENTS ====================

// Create group
class CreateGroupEvent extends ChatEvent {
  final String name;
  final List<String> memberIds;
  final String creatorId;
  final String? description;
  final String? imagePath;

  const CreateGroupEvent({
    required this.name,
    required this.memberIds,
    required this.creatorId,
    this.description,
    this.imagePath,
  });

  @override
  List<Object?> get props => [name, memberIds, creatorId, description, imagePath];
}

// Get group details
class GetGroupDetailsEvent extends ChatEvent {
  final String roomId;
  final String userId;

  const GetGroupDetailsEvent({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

// Update group info
class UpdateGroupInfoEvent extends ChatEvent {
  final String roomId;
  final String userId;
  final String? name;
  final String? description;
  final String? imagePath;

  const UpdateGroupInfoEvent({
    required this.roomId,
    required this.userId,
    this.name,
    this.description,
    this.imagePath,
  });

  @override
  List<Object?> get props => [roomId, userId, name, description, imagePath];
}

// Add members to group
class AddGroupMembersEvent extends ChatEvent {
  final String roomId;
  final String userId;
  final List<String> memberIds;

  const AddGroupMembersEvent({
    required this.roomId,
    required this.userId,
    required this.memberIds,
  });

  @override
  List<Object?> get props => [roomId, userId, memberIds];
}

// Remove member from group
class RemoveGroupMemberEvent extends ChatEvent {
  final String roomId;
  final String userId;
  final String memberId;

  const RemoveGroupMemberEvent({
    required this.roomId,
    required this.userId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [roomId, userId, memberId];
}

// Leave group
class LeaveGroupEvent extends ChatEvent {
  final String roomId;
  final String userId;

  const LeaveGroupEvent({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

// Make member admin
class MakeAdminEvent extends ChatEvent {
  final String roomId;
  final String userId;
  final String memberId;

  const MakeAdminEvent({
    required this.roomId,
    required this.userId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [roomId, userId, memberId];
}

// Remove admin
class RemoveAdminEvent extends ChatEvent {
  final String roomId;
  final String userId;
  final String memberId;

  const RemoveAdminEvent({
    required this.roomId,
    required this.userId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [roomId, userId, memberId];
}

// Search users for adding to group
class SearchUsersEvent extends ChatEvent {
  final String query;

  const SearchUsersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
