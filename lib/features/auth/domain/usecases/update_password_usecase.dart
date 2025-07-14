import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository _authRepository;

  UpdatePasswordUseCase(this._authRepository);

  Future<void> call(String newPassword, String token) async {
    if (newPassword.isEmpty || token.isEmpty) {
      throw Exception('Password and token cannot be empty');
    }

    if (newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!_isStrongPassword(newPassword)) {
      throw Exception(
        'Password must contain at least one uppercase letter, one lowercase letter, and one number',
      );
    }

    await _authRepository.updatePassword(newPassword, token);
  }

  bool _isStrongPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password);
  }
}
