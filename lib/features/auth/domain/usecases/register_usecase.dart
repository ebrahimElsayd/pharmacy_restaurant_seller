import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';  // تأكد من استيراد هذا
import '../repositories/auth_repository.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/erorr/failures.dart'; // مسار الفشل

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, void>> call(SignUpParams params) async {
    // Validate input
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return left(ValidationFailure(message: emailValidation));
    }

    final passwordValidation = Validators.validatePassword(params.password);
    if (passwordValidation != null) {
      return left(ValidationFailure(message: passwordValidation));
    }

    final nameValidation = Validators.validateName(params.fullName);
    if (nameValidation != null) {
      return left(ValidationFailure(message: nameValidation));
    }

    // Validate phone number if provided
    if (params.phoneNumber != null) {
      final phoneValidation = Validators.validatePhoneNumber(params.phoneNumber!);
      if (phoneValidation != null) {
        return left(ValidationFailure(message: phoneValidation));
      }
    }

    // Execute sign up
    return await _repository.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String? phoneNumber;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, fullName, phoneNumber];

  @override
  String toString() =>
      'SignUpParams(email: $email, fullName: $fullName, phoneNumber: $phoneNumber, password: [HIDDEN])';
}
