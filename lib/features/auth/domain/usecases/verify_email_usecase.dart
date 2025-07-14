import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository _authRepository;

  VerifyEmailUseCase(this._authRepository);

  Future<void> call(String email, String code) async {
    if (email.isEmpty || code.isEmpty) {
      throw Exception('Email and code cannot be empty');
    }

    if (code.length != 6) {
      throw Exception('Verification code must be 6 digits');
    }

    await _authRepository.verifyEmail(email, code);
  }
}
