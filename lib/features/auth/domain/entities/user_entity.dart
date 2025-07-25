import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profileImageUrl;
  final String? businessName;
  final String? businessType;
  final String? businessAddress;
  final bool isActive;
  final DateTime? lastLoginAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.businessName,
    this.businessType,
    this.businessAddress,
    this.isActive = true,
    this.lastLoginAt,
  });

  @override
  List get props => [
    id,
    email,
    fullName,
    phoneNumber,
    isEmailVerified,
    createdAt,
    updatedAt,
    profileImageUrl,
    businessName,
    businessType,
    businessAddress,
    isActive,
    lastLoginAt,
  ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, '
        'phoneNumber: $phoneNumber, isEmailVerified: $isEmailVerified, '
        'businessName: $businessName, isActive: $isActive)';
  }

  // Helper methods
  String get displayName => fullName.isNotEmpty ? fullName : email;

  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  bool get hasProfileImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;

  bool get hasBusinessInfo => businessName != null && businessName!.isNotEmpty;

  bool get isProfileComplete {
    return fullName.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty &&
        isEmailVerified;
  }

  String get businessDisplayName => businessName ?? fullName;

  DateTime get lastActivity => lastLoginAt ?? createdAt ?? DateTime.now();
}