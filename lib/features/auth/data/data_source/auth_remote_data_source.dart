import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<void> updatePassword({required String newPassword});

  Future<UserModel> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  });

  Future<void> deleteAccount();

  Future<void> resendEmailVerification();

  Stream<AuthState> watchAuthState();

  Future<void> refreshSession();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  const AuthRemoteDataSourceImpl({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {
          'full_name': fullName,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('فشل في إنشاء الحساب');
      }

      // إنشاء ملف البائع مع معالجة أفضل للأخطاء
      try {
        await _createSellerProfile(
          userId: user.id,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );
      } catch (e) {
        try {
          await _supabase.auth.signOut();
        } catch (_) {}

        if (e is PostgrestException) {
          if (e.message.contains('row-level security')) {
            throw const AuthException('خطأ في إعدادات الأمان. يرجى المحاولة مرة أخرى أو التواصل مع الدعم الفني.');
          }
          throw AuthException('خطأ في إنشاء الملف الشخصي: ${e.message}');
        }

        throw const AuthException('فشل في إنشاء الملف الشخصي');
      }

      return UserModel(
        id: user.id,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        isEmailVerified: user.emailConfirmedAt != null,
        createdAt: DateTime.parse(user.createdAt),
        updatedAt: user.updatedAt != null ? DateTime.parse(user.updatedAt!) : null,
        isActive: true,
      );
    } on AuthException catch (e) {
      rethrow;
    } on PostgrestException catch (e) {
      throw AuthException(_getErrorMessage(e.message));
    } catch (e) {
      throw const AuthException('حدث خطأ غير متوقع أثناء إنشاء الحساب');
    }
  }


  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('فشل في تسجيل الدخول');
      }

      // Update last login and get user profile concurrently
      final results = await Future.wait([
        _updateLastLogin(user.id),
        _getUserProfile(user.id),
      ]);

      final userProfile = results[1] as Map<String, dynamic>;

      return UserModel.fromSupabaseUser(
        userProfile,
        user.id,
        user.email!,
      );
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e) {
      throw AuthException(_getErrorMessage(e.message));
    } catch (e) {
      throw AuthException('فشل في تسجيل الدخول');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('فشل في تسجيل الخروج');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user?.id == null || user?.email == null) return null;

      final userProfile = await _getUserProfile(user!.id);
      return UserModel.fromSupabaseUser(
        userProfile,
        user.id,
        user.email!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        // redirectTo: Constants.resetPasswordRedirectUrl,
      );
    } catch (e) {
      throw AuthException('فشل في إرسال رابط استعادة كلمة المرور');
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw AuthException('فشل في تحديث كلمة المرور');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final updatedData = {
        ...userData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('sellers')
          .update(updatedData)
          .eq('id', userId)
          .select()
          .single();

      final currentUser = _supabase.auth.currentUser;
      if (currentUser?.email == null) {
        throw const AuthException('المستخدم غير مسجل دخول');
      }

      return UserModel.fromSupabaseUser(
        response,
        userId,
        currentUser!.email!,
      );
    } on PostgrestException catch (e) {
      throw AuthException('فشل في تحديث البيانات: ${e.message}');
    } catch (e) {
      throw AuthException('فشل في تحديث الملف الشخصي');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const AuthException('المستخدم غير مسجل دخول');
      }

      // Delete user profile first, then auth user
      await _supabase.from('sellers').delete().eq('id', user.id);

      // Note: This might need admin privileges or different implementation
      // based on your Supabase configuration
      await _supabase.auth.admin.deleteUser(user.id);
    } on PostgrestException catch (e) {
      throw AuthException('فشل في حذف بيانات المستخدم');
    } catch (e) {
      throw AuthException('فشل في حذف الحساب');
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user?.email == null) {
        throw const AuthException('المستخدم غير مسجل دخول');
      }

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: user!.email,
      );
    } catch (e) {
      throw AuthException('فشل في إرسال رسالة التحقق');
    }
  }

  @override
  Stream<AuthState> watchAuthState() {
    return _supabase.auth.onAuthStateChange;
  }

  @override
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
    } catch (e) {
      throw AuthException('فشل في تحديث الجلسة');
    }
  }

  // Private helper methods
  Future<void> _createSellerProfile({
    required String userId,
    required String email,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final sellerData = <String, dynamic>{
        'id': userId,
        'email': email,
        'full_name': fullName,
        'email_verified': false,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      };

      final response = await _supabase
          .from('sellers')
          .insert(sellerData)
          .select()
          .single();

    } on PostgrestException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getUserProfile(String userId) async {
    final response = await _supabase
        .from('sellers')
        .select()
        .eq('id', userId)
        .single();

    return response;
  }

  Future<void> _updateLastLogin(String userId) async {
    await _supabase.from('sellers').update({
      'last_login_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  String _getErrorMessage(String error) {
    final errorLower = error.toLowerCase();

    // أخطاء Row Level Security
    if (errorLower.contains('row-level security') ||
        errorLower.contains('policy')) {
      return 'خطأ في إعدادات الأمان. يرجى المحاولة مرة أخرى.';
    }

    // أخطاء البريد الإلكتروني
    if (errorLower.contains('email')) {
      if (errorLower.contains('already') || errorLower.contains('exists')) {
        return 'البريد الإلكتروني مستخدم مسبقاً';
      }
      if (errorLower.contains('invalid') || errorLower.contains('format')) {
        return 'البريد الإلكتروني غير صحيح';
      }
    }

    // أخطاء كلمة المرور
    if (errorLower.contains('password')) {
      if (errorLower.contains('weak') || errorLower.contains('short')) {
        return 'كلمة المرور ضعيفة أو قصيرة';
      }
    }

    // أخطاء قاعدة البيانات
    if (errorLower.contains('duplicate') || errorLower.contains('unique')) {
      return 'البيانات مكررة. المستخدم موجود مسبقاً.';
    }

    // أخطاء الشبكة
    if (errorLower.contains('network') || errorLower.contains('connection') || errorLower.contains('timeout')) {
      return 'مشكلة في الاتصال، تحقق من الإنترنت';
    }

    // أخطاء الخادم
    if (errorLower.contains('server') || errorLower.contains('500')) {
      return 'خطأ في الخادم، حاول مرة أخرى';
    }

    return 'حدث خطأ غير متوقع';
  }

}