import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/service/auth_service.dart';
import '../../data/data_source/auth_local_datasource.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_pass_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/providers/supabase_provider.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// Core Dependencies Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    supabase: ref.read(supabaseProvider),
  );
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.read(secureStorageProvider),
    sharedPreferences: ref.read(sharedPreferencesProvider),
  );
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
    connectivity: ref.read(connectivityProvider),
  );
});

// Use Cases
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.read(authRepositoryProvider));
});

// Main Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  return AuthNotifier(
    signInUseCase: ref.read(signInUseCaseProvider),
    signUpUseCase: ref.read(signUpUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(authLocalDataSourceProvider),
    ref,
  );
});

// Individual state providers for convenience
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider).state;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isLoginLoading ||
      authState.isRegisterLoading ||
      authState.isForgotPasswordLoading ||
      authState.isResetPasswordLoading;
});

final isLoginLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoginLoading;
});

final isRegisterLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isRegisterLoading;
});

final isForgotPasswordLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isForgotPasswordLoading;
});

final isResetPasswordLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isResetPasswordLoading;
});

final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).errorMessage;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).state == AuthState.authenticated;
});

final needsEmailVerificationProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).state == AuthState.emailVerificationRequired;
});