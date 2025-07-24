import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

// Auth State Enum
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailVerificationRequired,
  passwordResetSent,
  accountLocked,
  error,
  registrationSuccess,
}

// Auth State Data Class
class AuthStateData extends Equatable {
  final AuthState state;
  final UserEntity? user;
  final String? errorMessage;
  final bool isLoginLoading;
  final bool isRegisterLoading;
  final bool isForgotPasswordLoading;
  final bool isResetPasswordLoading;
  final DateTime? lockoutUntil;
  final String? resetEmail;

  const AuthStateData({
    this.state = AuthState.initial,
    this.user,
    this.errorMessage,
    this.isLoginLoading = false,
    this.isRegisterLoading = false,
    this.isForgotPasswordLoading = false,
    this.isResetPasswordLoading = false,
    this.lockoutUntil,
    this.resetEmail,
  });

  AuthStateData copyWith({
    AuthState? state,
    UserEntity? user,
    String? errorMessage,
    bool? isLoginLoading,
    bool? isRegisterLoading,
    bool? isForgotPasswordLoading,
    bool? isResetPasswordLoading,
    DateTime? lockoutUntil,
    String? resetEmail,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthStateData(
      state: state ?? this.state,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isForgotPasswordLoading: isForgotPasswordLoading ?? this.isForgotPasswordLoading,
      isResetPasswordLoading: isResetPasswordLoading ?? this.isResetPasswordLoading,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
      resetEmail: resetEmail ?? this.resetEmail,
    );
  }

  @override
  List<Object?> get props => [
    state,
    user,
    errorMessage,
    isLoginLoading,
    isRegisterLoading,
    isForgotPasswordLoading,
    isResetPasswordLoading,
    lockoutUntil,
    resetEmail,
  ];

  @override
  String toString() => 'AuthStateData(state: $state, user: ${user?.email})';
}
