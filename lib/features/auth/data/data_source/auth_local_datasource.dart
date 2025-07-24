// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/constants/constants.dart';
// import '../models/user_model.dart';
//
// abstract class AuthLocalDataSource {
//   Future cacheUser(UserModel user);
//   Future getLastUser();
//   Future clearUserCache();
//   Future saveAuthToken(String token);
//   Future getAuthToken();
//   Future clearAuthToken();
//   Future saveRefreshToken(String token);
//   Future getRefreshToken();
//   Future clearRefreshToken();
//   Future saveLoginAttempts(int attempts);
//   Future getLoginAttempts();
//   Future clearLoginAttempts();
//   Future saveLockoutTime(DateTime lockoutTime);
//   Future getLockoutTime();
//   Future clearLockoutTime();
//   Future saveLastLoginTime(DateTime lastLogin);
//   Future getLastLoginTime();
//   Future clearAllData();
// }
//
// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final FlutterSecureStorage _secureStorage;
//   final SharedPreferences _sharedPreferences;
//
//   AuthLocalDataSourceImpl({
//     required FlutterSecureStorage secureStorage,
//     required SharedPreferences sharedPreferences,
//   }) : _secureStorage = secureStorage,
//         _sharedPreferences = sharedPreferences;
//
//   @override
//   Future cacheUser(UserModel user) async {
//     try {
//       final userJson = jsonEncode(user.toJson());
//       await _secureStorage.write(
//         key: Constants.userDataKey,
//         value: userJson,
//       );
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ بيانات المستخدم',
//         code: 'cache_user_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getLastUser() async {
//     try {
//       final userJson = await _secureStorage.read(
//         key: Constants.userDataKey,
//       );
//
//       if (userJson == null) {
//         return null;
//       }
//
//       final userMap = jsonDecode(userJson) as Map<String,dynamic>;
//       return UserModel.fromJson(userMap);
//     } catch (e) {
//       return null; // Return null if can't parse user data
//     }
//   }
//
//   @override
//   Future clearUserCache() async {
//     try {
//       await _secureStorage.delete(key: Constants.userDataKey);
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف بيانات المستخدم',
//         code: 'clear_user_cache_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future saveAuthToken(String token) async {
//     try {
//       await _secureStorage.write(
//         key: Constants.authTokenKey,
//         value: token,
//       );
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ رمز المصادقة',
//         code: 'save_auth_token_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getAuthToken() async {
//     try {
//       return await _secureStorage.read(key: AppConstants.authTokenKey);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Future clearAuthToken() async {
//     try {
//       await _secureStorage.delete(key: Constants.authTokenKey);
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف رمز المصادقة',
//         code: 'clear_auth_token_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future saveRefreshToken(String token) async {
//     try {
//       await _secureStorage.write(
//         key: Constants.refreshTokenKey,
//         value: token,
//       );
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ رمز التحديث',
//         code: 'save_refresh_token_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getRefreshToken() async {
//     try {
//       return await _secureStorage.read(key: AppConstants.refreshTokenKey);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Future clearRefreshToken() async {
//     try {
//       await _secureStorage.delete(key: Constants.refreshTokenKey);
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف رمز التحديث',
//         code: 'clear_refresh_token_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future saveLoginAttempts(int attempts) async {
//     try {
//       await _sharedPreferences.setInt('login_attempts', attempts);
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ محاولات تسجيل الدخول',
//         code: 'save_login_attempts_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getLoginAttempts() async {
//     try {
//       return _sharedPreferences.getInt('login_attempts') ?? 0;
//     } catch (e) {
//       return 0;
//     }
//   }
//
//   @override
//   Future clearLoginAttempts() async {
//     try {
//       await _sharedPreferences.remove('login_attempts');
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف محاولات تسجيل الدخول',
//         code: 'clear_login_attempts_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future saveLockoutTime(DateTime lockoutTime) async {
//     try {
//       await _sharedPreferences.setString(
//         'lockout_time',
//         lockoutTime.toIso8601String(),
//       );
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ وقت القفل',
//         code: 'save_lockout_time_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getLockoutTime() async {
//     try {
//       final lockoutTimeStr = _sharedPreferences.getString('lockout_time');
//       if (lockoutTimeStr == null) return null;
//
//       return DateTime.parse(lockoutTimeStr);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Future clearLockoutTime() async {
//     try {
//       await _sharedPreferences.remove('lockout_time');
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف وقت القفل',
//         code: 'clear_lockout_time_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future saveLastLoginTime(DateTime lastLogin) async {
//     try {
//       await _sharedPreferences.setString(
//         'last_login_time',
//         lastLogin.toIso8601String(),
//       );
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حفظ وقت آخر تسجيل دخول',
//         code: 'save_last_login_error',
//         originalError: e,
//       );
//     }
//   }
//
//   @override
//   Future getLastLoginTime() async {
//     try {
//       final lastLoginStr = _sharedPreferences.getString('last_login_time');
//       if (lastLoginStr == null) return null;
//
//       return DateTime.parse(lastLoginStr);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Future clearAllData() async {
//     try {
//       await _secureStorage.deleteAll();
//       await _sharedPreferences.clear();
//     } catch (e) {
//       throw CacheException(
//         message: 'فشل في حذف جميع البيانات',
//         code: 'clear_all_data_error',
//         originalError: e,
//       );
//     }
//   }
// }