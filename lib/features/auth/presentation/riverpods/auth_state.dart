import 'package:pharmacy_restaurant_seller/features/auth/domain/entities/user.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthStateData {
  final AuthState state;
  final User? user;
  final String? errorMessage;
  final bool isLoading;
  final bool isLoginLoading;
  final bool isRegisterLoading;
  final bool isForgotPasswordLoading;
  final bool isVerificationLoading;
  final bool isPasswordUpdateLoading;

  const AuthStateData({
    required this.state,
    this.user,
    this.errorMessage,
    this.isLoading = false,
    this.isLoginLoading = false,
    this.isRegisterLoading = false,
    this.isForgotPasswordLoading = false,
    this.isVerificationLoading = false,
    this.isPasswordUpdateLoading = false,
  });

  AuthStateData copyWith({
    AuthState? state,
    User? user,
    String? errorMessage,
    bool? isLoading,
    bool? isLoginLoading,
    bool? isRegisterLoading,
    bool? isForgotPasswordLoading,
    bool? isVerificationLoading,
    bool? isPasswordUpdateLoading,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthStateData(
      state: state ?? this.state,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isForgotPasswordLoading:
          isForgotPasswordLoading ?? this.isForgotPasswordLoading,
      isVerificationLoading:
          isVerificationLoading ?? this.isVerificationLoading,
      isPasswordUpdateLoading:
          isPasswordUpdateLoading ?? this.isPasswordUpdateLoading,
    );
  }

  bool get isAnyLoading =>
      isLoading ||
      isLoginLoading ||
      isRegisterLoading ||
      isForgotPasswordLoading ||
      isVerificationLoading ||
      isPasswordUpdateLoading;
}
