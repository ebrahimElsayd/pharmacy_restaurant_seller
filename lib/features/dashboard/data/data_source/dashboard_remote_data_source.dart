import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/erorr/exception.dart';
import '../models/dashboard_stats_model.dart';
import '../models/order_chart_data_model.dart';
import '../models/top_product_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<OrderChartDataModel> getOrdersChartData();
  Future<List<TopProductModel>> getTopProducts();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabase;

  DashboardRemoteDataSourceImpl(this.supabase);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      // الحصول على إحصائيات لوحة التحكم
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      final ordersResponse = await supabase
          .from('orders')
          .select('status, order_total, created_at')
          .eq('seller_id', user.id)
          .gte('created_at', thirtyDaysAgo.toIso8601String());

      final orders = ordersResponse as List;
      double totalSales = 0;
      int totalOrders = orders.length;
      Map<String, int> statusCount = {};

      for (var order in orders) {
        totalSales += (order['order_total'] as num).toDouble();

        final status = order['status'] as String;
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }

      final avgOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;

      final dashboardStats = DashboardStatsModel(
        totalSales: totalSales,
        totalOrders: totalOrders,
        statusDistribution: statusCount,
        averageOrderValue: avgOrderValue,
        pendingOrders: statusCount['pending'] ?? 0,
        processingOrders: statusCount['processing'] ?? 0,
        shippedOrders: statusCount['shipped'] ?? 0,
        deliveredOrders: statusCount['delivered'] ?? 0,
        cancelledOrders: statusCount['cancelled'] ?? 0,
        returnedOrders: statusCount['returned'] ?? 0,
      );
      return dashboardStats;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<OrderChartDataModel> getOrdersChartData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      // الحصول على بيانات المبيعات الشهرية
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 5, 1); // آخر 6 أشهر

      final response = await supabase
          .from('orders')
          .select('created_at, order_total')
          .eq('seller_id', user.id)
          .gte('created_at', startDate.toIso8601String())
          .order('created_at');

      final orders = response as List;
      // تجميع البيانات حسب الشهر
      final monthlyData = <String, double>{};

      for (var order in orders) {
        final date = DateTime.parse(order['created_at'] as String);
        final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        final amount = (order['order_total'] as num).toDouble();

        monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + amount;
      }

      // ✅ الحل: تحويل البيانات إلى MonthlySalesDataModel بشكل صحيح
      final result = <MonthlySalesDataModel>[];
      for (int i = 5; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        final monthName = _getMonthName(date.month);

        final monthlySalesDataModel = MonthlySalesDataModel(
          month: monthName,
          value: monthlyData[monthKey] ?? 0.0,
          index: 5 - i,
        );

        result.add(monthlySalesDataModel);
      }

      return OrderChartDataModel(
        monthlySales: result,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TopProductModel>> getTopProducts() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }
      // الحصول على المنتجات الأكثر مبيعاً
      final response = await supabase
          .rpc('get_top_products_by_seller', params: {
        'p_seller_id': user.id,
        'p_limit_count': 10,
      });

      final products = response as List;

      if (products.isEmpty) {
        return [];
      }

      final topProductsList = products.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value as Map;

        print('🏷️ [TopProducts] Processing product ${index + 1}:');
        print('   - Name: ${product['product_name']}');
        print('   - Quantity: ${product['total_quantity']}');
        print('   - Revenue: ${product['total_revenue']}');

        return TopProductModel(
          name: product['product_name'] as String,
          sales: product['total_quantity'] as int,
          revenue: (product['total_revenue'] as num).toDouble(),
          rank: index + 1,
        );
      }).toList();

      print('✅ [TopProducts] Successfully created ${topProductsList.length} TopProductModel objects');
      return topProductsList;
    } catch (e) {
      print('❌ [TopProducts] CRITICAL ERROR: $e');
      print('❌ [TopProducts] Error type: ${e.runtimeType}');
      print('❌ [TopProducts] Stack trace: ${StackTrace.current}');
      throw ServerException('TopProducts Error: ${e.toString()}');
    }
  }

  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }
}