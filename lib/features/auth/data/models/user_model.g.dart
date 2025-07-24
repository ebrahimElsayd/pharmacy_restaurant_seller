// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  profileImageUrl: json['profileImageUrl'] as String?,
  businessName: json['businessName'] as String?,
  businessType: json['businessType'] as String?,
  businessAddress: json['businessAddress'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  lastLoginAt:
      json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'isEmailVerified': instance.isEmailVerified,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'profileImageUrl': instance.profileImageUrl,
  'businessName': instance.businessName,
  'businessType': instance.businessType,
  'businessAddress': instance.businessAddress,
  'isActive': instance.isActive,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
};
