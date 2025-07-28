// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class SupabaseAuthService {
//   final SupabaseClient _supabase = Supabase.instance.client;
//
//   // تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
//   Future<AuthResponse> signInWithPassword(String email, String password) async {
//     return await _supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//   }
//
//   // إنشاء حساب جديد
//   Future<AuthResponse> signUp(String email, String password, Map<String, dynamic> userData) async {
//     return await _supabase.auth.signUp(
//       email: email,
//       password: password,
//       data: userData,
//     );
//   }
//
//   // تسجيل الخروج
//   Future<void> signOut() async {
//     await _supabase.auth.signOut();
//   }
//
//   // الحصول على المستخدم الحالي
//   User? getCurrentUser() {
//     return _supabase.auth.currentUser;
//   }
//
//   // طلب إعادة تعيين كلمة المرور
//   Future<void> resetPassword(String email, {String? redirectUrl}) async {
//     await _supabase.auth.resetPasswordForEmail(
//       email,
//       redirectTo: redirectUrl,
//     );
//   }
//
//   // تحديث كلمة المرور
//   Future<UserResponse> updatePassword(String newPassword) async {
//     return await _supabase.auth.updateUser(
//       UserAttributes(password: newPassword),
//     );
//   }
//
//   // إرسال رسالة تحقق من البريد الإلكتروني
//   Future<void> sendEmailVerification(String email) async {
//     await _supabase.auth.resend(
//       type: OtpType.signup,
//       email: email,
//     );
//   }
//
//   // تحديث بيانات المستخدم
//   Future<UserResponse> updateUserData(Map<String, dynamic> userData) async {
//     return await _supabase.auth.updateUser(UserAttributes(data: userData));
//   }
//
//   // مراقبة حالة المصادقة
//   Stream<AuthState> onAuthStateChange() {
//     return _supabase.auth.onAuthStateChange;
//   }
//
//   // تجديد الجلسة
//   Future<void> refreshSession() async {
//     await _supabase.auth.refreshSession();
//   }
// }