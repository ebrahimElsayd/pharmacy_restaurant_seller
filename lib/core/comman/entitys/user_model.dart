// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final int? phone;
  final int? state;
  final String? userId;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.password = '',
    this.phone,
    this.state,
    this.userId,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    int? phone,
    int? state,
    String? userId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'name': name, 'email': email};

    if (phone != null) map['phone'] = phone;
    if (id != null) map['id'] = id;
    if (state != null) map['state'] = state;
    if (userId != null) map['user_id'] = userId;
    // Only include password if it's not empty (for auth purposes, not DB storage)
    if (password != null && password!.isNotEmpty) map['password'] = password;

    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      phone: map['phone'] as int? ?? 0,
      state: map['state'] as int? ?? 0,
      userId: map['user_id'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, phone: $phone, state: $state, userId: $userId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.phone == phone &&
        other.state == state &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        state.hashCode ^
        userId.hashCode;
  }
}
