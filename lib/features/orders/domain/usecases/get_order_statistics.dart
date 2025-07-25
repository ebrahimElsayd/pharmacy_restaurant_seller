
import 'package:fpdart/fpdart.dart';
import '../repo/orders_repository.dart';

class GetOrderStatistics {
  final OrdersRepository repository;

  GetOrderStatistics(this.repository);

  Future<Either<Exception, Map<String, dynamic>>> call() async {
    try {
      final stats = await repository.getOrderStatistics();
      return Right(stats);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}