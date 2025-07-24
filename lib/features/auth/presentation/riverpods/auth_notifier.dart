import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_pass_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthStateData> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthNotifier({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(const AuthStateData()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(state: AuthState.loading);

    final result = await _getCurrentUserUseCase();

    result.fold(
          (failure) => state = state.copyWith(
        state: AuthState.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
          (user) {
        if (!user.isEmailVerified) {
          state = state.copyWith(
            state: AuthState.emailVerificationRequired,
            user: user,
            clearError: true,
          );
        } else {
          state = state.copyWith(
            state: AuthState.authenticated,
            user: user,
            clearError: true,
          );
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      isLoginLoading: true,
      clearError: true,
    );

    final result = await _signInUseCase(SignInParams(
      email: email,
      password: password,
    ));

    result.fold(
          (failure) => state = state.copyWith(
        state: AuthState.error,
        errorMessage: failure.message,
        isLoginLoading: false,
      ),
          (_) async {
        state = state.copyWith(isLoginLoading: false);
        await _checkAuthStatus();
      },
    );
  }

  Future<void> register(
      String email,
      String password,
      String fullName, {
        String? phoneNumber,
      }) async {
    state = state.copyWith(
      isRegisterLoading: true,
      clearError: true,
    );

    final result = await _signUpUseCase(SignUpParams(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    ));

    result.fold(
          (failure) {
        print('[DEBUG] ❌ Failure in register: ${failure.message}');
        print('[DEBUG] ❌ Failure code: ${failure.code}');
        state = state.copyWith(
          state: AuthState.error,
          errorMessage: failure.message,
          isRegisterLoading: false,
        );
      },
          (_) {
            print('[DEBUG] 🚀 Starting registration...');
            print('[DEBUG] 📧 Email: $email');
            print('[DEBUG] 🔐 Password: $password');
            print('[DEBUG] 👤 Name: $fullName');

            // بعد التسجيل الناجح، نضع حالة المستخدم مباشرة لشاشة التحقق من البريد
        // نستخدم هنا طريقة آمنة للتعامل مع الكائنات بحيث نتوافق مع نظام الأنواع في Flutter
        state = state.copyWith(
          state: AuthState.emailVerificationRequired,
          isRegisterLoading: false,
          clearError: true,
          // يجب أن نمرر null هنا بدلاً من UserEntity جديدة
          // سيتم تحديثها بعد استجلاب معلومات المستخدم
          user: null,
        );

        // نحتاج للتأكد من التحقق من المستخدم الحالي في خلفية العملية
        _getCurrentUserUseCase().then((result) {
          result.fold(
                (failure) {
                  print('[ERROR] ❌ Registration failed: ${failure.message}');

                  // إذا فشل الحصول على معلومات المستخدم، نحافظ على الحالة الحالية
            },
                (user) {
                  print('[DEBUG] ✅ Registration succeeded for user: ${user.email}');
                  //     (f) => print('[ERROR] ❌ Failed to get current user: ${f.message}');
                  // (u) => print('[DEBUG] ✅ Fetched current user: ${u.email}');
                  // نحدث معلومات المستخدم إذا نجحنا في الحصول عليها
              state = state.copyWith(
                user: user,
                state: AuthState.emailVerificationRequired,
              );
            },
          );
        });
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(state: AuthState.loading);

    final result = await _signOutUseCase();

    result.fold(
          (failure) => state = state.copyWith(
        state: AuthState.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(
        state: AuthState.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
    );
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(
      isForgotPasswordLoading: true,
      clearError: true,
    );

    final result = await _resetPasswordUseCase(ResetPasswordParams(email: email));

    result.fold(
          (failure) => state = state.copyWith(
        state: AuthState.error,
        errorMessage: failure.message,
        isForgotPasswordLoading: false,
      ),
          (_) => state = state.copyWith(
        state: AuthState.passwordResetSent,
        resetEmail: email,
        isForgotPasswordLoading: false,
        clearError: true,
      ),
    );
  }

  Future<void> updatePassword(String newPassword, String token) async {
    state = state.copyWith(
      isResetPasswordLoading: true,
      clearError: true,
    );

    try {
      final response = await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: newPassword)
      );

      if (response.user != null) {
        state = state.copyWith(
          state: AuthState.authenticated,
          isResetPasswordLoading: false,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          state: AuthState.error,
          errorMessage: 'Failed to update password',
          isResetPasswordLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isResetPasswordLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearPasswordResetSent() {
    if (state.state == AuthState.passwordResetSent) {
      state = state.copyWith(state: AuthState.unauthenticated);
    }
  }

  // Method to refresh auth status (useful for email verification)
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}

// استخدام كائن مستخدم صغير للاستخدام المؤقت
class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.isEmailVerified = false
  });
}