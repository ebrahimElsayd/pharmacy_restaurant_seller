

import 'package:fpdart/fpdart.dart' hide Order;

import '../entities/order.dart';
import '../repo/orders_repository.dart';

class SearchOrders {
  final OrdersRepository repository;

  SearchOrders(this.repository);

  Future<Either<Exception, List<Order>>> call(String query) async {
    try {
      final orders = await repository.searchOrders(query);
      return Right(orders);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}