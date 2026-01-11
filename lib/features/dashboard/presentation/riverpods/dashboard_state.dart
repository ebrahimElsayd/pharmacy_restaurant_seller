import 'package:equatable/equatable.dart';

import '../../domain/entitise/dashboard_stats.dart';
import '../../domain/entitise/order_chart_data.dart';
import '../../domain/entitise/top_product.dart';

class DashboardState extends Equatable {
  final bool isLoadingStats;
  final bool isLoadingChart;
  final bool isLoadingProducts;
  final DashboardStats? stats;
  final OrderChartData? chartData;
  final List<TopProduct>? topProducts;
  final String? statsError;
  final String? chartError;
  final String? productsError;

  const DashboardState({
    this.isLoadingStats = false,
    this.isLoadingChart = false,
    this.isLoadingProducts = false,
    this.stats,
    this.chartData,
    this.topProducts,
    this.statsError,
    this.chartError,
    this.productsError,
  });

  factory DashboardState.initial() {
    return const DashboardState();
  }

  factory DashboardState.loading() {
    return const DashboardState(
      isLoadingStats: true,
      isLoadingChart: true,
      isLoadingProducts: true,
    );
  }

  factory DashboardState.loaded({
    DashboardStats? stats,
    OrderChartData? chartData,
    List<TopProduct>? topProducts,
  }) {
    return DashboardState(
      stats: stats,
      chartData: chartData,
      topProducts: topProducts ?? const [],
      isLoadingStats: false,
      isLoadingChart: false,
      isLoadingProducts: false,
    );
  }

  factory DashboardState.error(String message) {
    return DashboardState(
      statsError: message,
      chartError: message,
      productsError: message,
    );
  }

  // ✅ الطريقة الصحيحة لـ copyWith مع nullable parameters
  DashboardState copyWith({
    bool? isLoadingStats,
    bool? isLoadingChart,
    bool? isLoadingProducts,
    DashboardStats? Function()? stats, // ✅ استخدام Function للتعامل مع null
    OrderChartData? Function()? chartData, // ✅ استخدام Function للتعامل مع null
    List<TopProduct>? Function()? topProducts, // ✅ استخدام Function للتعامل مع null
    String? Function()? statsError, // ✅ استخدام Function للتعامل مع null
    String? Function()? chartError, // ✅ استخدام Function للتعامل مع null
    String? Function()? productsError, // ✅ استخدام Function للتعامل مع null
  }) {
    return DashboardState(
      isLoadingStats: isLoadingStats ?? this.isLoadingStats,
      isLoadingChart: isLoadingChart ?? this.isLoadingChart,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      stats: stats != null ? stats() : this.stats,
      chartData: chartData != null ? chartData() : this.chartData,
      topProducts: topProducts != null ? topProducts() : this.topProducts,
      statsError: statsError != null ? statsError() : this.statsError,
      chartError: chartError != null ? chartError() : this.chartError,
      productsError: productsError != null ? productsError() : this.productsError,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingStats,
    isLoadingChart,
    isLoadingProducts,
    stats,
    chartData,
    topProducts,
    statsError,
    chartError,
    productsError,
  ];
}