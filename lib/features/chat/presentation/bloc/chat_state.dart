import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_user.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/message.dart';

// 🎯 CHAT STATES - Different states of chat functionality

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ChatInitial extends ChatState {
  const ChatInitial();
}

// Loading state
class ChatLoading extends ChatState {
  const ChatLoading();
}

// Dashboard loaded state
class ChatDashboardLoaded extends ChatState {
  final List<Room> rooms;
  final Map<String, int> unreadCounts;

  const ChatDashboardLoaded({
    required this.rooms,
    this.unreadCounts = const {},
  });

  @override
  List<Object?> get props => [rooms, unreadCounts];
}

// User search result state
class ChatUserSearchResult extends ChatState {
  final ChatUser user;

  const ChatUserSearchResult({required this.user});

  @override
  List<Object?> get props => [user];
}

// Room created state
class ChatRoomCreated extends ChatState {
  final Room room;

  const ChatRoomCreated({required this.room});

  @override
  List<Object?> get props => [room];
}

// Messages loaded state
class ChatMessagesLoaded extends ChatState {
  final String roomId;
  final List<Message> messages;

  const ChatMessagesLoaded({
    required this.roomId,
    required this.messages,
  });

  @override
  List<Object?> get props => [roomId, messages];
}

// Message sent state
class ChatMessageSent extends ChatState {
  final Message message;

  const ChatMessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

// Presence updated state
class ChatPresenceUpdated extends ChatState {
  final String userId;
  final String status;

  const ChatPresenceUpdated({
    required this.userId,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, status];
}

// Typing indicator sent state
class ChatTypingIndicatorSent extends ChatState {
  final String userId;
  final String roomId;
  final bool isTyping;

  const ChatTypingIndicatorSent({
    required this.userId,
    required this.roomId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [userId, roomId, isTyping];
}

// Messages marked as read state
class ChatMessagesMarkedAsRead extends ChatState {
  final String userId;
  final String roomId;

  const ChatMessagesMarkedAsRead({
    required this.userId,
    required this.roomId,
  });

  @override
  List<Object?> get props => [userId, roomId];
}

// Error state
class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

// WebSocket States
class ChatWebSocketConnected extends ChatState {
  const ChatWebSocketConnected();
}

class ChatWebSocketDisconnected extends ChatState {
  const ChatWebSocketDisconnected();
}

class ChatWebSocketError extends ChatState {
  final String message;

  const ChatWebSocketError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatRoomJoined extends ChatState {
  final String roomId;

  const ChatRoomJoined({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class ChatRoomLeft extends ChatState {
  final String roomId;

  const ChatRoomLeft({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class ChatMessageReceived extends ChatState {
  final Message message;

  const ChatMessageReceived({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatTypingIndicatorReceived extends ChatState {
  final String roomId;
  final String userId;
  final bool isTyping;
  final String? username;

  const ChatTypingIndicatorReceived({
    required this.roomId,
    required this.userId,
    required this.isTyping,
    this.username,
  });

  @override
  List<Object?> get props => [roomId, userId, isTyping, username];
}

class ChatPresenceReceived extends ChatState {
  final String userId;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? username;

  const ChatPresenceReceived({
    required this.userId,
    required this.isOnline,
    this.lastSeen,
    this.username,
  });

  @override
  List<Object?> get props => [userId, isOnline, lastSeen, username];
}

// ==================== GROUP MANAGEMENT STATES ====================

// Group created state
class GroupCreated extends ChatState {
  final Room group;

  const GroupCreated({required this.group});

  @override
  List<Object?> get props => [group];
}

// Group details loaded state
class GroupDetailsLoaded extends ChatState {
  final Room group;

  const GroupDetailsLoaded({required this.group});

  @override
  List<Object?> get props => [group];
}

// Group info updated state
class GroupInfoUpdated extends ChatState {
  final Room group;

  const GroupInfoUpdated({required this.group});

  @override
  List<Object?> get props => [group];
}

// Group members added state
class GroupMembersAdded extends ChatState {
  final Room group;

  const GroupMembersAdded({required this.group});

  @override
  List<Object?> get props => [group];
}

// Group member removed state
class GroupMemberRemoved extends ChatState {
  final Room group;

  const GroupMemberRemoved({required this.group});

  @override
  List<Object?> get props => [group];
}

// Left group state
class GroupLeft extends ChatState {
  final String roomId;

  const GroupLeft({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

// Admin added state
class GroupAdminAdded extends ChatState {
  final Room group;

  const GroupAdminAdded({required this.group});

  @override
  List<Object?> get props => [group];
}

// Admin removed state
class GroupAdminRemoved extends ChatState {
  final Room group;

  const GroupAdminRemoved({required this.group});

  @override
  List<Object?> get props => [group];
}

// Users search result state
class UsersSearchResult extends ChatState {
  final List<ChatUser> users;

  const UsersSearchResult({required this.users});

  @override
  List<Object?> get props => [users];
}

// Group loading state (for group-specific operations)
class GroupLoading extends ChatState {
  const GroupLoading();
}
