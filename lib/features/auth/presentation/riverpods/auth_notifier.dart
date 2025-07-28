import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../data/data_source/auth_local_datasource.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_pass_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/constants/constants.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthStateData> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthLocalDataSource _localDataSource;

  AuthNotifier({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required AuthLocalDataSource localDataSource,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _localDataSource = localDataSource,
        super(const AuthStateData());

  // في دالة initializeAuth
  Future<void> initializeAuth() async {
    state = state.copyWith(state: AuthState.loading);

    try {
      final isLoggedIn = await _localDataSource.getIsLoggedIn();

      if (!isLoggedIn) {
        state = state.copyWith(
          state: AuthState.unauthenticated,
          clearUser: true,
          clearError: true,
        );
        return;
      }

      final sessionExpiry = await _localDataSource.getSessionExpiry();
      if (sessionExpiry != null && DateTime.now().isAfter(sessionExpiry)) {
        await _localDataSource.clearAllData();
        state = state.copyWith(
          state: AuthState.unauthenticated,
          clearUser: true,
          clearError: true,
        );
        return;
      }

      final result = await _getCurrentUserUseCase();
      result.fold(
            (failure) {
          _localDataSource.clearAllData();
          state = state.copyWith(
            state: AuthState.unauthenticated,
            clearUser: true,
            clearError: true,
          );
        },
            (user) {
          // تعطيل التحقق من البريد الإلكتروني مؤقتاً
          state = state.copyWith(
            state: AuthState.authenticated,
            user: user,
            clearError: true,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.unauthenticated,
        clearUser: true,
        clearError: true,
      );
    }
  }

  // في دالة _checkAuthStatus
  Future<void> _checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();

    result.fold(
          (failure) => state = state.copyWith(
        state: AuthState.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
          (user) {
        // تعطيل التحقق من البريد الإلكتروني مؤقتاً
        state = state.copyWith(
          state: AuthState.authenticated,
          user: user,
          clearError: true,
        );
      },
    );
  }

  // دالة التسجيل المحدثة - هذا هو الجزء المهم
  Future<void> register(
      String email,
      String password,
      String fullName, {
        String? phoneNumber,
      }) async {
    // بدء حالة التحميل
    state = state.copyWith(
      isRegisterLoading: true,
      clearError: true,
    );

    try {
      final result = await _signUpUseCase(SignUpParams(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      ));

      result.fold(
            (failure) {
          // في حالة الفشل - البقاء في نفس الصفحة مع إظهار الخطأ
          state = state.copyWith(
            state: AuthState.error,
            errorMessage: failure.message,
            isRegisterLoading: false,
          );
        },
            (_) async {
          // في حالة النجاح - محاولة تسجيل الدخول التلقائي
          try {
            final loginResult = await _signInUseCase(SignInParams(
              email: email,
              password: password,
            ));

            loginResult.fold(
                  (loginFailure) {
                // فشل في تسجيل الدخول التلقائي - إرسال المستخدم لصفحة تسجيل الدخول
                state = state.copyWith(
                  state: AuthState.registrationSuccess,
                  isRegisterLoading: false,
                  clearError: true,
                );
              },
                  (_) async {
                // نجح في تسجيل الدخول التلقائي - الذهاب مباشرة للداشبورد
                await _checkAuthStatus();
                state = state.copyWith(
                  isRegisterLoading: false,
                );
              },
            );
          } catch (e) {
            // خطأ في تسجيل الدخول التلقائي - إرسال المستخدم لصفحة تسجيل الدخول
            state = state.copyWith(
              state: AuthState.registrationSuccess,
              isRegisterLoading: false,
              clearError: true,
            );
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        errorMessage: e.toString(),
        isRegisterLoading: false,
      );
    }

    print("🏁 DEBUG AUTH_NOTIFIER: Register method completed");
  }

  Future<void> login(String email, String password, {bool rememberMe = false}) async {
    state = state.copyWith(
      isLoginLoading: true,
      clearError: true,
    );

    // حفظ اختيار "تذكرني"
    await _localDataSource.saveRememberMe(rememberMe);

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

    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));

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

  Future<void> updatePassword(String newPassword) async {
    state = state.copyWith(
      isResetPasswordLoading: true,
      clearError: true,
    );

    try {
      final result = await _resetPasswordUseCase.repository.updatePassword(newPassword: newPassword);

      result.fold(
            (failure) => state = state.copyWith(
          state: AuthState.error,
          errorMessage: failure.message,
          isResetPasswordLoading: false,
        ),
            (_) => state = state.copyWith(
          state: AuthState.authenticated,
          isResetPasswordLoading: false,
          clearError: true,
        ),
      );
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

  /// تحديث الجلسة
  Future<void> refreshSession() async {
    final sessionExpiry = DateTime.now().add(Duration(minutes: Constants.sessionTimeoutMinutes));
    await _localDataSource.saveSessionExpiry(sessionExpiry);
  }

  /// التحقق من حالة "تذكرني"
  Future<bool> getRememberMe() async {
    return await _localDataSource.getRememberMe();
  }

  /// تحديث حالة المصادقة (مفيد لتحقق البريد الإلكتروني)
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}