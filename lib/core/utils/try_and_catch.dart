import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../erorr/failures.dart';
import 'netowrk_exception.dart';

// Repository layer exception handler - returns Either<Failure, T>
Future<Either<Failure, T>> executeTryAndCatchForRepository<T>(
    Future<T> Function() action,
    ) async {
  try {
    // Check internet connectivity first
    var connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      return left(NetworkFailure.noInternet());
    }

    final result = await action();
    return right(result);
  } on FormatException catch (e) {
    return left(ParsingFailure.custom('خطأ في تحليل البيانات: ${e.message}'));
  } on NoInternetException catch (e) {
    return left(NetworkFailure.custom(e.message));
  } on StorageException catch (e) {
    return left(CacheFailure.custom('خطأ في التخزين: ${e.message}'));
  } on PostgrestException catch (e) {
    // Handle different Supabase error codes
    if (e.code != null) {
      switch (e.code) {
        case '23505': // Unique violation
          return left(ValidationFailure.custom('البيانات موجودة مسبقاً'));
        case '23503': // Foreign key violation
          return left(ValidationFailure.custom('بيانات مرجعية غير صحيحة'));
        case '42P01': // Table doesn't exist
          return left(ServerFailure.custom('خطأ في قاعدة البيانات'));
        default:
          return left(ServerFailure.custom('خطأ في الخادم: ${e.message}'));
      }
    }
    return left(ServerFailure.custom(e.message));
  } on AuthException catch (e) {
    // Handle different auth error codes
    switch (e.message.toLowerCase()) {
      case 'invalid_credentials':
        return left(AuthFailure.invalidCredentials());
      case 'user_not_found':
        return left(AuthFailure.userNotFound());
      case 'email_already_in_use':
        return left(AuthFailure.emailAlreadyInUse());
      case 'weak_password':
        return left(AuthFailure.weakPassword());
      case 'email_not_verified':
        return left(AuthFailure.emailNotVerified());
      case 'session_expired':
        return left(AuthFailure.sessionExpired());
      case 'too_many_attempts':
        return left(AuthFailure.tooManyAttempts());
      default:
        return left(AuthFailure.custom(e.message));
    }
  } on TypeError catch (e) {
    return left(ParsingFailure.typeError());
  } on NoSuchMethodError catch (e) {
    return left(ParsingFailure.custom('حقل مفقود في البيانات: ${e.toString()}'));
  } on TimeoutException catch (e) {
    return left(NetworkFailure.timeout());
  } on SocketException catch (e) {
    return left(NetworkFailure.custom('خطأ في الشبكة: ${e.message}'));
  } catch (e) {
    print('Caught unexpected exception: ${e.hashCode} - ${e.toString()}');
    return left(UnknownFailure.unexpected(e.toString()));
  }
}

// Data layer exception handler - throws specific exceptions
Future<T> executeTryAndCatchForDataLayer<T>(Future<T> Function() action) async {
  try {
    var check = await Connectivity().checkConnectivity();

    // Uncomment and modify rate limiting logic as needed
    // final rateLimitResponse = await checkRateLimit();
    // if (rateLimitResponse.isExceeded) {
    //   throw Exception(
    //       'API rate limit exceeded. Please try again in ${rateLimitResponse.reset} seconds.');
    // }

    if (check.contains(ConnectivityResult.mobile) ||
        check.contains(ConnectivityResult.wifi)) {
      return await action();
    } else {
      throw NoInternetException();
    }
  } on AuthException catch (e) {
    throw AuthException(e.message);
  } on PostgrestException catch (e) {
    throw PostgrestException(message: e.message, code: e.code);
  } on TimeoutException catch (e) {
    throw TimeoutException('انتهت مهلة العملية: ${e.message}', e.duration);
  } on SocketException catch (e) {
    throw SocketException('خطأ في الشبكة: ${e.message}');
  } on StorageException catch (e) {
    throw StorageException('خطأ في التخزين: ${e.message}');
  } on FormatException catch (e) {
    throw FormatException('خطأ في تحليل البيانات: ${e.message}');
  } catch (e) {
    throw Exception('خطأ غير متوقع: ${e.toString()}');
  }
}

// Utility function to convert exceptions to appropriate failures
Failure mapExceptionToFailure(dynamic exception) {
  if (exception is AuthException) {
    return AuthFailure.custom(exception.message);
  } else if (exception is PostgrestException) {
    return ServerFailure.custom(exception.message);
  } else if (exception is StorageException) {
    return CacheFailure.custom(exception.message);
  } else if (exception is TimeoutException) {
    return NetworkFailure.timeout();
  } else if (exception is SocketException) {
    return NetworkFailure.custom(exception.message);
  } else if (exception is FormatException) {
    return ParsingFailure.formatError();
  } else if (exception is NoInternetException) {
    return NetworkFailure.noInternet();
  } else {
    return UnknownFailure.unexpected(exception.toString());
  }
}