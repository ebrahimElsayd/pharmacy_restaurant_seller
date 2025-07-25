
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders({
    String? status,
    int? limit,
    int? offset,
  });

  Future<Order> getOrderDetails(String orderId);

  Future<void> updateOrderStatus(String orderId, String status);

  Future<void> updateOrderNotes(String orderId, String notes);

  Future<void> updateExpectedDeliveryDate(String orderId, DateTime date);

  Stream<List<Order>> listenToOrders();

  Future<Map<String, dynamic>> getOrderStatistics();

  Future<List<Order>> searchOrders(String query);
}