
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/erorr/exception.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders({
    String? status,
    int? limit,
    int? offset,
  });

  Future<OrderModel> getOrderDetails(String orderId);

  Future<void> updateOrderStatus(String orderId, String status);

  Future<void> updateOrderNotes(String orderId, String notes);

  Future<void> updateExpectedDeliveryDate(String orderId, DateTime date);

  Stream<List<OrderModel>> listenToOrders();

  Future<Map<String, dynamic>> getOrderStatistics();

  Future<List<OrderModel>> searchOrders(String query);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final SupabaseClient supabase;

  OrdersRemoteDataSourceImpl(this.supabase);


  @override
  Future<List<OrderModel>> getOrders({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      dynamic query = supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('seller_id', user.id);

      if (status != null) {
        query = query.eq('status', status);
      }

      if (limit != null) {
        final start = offset ?? 0;
        final end = start + limit - 1;
        query = query.range(start, end);
      }

      final response = await query;

      return response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }


  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .eq('seller_id', user.id)
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      throw ServerException('Order not found or access denied: ${e.toString()}');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await supabase
          .from('orders')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId)
          .eq('seller_id', user.id);
    } catch (e) {
      throw ServerException('Failed to update order status: ${e.toString()}');
    }
  }

  @override
  Future<void> updateOrderNotes(String orderId, String notes) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await supabase
          .from('orders')
          .update({'notes': notes, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId)
          .eq('seller_id', user.id);
    } catch (e) {
      throw ServerException('Failed to update order notes: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExpectedDeliveryDate(String orderId, DateTime date) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await supabase
          .from('orders')
          .update({
        'expected_delivery_date': date.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      })
          .eq('id', orderId)
          .eq('seller_id', user.id);
    } catch (e) {
      throw ServerException('Failed to update delivery date: ${e.toString()}');
    }
  }

  @override
  Stream<List<OrderModel>> listenToOrders() {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw ServerException('User not authenticated');
    }

    return supabase
        .from('orders:seller_id=eq.${user.id}')
        .stream(primaryKey: const ['id'])
        .map((list) => list.map((json) => OrderModel.fromJson(json)).toList());
  }

  @override
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      // مثال على استعلام إحصائيات بسيطة
      final response = await supabase
          .from('orders')
          .select('status, order_total')
          .eq('seller_id', user.id)
          .gte('created_at', DateTime.now().subtract(const Duration(days: 30)).toIso8601String());

      final orders = response as List;

      double totalSales = 0;
      int totalOrders = orders.length;
      Map<String, int> statusCount = {};

      for (var order in orders) {
        totalSales += (order['order_total'] as num).toDouble();

        final status = order['status'] as String;
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }

      return {
        'total_sales': totalSales,
        'total_orders': totalOrders,
        'status_distribution': statusCount,
        'average_order_value': totalOrders > 0 ? totalSales / totalOrders : 0,
      };
    } catch (e) {
      throw ServerException('Failed to fetch statistics: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderModel>> searchOrders(String query) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('seller_id', user.id)
          .or('customer_name.ilike.%$query%,notes.ilike.%$query%');

      return response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Search failed: ${e.toString()}');
    }
  }
}