
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/data_source/dashboard_remote_data_source.dart';
import '../../data/repository/dashboard_repo_impl.dart';
import '../../domain/repo/dashboard_repo.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_order_chart_data.dart';
import '../../domain/usecases/get_top_products.dart';

// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final supabase = Supabase.instance.client;
  final remoteDataSource = DashboardRemoteDataSourceImpl(supabase);
  return DashboardRepositoryImpl(remoteDataSource);
});

// Use Cases Providers
final getDashboardStatsProvider = Provider<GetDashboardStats>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return GetDashboardStats(repository);
});

final getOrdersChartDataProvider = Provider<GetOrdersChartData>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return GetOrdersChartData(repository);
});

final getTopProductsProvider = Provider<GetTopProducts>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return GetTopProducts(repository);
});