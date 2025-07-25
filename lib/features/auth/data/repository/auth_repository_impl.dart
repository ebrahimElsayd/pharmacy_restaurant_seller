import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/erorr/failures.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_local_datasource.dart';
import '../data_source/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required Connectivity connectivity,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      final user = await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      if (user != null) {
        await _cacheUserData(user);
        await _localDataSource.saveIsLoggedIn(true);
        await _localDataSource.saveLastLoginTime(DateTime.now());
        await _saveSessionExpiry();
      }

      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on PostgrestException catch (e) {
      return Left(AuthFailure(message: 'خطأ في قاعدة البيانات: ${e.message}', code: 'database_error'));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في إنشاء الحساب', code: 'signup_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      final lockoutResult = await _checkAccountLockout();
      if (lockoutResult != null) return lockoutResult;

      final user = await _remoteDataSource.signIn(email: email, password: password);

      if (user != null) {
        await _cacheUserData(user);
        await _localDataSource.saveIsLoggedIn(true);
        await _localDataSource.saveLastLoginTime(DateTime.now());
        await _saveSessionExpiry();
        await _clearLockoutData();
      }

      return const Right(unit);
    } on AuthException catch (e) {
      await _handleFailedLogin();
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      await _handleFailedLogin();
      return Left(AuthFailure(message: 'فشل في تسجيل الدخول', code: 'signin_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _localDataSource.clearAllData();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في تسجيل الخروج', code: 'signout_error'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      if (await _isSessionExpired()) {
        await _localDataSource.clearAllData();
        return Left(AuthFailure(message: 'انتهت صلاحية الجلسة', code: 'session_expired'));
      }

      final isLoggedIn = await _localDataSource.getIsLoggedIn();
      if (!isLoggedIn) {
        return Left(AuthFailure(message: 'لم يتم العثور على مستخدم', code: 'user_not_found'));
      }

      if (await _isNetworkAvailable()) {
        try {
          final user = await _remoteDataSource.getCurrentUser();
          if (user != null) {
            await _cacheUserData(user);
            return Right(user);
          }
        } catch (_) {
          // fallback to cache
        }
      }

      final cachedUser = await _localDataSource.getLastUser();
      if (cachedUser != null) return Right(cachedUser);

      return Left(AuthFailure(message: 'لم يتم العثور على مستخدم', code: 'user_not_found'));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في الحصول على بيانات المستخدم', code: 'get_user_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }
      await _remoteDataSource.resetPassword(email: email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في إرسال رابط الاستعادة', code: 'reset_password_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({required String newPassword}) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }
      await _remoteDataSource.updatePassword(newPassword: newPassword);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في تحديث كلمة المرور', code: 'update_password_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.updateUserProfile(userId: userId, userData: userData);

      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في تحديث الملف الشخصي', code: 'update_profile_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.deleteAccount();
      await _localDataSource.clearAllData();

      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في حذف الحساب', code: 'delete_account_error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendEmailVerification() async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.resendEmailVerification();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في إرسال رسالة التحقق', code: 'resend_verification_error'));
    }
  }

  @override
  Stream<User?> watchAuthState() {
    return _remoteDataSource.watchAuthState().map((authState) {
      return authState.session?.user;
    }).handleError((error) {
      throw AuthFailure(
        message: 'خطأ في مراقبة حالة المصادقة',
        code: 'watch_auth_state_error',
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> refreshSession() async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.refreshSession();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: 'فشل في تحديث الجلسة', code: 'refresh_session_error'));
    }
  }

  // ============== الدوال المساعدة ==============

  Future<bool> _isNetworkAvailable() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _cacheUserData(UserEntity user) async {
    await _localDataSource.cacheUser(user as UserModel);
  }

  Future<void> _saveSessionExpiry() async {
    final expiry = DateTime.now().add(Duration(minutes: Constants.sessionTimeoutMinutes));
    await _localDataSource.saveSessionExpiry(expiry);
  }

  Future<bool> _isSessionExpired() async {
    final expiry = await _localDataSource.getSessionExpiry();
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  Future<Either<Failure, Unit>?> _checkAccountLockout() async {
    final lockoutTime = await _localDataSource.getLockoutTime();
    if (lockoutTime != null && DateTime.now().isBefore(lockoutTime)) {
      final remaining = lockoutTime.difference(DateTime.now());
      return Left(AuthFailure(
        message: 'الحساب مقفل لمدة ${remaining.inMinutes} دقيقة',
        code: 'account_locked',
      ));
    }
    return null;
  }

  Future<void> _handleFailedLogin() async {
    final attempts = await _localDataSource.getLoginAttempts();
    final newAttempts = attempts + 1;
    await _localDataSource.saveLoginAttempts(newAttempts);

    if (newAttempts >= Constants.maxLoginAttempts) {
      final lockout = DateTime.now().add(Duration(minutes: Constants.lockoutDurationMinutes));
      await _localDataSource.saveLockoutTime(lockout);
      await _localDataSource.clearLoginAttempts();
    }
  }

  Future<void> _clearLockoutData() async {
    await _localDataSource.clearLockoutTime();
    await _localDataSource.clearLoginAttempts();
  }
}
