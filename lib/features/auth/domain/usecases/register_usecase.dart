import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<User> call(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (name.length < 2) {
      throw Exception('Name must be at least 2 characters');
    }

    return await _authRepository.register(email, password, name);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}