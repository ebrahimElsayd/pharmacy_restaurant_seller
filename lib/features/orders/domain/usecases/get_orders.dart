
import 'package:fpdart/fpdart.dart' hide Order;
import '../entities/order.dart';
import '../repo/orders_repository.dart';

class GetOrders {
  final OrdersRepository repository;

  GetOrders(this.repository);

  Future<Either<Exception, List<Order>>> call({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final orders = await repository.getOrders(
        status: status,
        limit: limit,
        offset: offset,
      );
      return Right(orders);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}