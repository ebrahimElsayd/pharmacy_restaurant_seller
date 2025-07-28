import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failures.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/validators.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    // التحقق من صحة البريد الإلكتروني
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return Left(ValidationFailure(message: emailValidation));
    }

    return await _repository.resetPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'ForgotPasswordParams(email: $email)';
}