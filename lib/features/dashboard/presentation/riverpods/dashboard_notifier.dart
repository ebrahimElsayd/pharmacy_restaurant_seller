import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../orders/presentation/providers/usecases_providers.dart';
import 'dashboard_providers.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(ref),
);

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref ref;
  static const int _pageSize = 20;

  DashboardNotifier(this.ref) : super(DashboardState.initial()) {
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    state = DashboardState.loading();

    try {
      await Future.wait([
        _loadStats(),
        _loadChartData(),
        _loadTopProducts(),
      ]);
    } catch (e) {
      state = DashboardState.error(e.toString());
    }
  }

  Future<void> _loadStats() async {
    state = state.copyWith(isLoadingStats: true);

    try {
      final getStats = ref.read(getDashboardStatsProvider);
      final result = await getStats();

      result.fold(
            (failure) => state = state.copyWith(
          statsError: () => failure.toString(),
          isLoadingStats: false,
        ),
            (stats) => state = state.copyWith(
          stats: () => stats, // ✅ استخدام Function لتمرير القيمة
          isLoadingStats: false,
          statsError: () => null, // ✅ مسح الخطأ السابق
        ),
      );
    } catch (e) {
      state = state.copyWith(
        statsError: () => e.toString(),
        isLoadingStats: false,
      );
    }
  }

  Future<void> _loadChartData() async {
    state = state.copyWith(isLoadingChart: true);

    try {
      final getChartData = ref.read(getOrdersChartDataProvider);
      final result = await getChartData();

      result.fold(
            (failure) => state = state.copyWith(
          chartError: () => failure.toString(),
          isLoadingChart: false,
        ),
            (chartData) => state = state.copyWith(
          chartData: () => chartData, // ✅ استخدام Function لتمرير القيمة
          isLoadingChart: false,
          chartError: () => null, // ✅ مسح الخطأ السابق
        ),
      );
    } catch (e) {
      state = state.copyWith(
        chartError: () => e.toString(),
        isLoadingChart: false,
      );
    }
  }

  Future<void> _loadTopProducts() async {
    state = state.copyWith(isLoadingProducts: true);

    try {
      final getTopProducts = ref.read(getTopProductsProvider);
      final result = await getTopProducts();

      result.fold(
            (failure) => state = state.copyWith(
          productsError: () => failure.toString(),
          isLoadingProducts: false,
        ),
            (products) => state = state.copyWith(
          topProducts: () => products, // ✅ استخدام Function لتمرير القيمة
          isLoadingProducts: false,
          productsError: () => null, // ✅ مسح الخطأ السابق
        ),
      );
    } catch (e) {
      state = state.copyWith(
        productsError: () => e.toString(),
        isLoadingProducts: false,
      );
    }
  }


  Future<void> refresh() async {
    await _loadDashboard();
  }

  Future<void> filterOrders({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    state = DashboardState.loading();

    try {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchOrdersUseCase = ref.read(searchOrdersProvider);
        final result = await searchOrdersUseCase(searchQuery);

        result.fold(
              (failure) => state = DashboardState.error(failure.toString()),
              (orders) => state = DashboardState.loaded(
            stats: state.stats, // ✅ الحفاظ على البيانات الحالية
            chartData: state.chartData, // ✅ الحفاظ على البيانات الحالية
            topProducts: state.topProducts, // ✅ الحفاظ على البيانات الحالية
          ),
        );
      } else {
        final getOrders = ref.read(getOrdersProvider);
        final result = await getOrders(status: status);

        result.fold(
              (failure) => state = DashboardState.error(failure.toString()),
              (orders) => state = DashboardState.loaded(
            stats: state.stats, // ✅ الحفاظ على البيانات الحالية
            chartData: state.chartData, // ✅ الحفاظ على البيانات الحالية
            topProducts: state.topProducts, // ✅ الحفاظ على البيانات الحالية
          ),
        );
      }
    } catch (e) {
      state = DashboardState.error(e.toString());
    }
  }

  Future<void> retryStats() async {
    await _loadStats();
  }

  Future<void> retryChart() async {
    await _loadChartData();
  }

  Future<void> retryProducts() async {
    await _loadTopProducts();
  }
}