import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/data_source/auth_local_datasource.dart';
import '../../features/auth/presentation/riverpods/auth_providers.dart';

class AuthService {
  final AuthLocalDataSource _localDataSource;
  final Ref _ref;

  AuthService(this._localDataSource, this._ref);

  /// التحقق من حالة تسجيل الدخول عند بدء التطبيق
  Future<String> getInitialRoute() async {
    try {
      // التحقق من حالة تسجيل الدخول
      final isLoggedIn = await _localDataSource.getIsLoggedIn();

      if (!isLoggedIn) {
        return '/login';
      }

      // التحقق من انتهاء الجلسة
      final sessionExpiry = await _localDataSource.getSessionExpiry();
      if (sessionExpiry != null && DateTime.now().isAfter(sessionExpiry)) {
        await _localDataSource.clearAllData();
        return '/login';
      }

      // التحقق من المستخدم المحفوظ
      final cachedUser = await _localDataSource.getLastUser();
      if (cachedUser == null) {
        return '/login';
      }

      // التحقق من تحقق البريد الإلكتروني
      if (!cachedUser.isEmailVerified) {
        return '/email-verification';
      }

      return '/dashboard';

    } catch (e) {
      return '/login';
    }
  }

  /// تسجيل الخروج من جميع الأجهزة
  Future<void> signOutFromAllDevices() async {
    await _localDataSource.clearAllData();
    _ref.read(authNotifierProvider.notifier).signOut();
  }

  /// التحقق من صحة الجلسة
  Future<bool> isSessionValid() async {
    final sessionExpiry = await _localDataSource.getSessionExpiry();
    if (sessionExpiry == null) return false;
    return DateTime.now().isBefore(sessionExpiry);
  }

  /// تحديث الجلسة
  Future<void> refreshSession() async {
    final sessionExpiry = DateTime.now().add(const Duration(minutes: 30));
    await _localDataSource.saveSessionExpiry(sessionExpiry);
  }
}
