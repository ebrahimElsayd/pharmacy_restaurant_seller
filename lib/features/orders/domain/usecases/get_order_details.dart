

import 'package:fpdart/fpdart.dart' hide Order;

import '../entities/order.dart';
import '../repo/orders_repository.dart';

class GetOrderDetails {
  final OrdersRepository repository;

  GetOrderDetails(this.repository);

  Future<Either<Exception, Order>> call(String orderId) async {
    try {
      final order = await repository.getOrderDetails(orderId);
      return Right(order);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}