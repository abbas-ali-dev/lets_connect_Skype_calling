import 'package:equatable/equatable.dart';
import 'chat_user.dart';
import 'message.dart';

// 🎯 ROOM ENTITY - Domain model for chat rooms (1-to-1 and group)
// Skype-style group features: admin roles, group image, description

class Room extends Equatable {
  final String id;
  final String? name;
  final bool isGroup;
  final List<ChatUser> members;
  final Message? lastMessage;
  final DateTime createdAt;
  final int unreadCount;
  
  // Group-specific fields
  final String? description;       // Group description
  final String? imageUrl;          // Group avatar/image
  final String? createdBy;         // User ID who created the group
  final List<String> adminIds;     // List of admin user IDs
  final int? maxMembers;           // Maximum allowed members (null = unlimited)

  const Room({
    required this.id,
    this.name,
    required this.isGroup,
    required this.members,
    this.lastMessage,
    required this.createdAt,
    this.unreadCount = 0,
    // Group-specific
    this.description,
    this.imageUrl,
    this.createdBy,
    this.adminIds = const [],
    this.maxMembers,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        isGroup,
        members,
        lastMessage,
        createdAt,
        unreadCount,
        description,
        imageUrl,
        createdBy,
        adminIds,
        maxMembers,
      ];

  Room copyWith({
    String? id,
    String? name,
    bool? isGroup,
    List<ChatUser>? members,
    Message? lastMessage,
    DateTime? createdAt,
    int? unreadCount,
    String? description,
    String? imageUrl,
    String? createdBy,
    List<String>? adminIds,
    int? maxMembers,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroup: isGroup ?? this.isGroup,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      adminIds: adminIds ?? this.adminIds,
      maxMembers: maxMembers ?? this.maxMembers,
    );
  }

  // Get display name for the room
  String getDisplayName(String currentUserId) {
    if (isGroup) {
      return name ?? 'Group Chat';
    } else {
      // For 1-to-1 chat, show the other user's name
      final otherUser = members.firstWhere(
        (user) => user.id != currentUserId,
        orElse: () => members.first,
      );
      return otherUser.username;
    }
  }

  // Get other user in 1-to-1 chat
  ChatUser? getOtherUser(String currentUserId) {
    if (isGroup) return null;
    try {
      return members.firstWhere((user) => user.id != currentUserId);
    } catch (e) {
      return null;
    }
  }

  // Check if user is admin of this group
  bool isAdmin(String userId) {
    if (!isGroup) return false;
    return adminIds.contains(userId) || createdBy == userId;
  }

  // Check if user is the creator of this group
  bool isCreator(String userId) {
    return createdBy == userId;
  }

  // Get member count
  int get memberCount => members.length;

  // Check if user can add members (admin or creator)
  bool canAddMembers(String userId) {
    return isGroup && isAdmin(userId);
  }

  // Check if user can remove a specific member
  bool canRemoveMember(String userId, String targetMemberId) {
    if (!isGroup) return false;
    // Creator can remove anyone except themselves
    if (isCreator(userId) && userId != targetMemberId) return true;
    // Admin can remove non-admins
    if (isAdmin(userId) && !isAdmin(targetMemberId) && userId != targetMemberId) return true;
    return false;
  }

  // Check if user can edit group info
  bool canEditGroupInfo(String userId) {
    return isGroup && isAdmin(userId);
  }

  // Get admins list
  List<ChatUser> getAdmins() {
    return members.where((m) => adminIds.contains(m.id) || m.id == createdBy).toList();
  }

  // Get non-admin members
  List<ChatUser> getNonAdminMembers() {
    return members.where((m) => !adminIds.contains(m.id) && m.id != createdBy).toList();
  }
}
