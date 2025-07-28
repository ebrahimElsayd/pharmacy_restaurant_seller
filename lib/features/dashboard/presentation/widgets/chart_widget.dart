import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entitise/order_chart_data.dart';
import 'dashboard_empty_state.dart';
import 'dashboard_loading_shimmer.dart';

class OrdersChartWidget extends StatefulWidget {
  final OrderChartData? chartData;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const OrdersChartWidget({
    super.key,
    this.chartData,
    required this.isLoading,
    this.error,
    this.onRetry,
  });

  @override
  State<OrdersChartWidget> createState() => _OrdersChartWidgetState();
}

class _OrdersChartWidgetState extends State<OrdersChartWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.chartData == null) {
      return const DashboardLoadingShimmer();
    }

    if (widget.error != null) {
      return DashboardEmptyState(
        title: 'An error occurred',
        message: widget.error!,
        icon: Icons.error_outline,
        onRetry: widget.onRetry,
      );
    }

    if (widget.chartData == null || widget.chartData!.monthlySales.isEmpty) {
      return DashboardEmptyState(
        title: 'No data',
        message: 'The chart will appear here once orders are received',
        icon: Icons.show_chart,
        onRetry: widget.onRetry,
      );
    }

    return _ChartContent(
      chartData: widget.chartData!,
      selectedIndex: selectedIndex,
      onTouchCallback: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}

class _ChartContent extends StatelessWidget {
  final OrderChartData chartData;
  final int selectedIndex;
  final Function(int) onTouchCallback;

  const _ChartContent({
    required this.chartData,
    required this.selectedIndex,
    required this.onTouchCallback,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = chartData.monthlySales
        .map((item) => item.value)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Sales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s18,
                  color: AppPallete.blackForText,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ValuesManager.paddingMedium,
                  vertical: ValuesManager.paddingSmall,
                ),
                decoration: BoxDecoration(
                  gradient: AppPallete.primaryGradient,
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                ),
                child: Text(
                  'Last 6 Months',
                  style: const TextStyle(
                    color: AppPallete.white,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (selectedIndex >= 0 && selectedIndex < chartData.monthlySales.length) ...[
            SizedBox(height: ValuesManager.marginMedium),
            Container(
              padding: EdgeInsets.all(ValuesManager.paddingMedium),
              decoration: BoxDecoration(
                color: AppPallete.primaryLight,
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                border: Border.all(
                  color: AppPallete.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppPallete.primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: ValuesManager.marginSmall),
                  Text(
                    '${chartData.monthlySales[selectedIndex].month}: ',
                    style: const TextStyle(
                      color: AppPallete.primaryDark,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${chartData.monthlySales[selectedIndex].value.toStringAsFixed(0)} SAR',
                    style: const TextStyle(
                      color: AppPallete.primaryColor,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: ValuesManager.marginLarge),
          SizedBox(
            height: 240.h,
            child: LineChart(
              _buildChartData(chartData, maxValue),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(OrderChartData data, double maxValue) {
    // Handle the case when maxValue is 0 or very small
    final safeMaxValue = maxValue > 0 ? maxValue : 1000.0; // Default minimum value
    final horizontalInterval = safeMaxValue / 5;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: horizontalInterval,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppPallete.borderColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35.h,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: AppPallete.lightGreyForText,
                fontSize: FontSize.s12,
                fontWeight: FontWeight.w500,
              );
              final index = value.toInt();
              if (index >= 0 && index < data.monthlySales.length) {
                return Padding(
                  padding: EdgeInsets.only(top: ValuesManager.paddingSmall),
                  child: Text(data.monthlySales[index].month, style: style),
                );
              }
              return const Text('', style: style);
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45.w,
            interval: horizontalInterval,
            getTitlesWidget: (value, meta) {
              if (value == 0) {
                return const Text(
                  '0',
                  style: TextStyle(
                    color: AppPallete.lightGreyForText,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return Text(
                '${(value / 1000).toInt()}K',
                style: const TextStyle(
                  color: AppPallete.lightGreyForText,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: AppPallete.borderColor,
          width: 1,
        ),
      ),
      minX: 0,
      maxX: (data.monthlySales.length - 1).toDouble(),
      minY: 0,
      maxY: safeMaxValue * 1.2,
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (touchResponse != null && touchResponse.lineBarSpots != null) {
            final spot = touchResponse.lineBarSpots!.first;
            onTouchCallback(spot.x.toInt());
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: EdgeInsets.all(ValuesManager.paddingSmall),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.x.toInt();
              if (index >= 0 && index < data.monthlySales.length) {
                return LineTooltipItem(
                  '${data.monthlySales[index].month}\n${barSpot.y.toStringAsFixed(0)} SAR',
                  const TextStyle(
                    color: AppPallete.white,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: AppPallete.primaryColor,
                strokeWidth: 2,
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: AppPallete.white,
                    strokeWidth: 3,
                    strokeColor: AppPallete.primaryColor,
                  );
                },
              ),
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.monthlySales.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return FlSpot(index.toDouble(), item.value);
          }).toList(),
          isCurved: true,
          curveSmoothness: 0.35,
          gradient: AppPallete.primaryGradient,
          barWidth: 4.w,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isSelected = index == selectedIndex;
              return FlDotCirclePainter(
                radius: isSelected ? 8 : 5,
                color: AppPallete.white,
                strokeWidth: isSelected ? 4 : 2,
                strokeColor: AppPallete.primaryColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppPallete.primaryColor.withValues(alpha: 0.3),
                AppPallete.primaryColor.withValues(alpha: 0.1),
                AppPallete.primaryColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}