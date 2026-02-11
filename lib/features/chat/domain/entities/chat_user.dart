import 'package:equatable/equatable.dart';

// 🎯 CHAT USER ENTITY - Domain model for chat users
// Pure Dart class, no external dependencies

class ChatUser extends Equatable {
  final String id;
  final String username;
  final String email;
  final bool isOnline;

  const ChatUser({
    required this.id,
    required this.username,
    required this.email,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, username, email, isOnline];

  ChatUser copyWith({
    String? id,
    String? username,
    String? email,
    bool? isOnline,
  }) {
    return ChatUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
