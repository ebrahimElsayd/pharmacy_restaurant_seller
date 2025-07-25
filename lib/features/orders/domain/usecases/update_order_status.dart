
import 'package:fpdart/fpdart.dart';

import '../repo/orders_repository.dart';

class UpdateOrderStatus {
  final OrdersRepository repository;

  UpdateOrderStatus(this.repository);

  Future<Either<Exception, void>> call(String orderId, String status) async {
    try {
      await repository.updateOrderStatus(orderId, status);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}