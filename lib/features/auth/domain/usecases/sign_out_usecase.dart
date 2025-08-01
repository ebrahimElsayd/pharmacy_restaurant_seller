import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failures.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return await _repository.signOut();
  }
}