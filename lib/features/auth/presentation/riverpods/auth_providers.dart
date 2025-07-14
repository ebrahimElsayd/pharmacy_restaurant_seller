import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, User;

// Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(Supabase.instance.client);
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Use Cases Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyEmailUseCase(repository);
});

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdatePasswordUseCase(repository);
});

// Main Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthStateData>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final registerUseCase = ref.watch(registerUseCaseProvider);
    final forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
    final verifyEmailUseCase = ref.watch(verifyEmailUseCaseProvider);
    final updatePasswordUseCase = ref.watch(updatePasswordUseCaseProvider);
    final authRepository = ref.watch(authRepositoryProvider);

    return AuthNotifier(
      loginUseCase,
      registerUseCase,
      forgotPasswordUseCase,
      verifyEmailUseCase,
      updatePasswordUseCase,
      authRepository,
    );
  },
);

// Helper Providers
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
});

final authStateProvider = Provider<AuthState>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.state;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState == AuthState.authenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAnyLoading;
});

final errorMessageProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.errorMessage;
});

final isLoginLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isLoginLoading;
});

final isRegisterLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isRegisterLoading;
});

final isForgotPasswordLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isForgotPasswordLoading;
});

final isVerificationLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isVerificationLoading;
});

final isPasswordUpdateLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isPasswordUpdateLoading;
});
