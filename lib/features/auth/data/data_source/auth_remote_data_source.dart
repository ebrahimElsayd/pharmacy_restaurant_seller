import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSource(this._supabaseClient);

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed');
      }

      return UserModel.fromJson({
        'id': response.user!.id,
        'email': response.user!.email!,
        'name': response.user!.userMetadata?['name'],
        'email_verified': response.user!.emailConfirmedAt != null,
        'created_at': response.user!.createdAt,
      });
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw Exception('Registration failed');
      }

      return UserModel.fromJson({
        'id': response.user!.id,
        'email': response.user!.email!,
        'name': name,
        'email_verified': response.user!.emailConfirmedAt != null,
        'created_at': response.user!.createdAt,
      });
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> verifyOTP(String email, String code) async {
    try {
      await _supabaseClient.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.email,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> updatePassword(String newPassword, String token) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      return UserModel.fromJson({
        'id': user.id,
        'email': user.email!,
        'name': user.userMetadata?['name'],
        'email_verified': user.emailConfirmedAt != null,
        'created_at': user.createdAt,
      });
    } catch (e) {
      return null;
    }
  }

  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;

      return UserModel.fromJson({
        'id': user.id,
        'email': user.email!,
        'name': user.userMetadata?['name'],
        'email_verified': user.emailConfirmedAt != null,
        'created_at': user.createdAt,
      });
    });
  }
}

// import 'package:supabase_flutter/supabase_flutter.dart';

// abstract class AuthRemoteDataSource {
//   Future<AuthResponse> signInWithEmail(String email, String password);
//   Future<AuthResponse> signUpWithEmail(String email, String password);
//   Future<void> signOut();
//   Future<User?> getCurrentUser();
//   Future<void> resetPassword(String email);
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final SupabaseClient supabaseClient;

//   AuthRemoteDataSourceImpl({required this.supabaseClient});

//   @override
//   Future<AuthResponse> signInWithEmail(String email, String password) async {
//     try {
//       final response = await supabaseClient.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       return response;
//     } catch (e) {
//       throw Exception('Failed to sign in: $e');
//     }
//   }

//   @override
//   Future<AuthResponse> signUpWithEmail(String email, String password) async {
//     try {
//       final response = await supabaseClient.auth.signUp(
//         email: email,
//         password: password,
//       );
//       return response;
//     } catch (e) {
//       throw Exception('Failed to sign up: $e');
//     }
//   }

//   @override
//   Future<void> signOut() async {
//     try {
//       await supabaseClient.auth.signOut();
//     } catch (e) {
//       throw Exception('Failed to sign out: $e');
//     }
//   }

//   @override
//   Future<User?> getCurrentUser() async {
//     return supabaseClient.auth.currentUser;
//   }

//   @override
//   Future<void> resetPassword(String email) async {
//     try {
//       await supabaseClient.auth.resetPasswordForEmail(email);
//     } catch (e) {
//       throw Exception('Failed to reset password: $e');
//     }
//   }
// }

