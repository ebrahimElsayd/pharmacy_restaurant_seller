import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entitise/dashboard_stats.dart';
import 'dashboard_empty_state.dart';
import 'dashboard_loading_shimmer.dart';

class DashboardStatsCard extends StatelessWidget {
  final DashboardStats? stats;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const DashboardStatsCard({
    super.key,
    this.stats,
    required this.isLoading,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && stats == null) {
      return const DashboardLoadingShimmer();
    }

    if (error != null) {
      return DashboardEmptyState(
        title: 'Error Occurred',
        message: error!,
        icon: Icons.error_outline,
        onRetry: onRetry,
      );
    }

    if (stats == null) {
      return DashboardEmptyState(
        title: 'No Data Available',
        message: 'Statistics will appear here once orders are received',
        icon: Icons.bar_chart,
        onRetry: onRetry,
      );
    }

    return _StatsContent(stats: stats!);
  }
}

class _StatsContent extends StatelessWidget {
  final DashboardStats stats;

  const _StatsContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuickStatsRow(),
        SizedBox(height: ValuesManager.marginLarge),
        _buildOrdersSummaryCard(),
      ],
    );
  }

  Widget _buildQuickStatsRow() {
    final quickStats = [
      {
        'title': 'Total Sales',
        'value': '${stats.totalSales.toStringAsFixed(0)}',
        'suffix': 'SAR',
        'icon': Icons.trending_up,
        'color': AppPallete.primaryColor,
        'bgColor': AppPallete.primaryLight,
      },
      {
        'title': 'Total Orders',
        'value': '${stats.totalOrders}',
        'suffix': 'orders',
        'icon': Icons.shopping_cart_outlined,
        'color': AppPallete.secondary,
        'bgColor': AppPallete.secondaryLight,
      },
    ];

    return Row(
      children: quickStats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ValuesManager.marginSmall),
            padding: EdgeInsets.all(ValuesManager.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.white,
                  (stat['bgColor'] as Color).withAlpha((0.1 * 255).toInt()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
              border: Border.all(
                color: (stat['color'] as Color).withAlpha((0.2 * 255).toInt()),
              ),
              boxShadow: [
                BoxShadow(
                  color: (stat['color'] as Color).withAlpha((0.1 * 255).toInt()),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(ValuesManager.paddingSmall),
                  decoration: BoxDecoration(
                    color: stat['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: ValuesManager.marginMedium),
                Text(
                  stat['title'] as String,
                  style: const TextStyle(
                    color: AppPallete.lightGreyForText,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ValuesManager.marginSmall),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: stat['value'] as String,
                        style: TextStyle(
                          color: stat['color'] as Color,
                          fontSize: FontSize.s20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' ${stat['suffix']}',
                        style: TextStyle(
                          color: AppPallete.lightGreyForText,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrdersSummaryCard() {
    final totalOrders = stats.totalOrders;
    final pendingPercentage = totalOrders > 0 ? (stats.pendingOrders / totalOrders * 100) : 0.0;
    final processingPercentage = totalOrders > 0 ? (stats.processingOrders / totalOrders * 100) : 0.0;
    final deliveredPercentage = totalOrders > 0 ? ((totalOrders - stats.pendingOrders - stats.processingOrders) / totalOrders * 100) : 0.0;

    final ordersSummary = [
      {
        'title': 'Pending Orders',
        'count': stats.pendingOrders,
        'percentage': pendingPercentage,
        'color': AppPallete.pending,
      },
      {
        'title': 'Processing',
        'count': stats.processingOrders,
        'percentage': processingPercentage,
        'color': AppPallete.processing,
      },
      {
        'title': 'Delivered',
        'count': totalOrders - stats.pendingOrders - stats.processingOrders,
        'percentage': deliveredPercentage,
        'color': AppPallete.delivered,
      },
    ];

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s18,
              color: AppPallete.blackForText,
            ),
          ),
          SizedBox(height: ValuesManager.marginLarge),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 200.h,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 60.r,
                      sections: ordersSummary.map((order) {
                        return PieChartSectionData(
                          value: (order['count'] as int).toDouble(),
                          title: '${(order['percentage'] as double).toInt()}%',
                          color: order['color'] as Color,
                          radius: 40.r,
                          titleStyle: const TextStyle(
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ValuesManager.marginLarge),
              Expanded(
                flex: 3,
                child: Column(
                  children: ordersSummary.map((order) {
                    return Container(
                      margin: EdgeInsets.only(bottom: ValuesManager.marginMedium),
                      padding: EdgeInsets.all(ValuesManager.paddingMedium),
                      decoration: BoxDecoration(
                        color: (order['color'] as Color).withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                        border: Border.all(
                          color: (order['color'] as Color).withAlpha((0.3 * 255).toInt()),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: order['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: ValuesManager.marginSmall),
                          Expanded(
                            child: Text(
                              order['title'] as String,
                              style: TextStyle(
                                fontSize: FontSize.s12,
                                fontWeight: FontWeight.w500,
                                color: AppPallete.darkGreyForText,
                              ),
                            ),
                          ),
                          Text(
                            '${order['count']}',
                            style: TextStyle(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.bold,
                              color: order['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
