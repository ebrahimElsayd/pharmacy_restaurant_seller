
import 'package:fpdart/fpdart.dart';
import '../entitise/dashboard_stats.dart';
import '../entitise/order_chart_data.dart';
import '../entitise/top_product.dart'; // ✅ التأكد من استخدام Entity

abstract class DashboardRepository {
  Future<Either<Exception, DashboardStats>> getDashboardStats();
  Future<Either<Exception, OrderChartData>> getOrdersChartData();
  Future<Either<Exception, List<TopProduct>>> getTopProducts();
}