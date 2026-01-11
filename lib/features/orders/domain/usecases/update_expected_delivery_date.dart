
import 'package:fpdart/fpdart.dart';

import '../repo/orders_repository.dart';

class UpdateExpectedDeliveryDate {
  final OrdersRepository repository;

  UpdateExpectedDeliveryDate(this.repository);

  Future<Either<Exception, void>> call(String orderId, DateTime date) async {
    try {
      await repository.updateExpectedDeliveryDate(orderId, date);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}