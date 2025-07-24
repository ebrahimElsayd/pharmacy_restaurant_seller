import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_pass_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/providers/supabase_provider.dart';
import 'auth_notifier.dart' hide UserEntity;
import 'auth_state.dart';

// Data Sources
final authRemoteDataSourceProvider = Provider((ref) {
  return AuthRemoteDataSourceImpl(
    supabase: ref.read(supabaseProvider),
  );
});

// Repository
final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    connectivity: Connectivity(),
  );
});

// Use Cases
final signInUseCaseProvider = Provider((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider((ref) {
  return SignUpUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider((ref) {
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
