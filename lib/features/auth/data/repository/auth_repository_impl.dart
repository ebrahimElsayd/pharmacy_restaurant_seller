import 'package:pharmacy_restaurant_seller/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pharmacy_restaurant_seller/features/auth/domain/entities/user.dart';
import 'package:pharmacy_restaurant_seller/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    try {
      return await _remoteDataSource.signInWithEmail(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      return await _remoteDataSource.signUp(email, password, name);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> verifyEmail(String email, String code) async {
    try {
      await _remoteDataSource.verifyOTP(email, code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updatePassword(String newPassword, String token) async {
    try {
      await _remoteDataSource.updatePassword(newPassword, token);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await _remoteDataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;
}
