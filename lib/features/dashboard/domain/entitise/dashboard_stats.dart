
import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
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

  const DashboardStats({
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

  @override
  List<Object?> get props => [
    totalSales,
    totalOrders,
    statusDistribution,
    averageOrderValue,
    pendingOrders,
    processingOrders,
    shippedOrders,
    deliveredOrders,
    cancelledOrders,
    returnedOrders,
  ];
}