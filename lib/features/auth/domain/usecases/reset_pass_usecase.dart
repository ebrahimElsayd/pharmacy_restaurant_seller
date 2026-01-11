import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, Unit>> call(ResetPasswordParams params) async {
    return await _repository.updatePassword(
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String newPassword;

  const ResetPasswordParams({
    required this.newPassword,
  });

  @override
  List<Object?> get props => [newPassword];

  @override
  String toString() => 'ResetPasswordParams(newPassword: [HIDDEN])';
}