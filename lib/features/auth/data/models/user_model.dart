import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.isEmailVerified,
    super.createdAt,
    super.updatedAt,
    super.profileImageUrl,
    super.businessName,
    super.businessType,
    super.businessAddress,
    super.isActive,
    super.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String,dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String,dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromSupabaseUser(
      Map<String,dynamic> userData,
      String userId,
      String email,
      ) {
    return UserModel(
      id: userId,
      email: email,
      fullName: userData['full_name'] as String? ?? '',
      phoneNumber: userData['phone_number'] as String?,
      isEmailVerified: userData['email_verified'] as bool? ?? false,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'] as String)
          : null,
      updatedAt: userData['updated_at'] != null
          ? DateTime.parse(userData['updated_at'] as String)
          : null,
      profileImageUrl: userData['profile_image_url'] as String?,
      businessName: userData['business_name'] as String?,
      businessType: userData['business_type'] as String?,
      businessAddress: userData['business_address'] as String?,
      isActive: userData['is_active'] as bool? ?? true,
      lastLoginAt: userData['last_login_at'] != null
          ? DateTime.parse(userData['last_login_at'] as String)
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
    String? businessName,
    String? businessType,
    String? businessAddress,
    bool? isActive,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessAddress: businessAddress ?? this.businessAddress,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map toSupabaseInsert() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email_verified': isEmailVerified,
      'profile_image_url': profileImageUrl,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  Map toSupabaseUpdate() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, '
        'phoneNumber: $phoneNumber, isEmailVerified: $isEmailVerified, '
        'businessName: $businessName, isActive: $isActive)';
  }
}