
import 'package:fpdart/fpdart.dart';

import '../repo/orders_repository.dart';

class UpdateOrderNotes {
  final OrdersRepository repository;

  UpdateOrderNotes(this.repository);

  Future<Either<Exception, void>> call(String orderId, String notes) async {
    try {
      await repository.updateOrderNotes(orderId, notes);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}