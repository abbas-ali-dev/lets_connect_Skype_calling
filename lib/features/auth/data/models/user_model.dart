import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// 🎯 USER MODEL - Data transfer object
// Handles JSON serialization/deserialization

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? phone,
    String? token,
  }) = _UserModel;

  // From JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      phone: phone,
      token: token,
    );
  }
}