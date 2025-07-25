import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  // User Data Management
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastUser();
  Future<void> clearUserCache();

  // Authentication State
  Future<void> saveIsLoggedIn(bool isLoggedIn);
  Future<bool> getIsLoggedIn();
  Future<void> clearIsLoggedIn();

  // Tokens Management
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();

  // Login Attempts & Security
  Future<void> saveLoginAttempts(int attempts);
  Future<int> getLoginAttempts();
  Future<void> clearLoginAttempts();

  Future<void> saveLockoutTime(DateTime lockoutTime);
  Future<DateTime?> getLockoutTime();
  Future<void> clearLockoutTime();

  // Session Management
  Future<void> saveLastLoginTime(DateTime lastLogin);
  Future<DateTime?> getLastLoginTime();
  Future<void> saveSessionExpiry(DateTime expiry);
  Future<DateTime?> getSessionExpiry();

  // User Preferences
  Future<void> saveRememberMe(bool remember);
  Future<bool> getRememberMe();

  // Complete cleanup
  Future<void> clearAllData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences;

  // User Data Management
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(
        key: Constants.userDataKey,
        value: userJson,
      );
    } catch (e) {
      throw Exception('فشل في حفظ بيانات المستخدم: $e');
    }
  }

  @override
  Future<UserModel?> getLastUser() async {
    try {
      final userJson = await _secureStorage.read(key: Constants.userDataKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearUserCache() async {
    try {
      await _secureStorage.delete(key: Constants.userDataKey);
    } catch (e) {
      throw Exception('فشل في حذف بيانات المستخدم: $e');
    }
  }

  // Authentication State
  @override
  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    try {
      await _sharedPreferences.setBool(Constants.isLoggedInKey, isLoggedIn);
    } catch (e) {
      throw Exception('فشل في حفظ حالة تسجيل الدخول: $e');
    }
  }

  @override
  Future<bool> getIsLoggedIn() async {
    try {
      return _sharedPreferences.getBool(Constants.isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearIsLoggedIn() async {
    try {
      await _sharedPreferences.remove(Constants.isLoggedInKey);
    } catch (e) {
      throw Exception('فشل في حذف حالة تسجيل الدخول: $e');
    }
  }

  // Tokens Management
  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: Constants.authTokenKey, value: token);
    } catch (e) {
      throw Exception('فشل في حفظ رمز المصادقة: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: Constants.authTokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await _secureStorage.delete(key: Constants.authTokenKey);
    } catch (e) {
      throw Exception('فشل في حذف رمز المصادقة: $e');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: Constants.refreshTokenKey, value: token);
    } catch (e) {
      throw Exception('فشل في حفظ رمز التحديث: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: Constants.refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearRefreshToken() async {
    try {
      await _secureStorage.delete(key: Constants.refreshTokenKey);
    } catch (e) {
      throw Exception('فشل في حذف رمز التحديث: $e');
    }
  }

  // Login Attempts & Security
  @override
  Future<void> saveLoginAttempts(int attempts) async {
    try {
      await _sharedPreferences.setInt(Constants.loginAttemptsKey, attempts);
    } catch (e) {
      throw Exception('فشل في حفظ محاولات تسجيل الدخول: $e');
    }
  }

  @override
  Future<int> getLoginAttempts() async {
    try {
      return _sharedPreferences.getInt(Constants.loginAttemptsKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> clearLoginAttempts() async {
    try {
      await _sharedPreferences.remove(Constants.loginAttemptsKey);
    } catch (e) {
      throw Exception('فشل في حذف محاولات تسجيل الدخول: $e');
    }
  }

  @override
  Future<void> saveLockoutTime(DateTime lockoutTime) async {
    try {
      await _sharedPreferences.setString(
        Constants.lockoutTimeKey,
        lockoutTime.toIso8601String(),
      );
    } catch (e) {
      throw Exception('فشل في حفظ وقت القفل: $e');
    }
  }

  @override
  Future<DateTime?> getLockoutTime() async {
    try {
      final lockoutTimeStr = _sharedPreferences.getString(Constants.lockoutTimeKey);
      if (lockoutTimeStr == null) return null;
      return DateTime.parse(lockoutTimeStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearLockoutTime() async {
    try {
      await _sharedPreferences.remove(Constants.lockoutTimeKey);
    } catch (e) {
      throw Exception('فشل في حذف وقت القفل: $e');
    }
  }

  // Session Management
  @override
  Future<void> saveLastLoginTime(DateTime lastLogin) async {
    try {
      await _sharedPreferences.setString(
        Constants.lastLoginTimeKey,
        lastLogin.toIso8601String(),
      );
    } catch (e) {
      throw Exception('فشل في حفظ وقت آخر تسجيل دخول: $e');
    }
  }

  @override
  Future<DateTime?> getLastLoginTime() async {
    try {
      final lastLoginStr = _sharedPreferences.getString(Constants.lastLoginTimeKey);
      if (lastLoginStr == null) return null;
      return DateTime.parse(lastLoginStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSessionExpiry(DateTime expiry) async {
    try {
      await _sharedPreferences.setString(
        Constants.sessionExpiryKey,
        expiry.toIso8601String(),
      );
    } catch (e) {
      throw Exception('فشل في حفظ انتهاء الجلسة: $e');
    }
  }

  @override
  Future<DateTime?> getSessionExpiry() async {
    try {
      final expiryStr = _sharedPreferences.getString(Constants.sessionExpiryKey);
      if (expiryStr == null) return null;
      return DateTime.parse(expiryStr);
    } catch (e) {
      return null;
    }
  }

  // User Preferences
  @override
  Future<void> saveRememberMe(bool remember) async {
    try {
      await _sharedPreferences.setBool(Constants.rememberMeKey, remember);
    } catch (e) {
      throw Exception('فشل في حفظ تذكرني: $e');
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      return _sharedPreferences.getBool(Constants.rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Complete cleanup
  @override
  Future<void> clearAllData() async {
    try {
      await _secureStorage.deleteAll();
      await _sharedPreferences.clear();
    } catch (e) {
      throw Exception('فشل في حذف جميع البيانات: $e');
    }
  }
}
