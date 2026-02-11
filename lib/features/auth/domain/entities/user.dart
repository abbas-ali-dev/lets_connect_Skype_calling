import 'package:equatable/equatable.dart';

// 🎯 USER ENTITY - Pure business object
// This represents a user in our business logic (no JSON, no API details)

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? phone;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.phone,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, username, phone, token];
}