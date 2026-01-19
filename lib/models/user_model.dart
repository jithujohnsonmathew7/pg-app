import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserRole { owner, tenant }

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? pgId; // PG the user is associated with; null for owners (can own multiple)
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.pgId,
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? pgId,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      pgId: pgId ?? this.pgId,
      isActive: isActive ?? this.isActive,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
