import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _authRepository;

  ForgotPasswordUseCase(this._authRepository);

  Future<void> call(String email) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    await _authRepository.sendResetPasswordEmail(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
