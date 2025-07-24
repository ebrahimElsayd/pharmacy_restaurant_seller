import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failures.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/validators.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, Unit>> call(SignInParams params) async {
    // Validate input
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return left(ValidationFailure(message: emailValidation));
    }

    final passwordValidation = Validators.validatePassword(params.password);
    if (passwordValidation != null) {
      return left(ValidationFailure(message: passwordValidation));
    }

    // Execute sign in
    return await _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'SignInParams(email: $email, password: [HIDDEN])';
}
