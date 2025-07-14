import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthStateData> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final AuthRepository _authRepository;

  AuthNotifier(
    this._loginUseCase,
    this._registerUseCase,
    this._forgotPasswordUseCase,
    this._verifyEmailUseCase,
    this._updatePasswordUseCase,
    this._authRepository,
  ) : super(const AuthStateData(state: AuthState.initial)) {
    _init();
  }

  void _init() {
    _getCurrentUser();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        state = state.copyWith(
          state: AuthState.authenticated,
          user: user,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          state: AuthState.unauthenticated,
          clearUser: true,
          clearError: true,
        );
      }
    });
  }

  Future<void> _getCurrentUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          state: AuthState.authenticated,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          state: AuthState.unauthenticated,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoginLoading: true, clearError: true);

    try {
      final user = await _loginUseCase(email, password);
      state = state.copyWith(
        state: AuthState.authenticated,
        user: user,
        isLoginLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isLoginLoading: false,
      );
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isRegisterLoading: true, clearError: true);

    try {
      final user = await _registerUseCase(email, password, name);
      state = state.copyWith(
        state: AuthState.unauthenticated,
        user: user,
        isRegisterLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isRegisterLoading: false,
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isForgotPasswordLoading: true, clearError: true);

    try {
      await _forgotPasswordUseCase(email);
      state = state.copyWith(
        isForgotPasswordLoading: false,
        errorMessage: 'Password reset email sent successfully',
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isForgotPasswordLoading: false,
      );
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    state = state.copyWith(isVerificationLoading: true, clearError: true);

    try {
      await _verifyEmailUseCase(email, code);
      state = state.copyWith(
        isVerificationLoading: false,
        errorMessage: 'Email verified successfully',
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isVerificationLoading: false,
      );
    }
  }

  Future<void> updatePassword(String newPassword, String token) async {
    state = state.copyWith(isPasswordUpdateLoading: true, clearError: true);

    try {
      await _updatePasswordUseCase(newPassword, token);
      state = state.copyWith(
        isPasswordUpdateLoading: false,
        errorMessage: 'Password updated successfully',
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isPasswordUpdateLoading: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.logout();
      state = state.copyWith(
        state: AuthState.unauthenticated,
        clearUser: true,
        clearError: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
