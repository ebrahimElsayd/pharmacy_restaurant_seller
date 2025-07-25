
import '../../domain/entities/order.dart';
import '../../domain/repo/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Order>> getOrders({
    String? status,
    int? limit,
    int? offset,
  }) async {
    final orders = await remoteDataSource.getOrders(
      status: status,
      limit: limit,
      offset: offset,
    );
    return orders.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Order> getOrderDetails(String orderId) async {
    final order = await remoteDataSource.getOrderDetails(orderId);
    return order.toEntity();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    return await remoteDataSource.updateOrderStatus(orderId, status);
  }

  @override
  Future<void> updateOrderNotes(String orderId, String notes) async {
    return await remoteDataSource.updateOrderNotes(orderId, notes);
  }

  @override
  Future<void> updateExpectedDeliveryDate(String orderId, DateTime date) async {
    return await remoteDataSource.updateExpectedDeliveryDate(orderId, date);
  }

  @override
  Stream<List<Order>> listenToOrders() {
    return remoteDataSource
        .listenToOrders()
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Map<String, dynamic>> getOrderStatistics() async {
    return await remoteDataSource.getOrderStatistics();
  }

  @override
  Future<List<Order>> searchOrders(String query) async {
    final orders = await remoteDataSource.searchOrders(query);
    return orders.map((model) => model.toEntity()).toList();
  }
}