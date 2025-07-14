import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> sendResetPasswordEmail(String email);
  Future<void> verifyEmail(String email, String code);
  Future<void> updatePassword(String newPassword, String token);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
