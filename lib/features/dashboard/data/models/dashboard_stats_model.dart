
import '../../domain/entitise/dashboard_stats.dart';

class DashboardStatsModel {
  final double totalSales;
  final int totalOrders;
  final Map<String, int> statusDistribution;
  final double averageOrderValue;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final int returnedOrders;

  DashboardStatsModel({
    required this.totalSales,
    required this.totalOrders,
    required this.statusDistribution,
    required this.averageOrderValue,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.returnedOrders,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final statusDistribution = json['status_distribution'] as Map<String, dynamic>? ?? {};

    return DashboardStatsModel(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['total_orders'] as int? ?? 0,
      statusDistribution: statusDistribution.map((key, value) => MapEntry(key, value as int)),
      averageOrderValue: (json['average_order_value'] as num?)?.toDouble() ?? 0.0,
      pendingOrders: statusDistribution['pending'] as int? ?? 0,
      processingOrders: statusDistribution['processing'] as int? ?? 0,
      shippedOrders: statusDistribution['shipped'] as int? ?? 0,
      deliveredOrders: statusDistribution['delivered'] as int? ?? 0,
      cancelledOrders: statusDistribution['cancelled'] as int? ?? 0,
      returnedOrders: statusDistribution['returned'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_orders': totalOrders,
      'status_distribution': statusDistribution,
      'average_order_value': averageOrderValue,
      'pending_orders': pendingOrders,
      'processing_orders': processingOrders,
      'shipped_orders': shippedOrders,
      'delivered_orders': deliveredOrders,
      'cancelled_orders': cancelledOrders,
      'returned_orders': returnedOrders,
    };
  }

  // ✅ تحويل Model إلى Entity بدون وراثة
  DashboardStats toEntity() {
    return DashboardStats(
      totalSales: totalSales,
      totalOrders: totalOrders,
      statusDistribution: statusDistribution,
      averageOrderValue: averageOrderValue,
      pendingOrders: pendingOrders,
      processingOrders: processingOrders,
      shippedOrders: shippedOrders,
      deliveredOrders: deliveredOrders,
      cancelledOrders: cancelledOrders,
      returnedOrders: returnedOrders,
    );
  }

  // ✅ إنشاء Model من Entity
  factory DashboardStatsModel.fromEntity(DashboardStats entity) {
    return DashboardStatsModel(
      totalSales: entity.totalSales,
      totalOrders: entity.totalOrders,
      statusDistribution: entity.statusDistribution,
      averageOrderValue: entity.averageOrderValue,
      pendingOrders: entity.pendingOrders,
      processingOrders: entity.processingOrders,
      shippedOrders: entity.shippedOrders,
      deliveredOrders: entity.deliveredOrders,
      cancelledOrders: entity.cancelledOrders,
      returnedOrders: entity.returnedOrders,
    );
  }
}