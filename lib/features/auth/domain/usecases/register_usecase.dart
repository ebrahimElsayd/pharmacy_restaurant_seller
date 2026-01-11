import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/erorr/failures.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, Unit>> call(SignUpParams params) async {
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