import 'package:equatable/equatable.dart';

// Base abstract failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'بيانات الاعتماد غير صحيحة',
      code: 'invalid_credentials',
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'المستخدم غير موجود',
      code: 'user_not_found',
    );
  }

  factory AuthFailure.emailAlreadyInUse() {
    return const AuthFailure(
      message: 'البريد الإلكتروني مستخدم مسبقاً',
      code: 'email_already_in_use',
    );
  }

  factory AuthFailure.weakPassword() {
    return const AuthFailure(
      message: 'كلمة المرور ضعيفة',
      code: 'weak_password',
    );
  }

  factory AuthFailure.emailNotVerified() {
    return const AuthFailure(
      message: 'البريد الإلكتروني غير مفعل',
      code: 'email_not_verified',
    );
  }

  factory AuthFailure.accountLocked() {
    return const AuthFailure(
      message: 'الحساب مقفل مؤقتاً',
      code: 'account_locked',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'انتهت صلاحية الجلسة',
      code: 'session_expired',
    );
  }

  factory AuthFailure.tooManyAttempts() {
    return const AuthFailure(
      message: 'محاولات كثيرة جداً، حاول مرة أخرى لاحقاً',
      code: 'too_many_attempts',
    );
  }

  // Generic auth failure for custom messages
  factory AuthFailure.custom(String message) {
    return AuthFailure(
      message: message,
      code: 'auth_error',
    );
  }
}

// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });

  factory NetworkFailure.noInternet() {
    return const NetworkFailure(
      message: 'لا يوجد اتصال بالإنترنت',
      code: 'no_internet',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'انتهت مهلة الاتصال',
      code: 'timeout',
    );
  }

  factory NetworkFailure.serverError() {
    return const NetworkFailure(
      message: 'خطأ في الخادم',
      code: 'server_error',
    );
  }

  // Generic network failure for custom messages
  factory NetworkFailure.custom(String message) {
    return NetworkFailure(
      message: message,
      code: 'network_error',
    );
  }
}

// Server related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });

  factory ServerFailure.internalError() {
    return const ServerFailure(
      message: 'خطأ داخلي في الخادم',
      code: 'internal_server_error',
    );
  }

  factory ServerFailure.badRequest() {
    return const ServerFailure(
      message: 'طلب غير صالح',
      code: 'bad_request',
    );
  }

  factory ServerFailure.notFound() {
    return const ServerFailure(
      message: 'المورد غير موجود',
      code: 'not_found',
    );
  }

  factory ServerFailure.custom(String message) {
    return ServerFailure(
      message: message,
      code: 'server_error',
    );
  }
}

// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(
      message: 'البريد الإلكتروني غير صحيح',
      code: 'invalid_email',
    );
  }

  factory ValidationFailure.invalidPassword() {
    return const ValidationFailure(
      message: 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل',
      code: 'invalid_password',
    );
  }

  factory ValidationFailure.invalidName() {
    return const ValidationFailure(
      message: 'الاسم يجب أن يحتوي على حروف فقط',
      code: 'invalid_name',
    );
  }

  factory ValidationFailure.requiredField(String fieldName) {
    return ValidationFailure(
      message: '$fieldName مطلوب',
      code: 'required_field',
    );
  }

  factory ValidationFailure.custom(String message) {
    return ValidationFailure(
      message: message,
      code: 'validation_error',
    );
  }
}

// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'البيانات غير موجودة في التخزين المحلي',
      code: 'cache_not_found',
    );
  }

  factory CacheFailure.storageError() {
    return const CacheFailure(
      message: 'خطأ في التخزين المحلي',
      code: 'storage_error',
    );
  }

  factory CacheFailure.custom(String message) {
    return CacheFailure(
      message: message,
      code: 'cache_error',
    );
  }
}

// Data parsing related failures
class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.code,
  });

  factory ParsingFailure.formatError() {
    return const ParsingFailure(
      message: 'خطأ في تنسيق البيانات',
      code: 'format_error',
    );
  }

  factory ParsingFailure.typeError() {
    return const ParsingFailure(
      message: 'خطأ في نوع البيانات',
      code: 'type_error',
    );
  }

  factory ParsingFailure.missingField(String fieldName) {
    return ParsingFailure(
      message: 'الحقل المطلوب غير موجود: $fieldName',
      code: 'missing_field',
    );
  }

  factory ParsingFailure.custom(String message) {
    return ParsingFailure(
      message: message,
      code: 'parsing_error',
    );
  }
}

// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });

  factory UnknownFailure.unexpected(String error) {
    return UnknownFailure(
      message: 'حدث خطأ غير متوقع: $error',
      code: 'unexpected_error',
    );
  }
}