// // 2. Auth Repository
// // lib/features/auth/domain/repository/auth_repository.dart
// import 'package:dartz/dartz.dart';
//
// abstract class AuthRepository {
//   Future<Either<Failure, User>> signInWithEmail(String email, String password);
//   Future<Either<Failure, User>> signUpWithEmail(String email, String password);
//   Future<Either<Failure, void>> signOut();
//   Future<Either<Failure, User?>> getCurrentUser();
//   Future<Either<Failure, void>> resetPassword(String email);
// }
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//
//   AuthRepositoryImpl({required this.remoteDataSource});
//
//   @override
//   Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
//     try {
//       final response = await remoteDataSource.signInWithEmail(email, password);
//       if (response.user != null) {
//         return Right(response.user!);
//       } else {
//         return Left(AuthFailure('Invalid credentials'));
//       }
//     } catch (e) {
//       return Left(AuthFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, User>> signUpWithEmail(String email, String password) async {
//     try {
//       final response = await remoteDataSource.signUpWithEmail(email, password);
//       if (response.user != null) {
//         return Right(response.user!);
//       } else {
//         return Left(AuthFailure('Failed to create account'));
//       }
//     } catch (e) {
//       return Left(AuthFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await remoteDataSource.signOut();
//       return const Right(null);
//     } catch (e) {
//       return Left(AuthFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, User?>> getCurrentUser() async {
//     try {
//       final user = await remoteDataSource.getCurrentUser();
//       return Right(user);
//     } catch (e) {
//       return Left(AuthFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> resetPassword(String email) async {
//     try {
//       await remoteDataSource.resetPassword(email);
//       return const Right(null);
//     } catch (e) {
//       return Left(AuthFailure(e.toString()));
//     }
//   }
// }
//
// // 3. Auth State Management with Riverpod
// // lib/features/auth/presentation/controllers/auth_controller.dart
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'auth_controller.freezed.dart';
// part 'auth_controller.g.dart';
//
// @freezed
// class AuthState with _$AuthState {
//   const factory AuthState({
//     @Default(false) bool isLoading,
//     @Default(AuthStatus.initial) AuthStatus status,
//     User? user,
//     String? error,
//   }) = _AuthState;
// }
//
// enum AuthStatus {
//   initial,
//   authenticated,
//   unauthenticated,
//   loading,
//   error,
// }
//
// @riverpod
// class AuthController extends _$AuthController {
//   @override
//   AuthState build() {
//     _initializeAuth();
//     return const AuthState();
//   }
//
//   Future<void> _initializeAuth() async {
//     state = state.copyWith(isLoading: true);
//
//     final authRepository = ref.read(authRepositoryProvider);
//     final result = await authRepository.getCurrentUser();
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.error,
//         error: failure.message,
//       ),
//           (user) => state = state.copyWith(
//         isLoading: false,
//         status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
//         user: user,
//       ),
//     );
//   }
//
//   Future<void> signIn(String email, String password) async {
//     if (!_validateEmail(email) || !_validatePassword(password)) {
//       state = state.copyWith(
//         error: 'Invalid email or password format',
//         status: AuthStatus.error,
//       );
//       return;
//     }
//
//     state = state.copyWith(
//       isLoading: true,
//       error: null,
//       status: AuthStatus.loading,
//     );
//
//     final authRepository = ref.read(authRepositoryProvider);
//     final result = await authRepository.signInWithEmail(email, password);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.error,
//         error: failure.message,
//       ),
//           (user) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.authenticated,
//         user: user,
//         error: null,
//       ),
//     );
//   }
//
//   Future<void> signUp(String email, String password) async {
//     if (!_validateEmail(email) || !_validatePassword(password)) {
//       state = state.copyWith(
//         error: 'Invalid email or password format',
//         status: AuthStatus.error,
//       );
//       return;
//     }
//
//     state = state.copyWith(
//       isLoading: true,
//       error: null,
//       status: AuthStatus.loading,
//     );
//
//     final authRepository = ref.read(authRepositoryProvider);
//     final result = await authRepository.signUpWithEmail(email, password);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.error,
//         error: failure.message,
//       ),
//           (user) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.authenticated,
//         user: user,
//         error: null,
//       ),
//     );
//   }
//
//   Future<void> signOut() async {
//     state = state.copyWith(isLoading: true);
//
//     final authRepository = ref.read(authRepositoryProvider);
//     final result = await authRepository.signOut();
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.error,
//         error: failure.message,
//       ),
//           (_) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.unauthenticated,
//         user: null,
//         error: null,
//       ),
//     );
//   }
//
//   Future<void> resetPassword(String email) async {
//     if (!_validateEmail(email)) {
//       state = state.copyWith(
//         error: 'Invalid email format',
//         status: AuthStatus.error,
//       );
//       return;
//     }
//
//     state = state.copyWith(isLoading: true);
//
//     final authRepository = ref.read(authRepositoryProvider);
//     final result = await authRepository.resetPassword(email);
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isLoading: false,
//         status: AuthStatus.error,
//         error: failure.message,
//       ),
//           (_) => state = state.copyWith(
//         isLoading: false,
//         error: null,
//       ),
//     );
//   }
//
//   bool _validateEmail(String email) {
//     return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
//   }
//
//   bool _validatePassword(String password) {
//     return password.length >= 6;
//   }
// }
//
// // 4. Providers
// // lib/features/auth/presentation/controllers/auth_providers.dart
// @riverpod
// SupabaseClient supabaseClient(SupabaseClientRef ref) {
//   return Supabase.instance.client;
// }
//
// @riverpod
// AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
//   return AuthRemoteDataSourceImpl(
//     supabaseClient: ref.watch(supabaseClientProvider),
//   );
// }
//
// @riverpod
// AuthRepository authRepository(AuthRepositoryRef ref) {
//   return AuthRepositoryImpl(
//     remoteDataSource: ref.watch(authRemoteDataSourceProvider),
//   );
// }
//
// // 5. Login Screen
// // lib/features/auth/presentation/screens/login_screen.dart
// class LoginScreen extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authControllerProvider);
//
//     ref.listen(authControllerProvider, (previous, next) {
//       if (next.status == AuthStatus.authenticated) {
//         Navigator.of(context).pushReplacementNamed('/home');
//       } else if (next.status == AuthStatus.error && next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(next.error!)),
//         );
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: authState.isLoading
//                       ? null
//                       : () => _handleLogin(context),
//                   child: authState.isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Login'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pushNamed('/register'),
//                 child: const Text('Don\'t have an account? Sign up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleLogin(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       ref.read(authControllerProvider.notifier).signIn(
//         _emailController.text.trim(),
//         _passwordController.text,
//       );
//     }
//   }
// }
//
// // 6. Security Configuration
// // lib/core/security/security_config.dart
// class SecurityConfig {
//   static const int maxLoginAttempts = 5;
//   static const Duration lockoutDuration = Duration(minutes: 15);
//   static const Duration sessionTimeout = Duration(hours: 24);
//
//   // Rate limiting for API calls
//   static const Duration apiCallInterval = Duration(seconds: 1);
//
//   // Password requirements
//   static const int minPasswordLength = 8;
//   static const bool requireUppercase = true;
//   static const bool requireLowercase = true;
//   static const bool requireNumbers = true;
//   static const bool requireSpecialChars = true;
//
//   static bool isPasswordStrong(String password) {
//     if (password.length < minPasswordLength) return false;
//     if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) return false;
//     if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) return false;
//     if (requireNumbers && !password.contains(RegExp(r'[0-9]'))) return false;
//     if (requireSpecialChars && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
//
//     return true;
//   }
// }
//
// // 7. Error Handling
// // lib/core/error/failures.dart
// abstract class Failure {
//   final String message;
//   const Failure(this.message);
// }
//
// class AuthFailure extends Failure {
//   const AuthFailure(String message) : super(message);
// }
//
// class NetworkFailure extends Failure {
//   const NetworkFailure(String message) : super(message);
// }
//
// class ServerFailure extends Failure {
//   const ServerFailure(String message) : super(message);
// }
//
// // 8. Auth Guard
// // lib/features/auth/presentation/guards/auth_guard.dart
// class AuthGuard extends ConsumerWidget {
//   final Widget child;
//
//   const AuthGuard({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authControllerProvider);
//
//     return authState.when(
//       loading: () => const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       ),
//       error: (error, stack) => const LoginScreen(),
//       data: (state) {
//         if (state.status == AuthStatus.authenticated) {
//           return child;
//         } else {
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }
