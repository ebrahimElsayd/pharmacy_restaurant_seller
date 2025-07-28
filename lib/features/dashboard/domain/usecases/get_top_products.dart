import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/exception.dart';
import '../../../../core/erorr/failures.dart';
import '../entitise/top_product.dart';
import '../repo/dashboard_repo.dart';

class GetTopProducts {
  final DashboardRepository repository;

  GetTopProducts(this.repository);

  Future<Either<Failure, List<TopProduct>>> call() async {
    try {
      final result = await repository.getTopProducts();
      return result.fold(
        (exception) => Left(_mapExceptionToFailure(exception)),
        (products) => Right(products),
      );
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  Failure _mapExceptionToFailure(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure.custom(exception.message);
    }
    return UnknownFailure.unexpected(exception.toString());
  }
}
