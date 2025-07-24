// import 'package:fpdart/fpdart.dart';
// import 'package:gotrue/gotrue.dart' as gotrue;
// import 'package:pharmacy_restaurant_seller/features/auth/domain/entities/user.dart'
//     as app_user;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../domain/entities/auth_failure.dart';
// import '../domain/repositories/auth_repository.dart';
//
// final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
//   return SupabaseAuthService();
// });
//
// class SupabaseAuthService implements AuthRepository {
//   final SupabaseClient _supabase = Supabase.instance.client;
//
//   @override
//   Future<Either<AuthFailure, void>> signIn(
//     String email,
//     String password,
//   ) async {
//     try {
//       final response = await _supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//
//       if (response.user == null) {
//         return const Left(InvalidCredentials());
//       }
//
//       return const Right(null);
//     } on AuthException catch (e) {
//       return Left(ServerError(e.message));
//     } catch (e) {
//       return Left(ServerError(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<AuthFailure, void>> signOut() async {
//     try {
//       await _supabase.auth.signOut();
//       return const Right(null);
//     } on AuthException catch (e) {
//       return Left(ServerError(e.message));
//     } catch (e) {
//       return Left(ServerError(e.toString()));
//     }
//   }
//
//   @override
//   Future<app_user.User> register(
//     String email,
//     String password,
//     String name,
//   ) async {
//     try {
//       final response = await _supabase.auth.signUp(
//         email: email,
//         password: password,
//         data: {'name': name}, // إضافة الاسم في البيانات الإضافية
//       );
//
//       if (response.user == null) {
//         throw Exception('Registration failed');
//       }
//
//       // تحويل Supabase User إلى app User
//       return _convertToAppUser(response.user!);
//     } on AuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
//
//   @override
//   Future<void> verifyPasswordResetOtp(String email, String token) async {
//     try {
//       await _supabase.auth.verifyOTP(
//         email: email,
//         token: token,
//         type: OtpType.recovery,
//       );
//     } on AuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
//
//   @override
//   Future<void> sendResetPasswordEmail(String email) async {
//     try {
//       await _supabase.auth.resetPasswordForEmail(
//         email,
//         redirectTo: 'sallerapp://reset-password', // حسب اسم التطبيق
//       );
//     } on AuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
//
//   @override
//   Future<void> verifyEmail(String email, String code) async {
//     try {
//       await _supabase.auth.verifyOTP(
//         email: email,
//         token: code,
//         type: OtpType.email,
//       );
//     } on AuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
//
//   @override
//   Future<void> updatePassword(String newPassword, String token) async {
//     try {
//       // التحقق من OTP أولاً
//       final response = await _supabase.auth.verifyOTP(
//         token: token,
//         type: OtpType.recovery,
//       );
//
//       if (response.user == null) {
//         throw Exception('Invalid token');
//       }
//
//       // تحديث كلمة المرور
//       await _supabase.auth.updateUser(UserAttributes(password: newPassword));
//     } on AuthException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
//
//   @override
//   Future<app_user.User?> getCurrentUser() async {
//     try {
//       final user = _supabase.auth.currentUser;
//       if (user == null) return null;
//
//       return _convertToAppUser(user);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Stream<app_user.User?> get authStateChanges {
//     return _supabase.auth.onAuthStateChange.map((authState) {
//       final user = authState.session?.user;
//       if (user == null) return null;
//
//       return _convertToAppUser(user);
//     });
//   }
//
//   // دالة مساعدة لتحويل Supabase User إلى app User
//   app_user.User _convertToAppUser(gotrue.User supabaseUser) {
//     return app_user.User(
//       id: supabaseUser.id,
//       email: supabaseUser.email ?? '',
//       name: supabaseUser.userMetadata?['name'] ?? supabaseUser.email ?? '',
//       isEmailVerified: true,
//       // أضف أي حقول أخرى مطلوبة في app_user.User
//     );
//   }
// }
