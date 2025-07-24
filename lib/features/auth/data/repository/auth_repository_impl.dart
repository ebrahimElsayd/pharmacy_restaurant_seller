import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/erorr/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
// import '../data_source/auth_local_data_source.dart'; // سيتم إضافة هذه الميزة لاحقاً

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  // final AuthLocalDataSource _localDataSource; // سيتم إضافة الكاش المحلي لاحقاً
  final Connectivity _connectivity;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    // required AuthLocalDataSource localDataSource, // سيتم إضافة الكاش المحلي لاحقاً
    required Connectivity connectivity,
  }) : _remoteDataSource = remoteDataSource,
       // _localDataSource = localDataSource, // سيتم إضافة الكاش المحلي لاحقاً
       _connectivity = connectivity;

  @override
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      // التحقق من الاتصال بالإنترنت
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      return const Right(unit);

    } on AuthException catch (e) {
      // معالجة أخطاء المصادقة بشكل صحيح
      return Left(AuthFailure(message: e.message, code: e.code));
    } on PostgrestException catch (e) {
      // معالجة أخطاء قاعدة البيانات
      return Left(AuthFailure(message: 'خطأ في قاعدة البيانات: ${e.message}', code: 'database_error'));
    } catch (e) {
      // معالجة باقي الأخطاء
      print('[ERROR] ❌ signUp failed: $e');
      return Left(
        AuthFailure(message: 'فشل في إنشاء الحساب', code: 'signup_error'),
      );
    }
  }


  @override
  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // التحقق من الاتصال بالإنترنت
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      // التحقق من حالة القفل (سيتم تفعيلها لاحقاً مع الكاش المحلي)
      // final lockoutResult = await _checkAccountLockout();
      // if (lockoutResult != null) return lockoutResult;

      await _remoteDataSource.signIn(email: email, password: password);

      // حفظ بيانات المستخدم وتسجيل وقت الدخول (سيتم تفعيلها لاحقاً)
      // await _cacheUserData(user);
      // await _saveLoginTime();
      // await _clearLockoutData();

      return const Right(unit);
    } on AuthException catch (e) {
      // معالجة محاولات الدخول الفاشلة (سيتم تفعيلها لاحقاً)
      // await _handleFailedLogin();
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      // await _handleFailedLogin(); // سيتم تفعيلها لاحقاً
      return Left(
        AuthFailure(message: 'فشل في تسجيل الدخول', code: 'signin_error'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      // مسح جميع البيانات المحلية (سيتم تفعيلها لاحقاً)
      // await _localDataSource.clearAllData();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(
        AuthFailure(message: 'فشل في تسجيل الخروج', code: 'signout_error'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // محاولة الحصول على بيانات المستخدم من الخادم أولاً
      if (await _isNetworkAvailable()) {
        try {
          final user = await _remoteDataSource.getCurrentUser();
          if (user != null) {
            // حفظ البيانات في الكاش المحلي (سيتم تفعيلها لاحقاً)
            // await _localDataSource.cacheUser(user);
            return Right(user);
          }
        } catch (e) {
          // في حالة فشل الحصول على البيانات من الخادم، سنحاول الكاش المحلي
        }
      }

      // العودة للكاش المحلي (سيتم تفعيلها لاحقاً)
      // final cachedUser = await _localDataSource.getLastUser();
      // if (cachedUser != null) {
      //   return Right(cachedUser);
      // }

      return Left(
        AuthFailure(
          message: 'لم يتم العثور على مستخدم',
          code: 'user_not_found',
        ),
      );
    } catch (e) {
      return Left(
        AuthFailure(
          message: 'فشل في الحصول على بيانات المستخدم',
          code: 'get_user_error',
        ),
      );
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
      return Left(
        AuthFailure(
          message: 'فشل في إرسال رابط استعادة كلمة المرور',
          code: 'reset_password_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String newPassword,
  }) async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.updatePassword(newPassword: newPassword);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(
        AuthFailure(
          message: 'فشل في تحديث كلمة المرور',
          code: 'update_password_error',
        ),
      );
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

      await _remoteDataSource.updateUserProfile(
        userId: userId,
        userData: userData,
      );

      // حفظ البيانات المحدثة في الكاش (سيتم تفعيلها لاحقاً)
      // await _localDataSource.cacheUser(user);

      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(
        AuthFailure(
          message: 'فشل في تحديث الملف الشخصي',
          code: 'update_profile_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      if (!await _isNetworkAvailable()) {
        return Left(NetworkFailure.noInternet());
      }

      await _remoteDataSource.deleteAccount();
      // مسح جميع البيانات المحلية (سيتم تفعيلها لاحقاً)
      // await _localDataSource.clearAllData();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(
        AuthFailure(message: 'فشل في حذف الحساب', code: 'delete_account_error'),
      );
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
      return Left(
        AuthFailure(
          message: 'فشل في إرسال رسالة التحقق',
          code: 'resend_verification_error',
        ),
      );
    }
  }

  @override
  Stream<User?> watchAuthState() {
    return _remoteDataSource
        .watchAuthState()
        .map((authState) {
          return authState.session?.user;
        })
        .handleError((error) {
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
      return Left(
        AuthFailure(
          message: 'فشل في تحديث الجلسة',
          code: 'refresh_session_error',
        ),
      );
    }
  }

  // دوال مساعدة خاصة

  /// التحقق من توفر الاتصال بالإنترنت
  Future<bool> _isNetworkAvailable() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /*
   * الدوال التالية سيتم تفعيلها عند إضافة ميزة الكاش المحلي:
   *
   * /// التحقق من حالة قفل الحساب
   * Future<Either<Failure, Unit>?> _checkAccountLockout() async {
   *   final lockoutTime = await _localDataSource.getLockoutTime();
   *   if (lockoutTime != null && DateTime.now().isBefore(lockoutTime)) {
   *     final remainingTime = lockoutTime.difference(DateTime.now());
   *     return Left(AuthFailure(
   *       message: 'الحساب مقفل لمدة ${remainingTime.inMinutes} دقيقة',
   *       code: 'account_locked',
   *     ));
   *   }
   *   return null;
   * }
   *
   * /// حفظ بيانات المستخدم في الكاش المحلي
   * Future<void> _cacheUserData(UserEntity user) async {
   *   await _localDataSource.cacheUser(user);
   * }
   *
   * /// حفظ وقت تسجيل الدخول
   * Future<void> _saveLoginTime() async {
   *   await _localDataSource.saveLastLoginTime(DateTime.now());
   * }
   *
   * /// مسح بيانات القفل
   * Future<void> _clearLockoutData() async {
   *   await _localDataSource.clearLockoutTime();
   *   await _localDataSource.clearLoginAttempts();
   * }
   *
   * /// معالجة محاولات الدخول الفاشلة
   * Future<void> _handleFailedLogin() async {
   *   final attempts = await _localDataSource.getLoginAttempts();
   *   final newAttempts = attempts + 1;
   *
   *   await _localDataSource.saveLoginAttempts(newAttempts);
   *
   *   if (newAttempts >= Constants.maxLoginAttempts) {
   *     final lockoutTime = DateTime.now().add(
   *       Duration(minutes: AppConstants.lockoutDurationMinutes),
   *     );
   *     await _localDataSource.saveLockoutTime(lockoutTime);
   *     await _localDataSource.clearLoginAttempts();
   *   }
   * }
   */
}
