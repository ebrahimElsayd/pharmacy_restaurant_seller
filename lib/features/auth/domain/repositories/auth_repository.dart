import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/erorr/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
  });

  Future<Either<Failure, Unit>> updatePassword({
    required String newPassword,
  });

  Future<Either<Failure, Unit>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  });

  Future<Either<Failure, Unit>> deleteAccount();

  Future<Either<Failure, Unit>> resendEmailVerification();

  Stream<User?> watchAuthState();

  Future<Either<Failure, Unit>> refreshSession();
}
