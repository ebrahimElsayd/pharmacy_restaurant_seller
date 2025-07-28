import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../../auth/presentation/riverpods/auth_providers.dart';
import '../riverpods/dashboard_notifier.dart';
import '../widgets/chart_widget.dart';
import '../widgets/quick_actions.dart';
import '../widgets/stats_card.dart';
import '../widgets/top_products.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _refreshDashboard(ref),
        color: AppPallete.primaryColor,
        backgroundColor: AppPallete.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ValuesManager.paddingMedium),
          child: Column(
            children: [
              // Welcome Card
              _buildWelcomeCard(),
              SizedBox(height: ValuesManager.marginLarge),

              // Stats Cards
              DashboardStatsCard(
                stats: dashboardState.stats,
                isLoading: dashboardState.isLoadingStats,
                error: dashboardState.statsError,
                onRetry: () => ref.read(dashboardNotifierProvider.notifier).retryStats(),
              ),
              SizedBox(height: ValuesManager.marginLarge),

              // Chart Widget
              OrdersChartWidget(
                chartData: dashboardState.chartData,
                isLoading: dashboardState.isLoadingChart,
                error: dashboardState.chartError,
                onRetry: () => ref.read(dashboardNotifierProvider.notifier).retryChart(),
              ),
              SizedBox(height: ValuesManager.marginLarge),

              // Top Products
              TopProductsWidget(
                products: dashboardState.topProducts,
                isLoading: dashboardState.isLoadingProducts,
                error: dashboardState.productsError,
                onRetry: () => ref.read(dashboardNotifierProvider.notifier).retryProducts(),
              ),
              SizedBox(height: ValuesManager.marginLarge),

              // Quick Actions
              const QuickActions(),
              SizedBox(height: ValuesManager.marginLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppPallete.primaryGradient,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ValuesManager.paddingSmall),
                decoration: BoxDecoration(
                  color: AppPallete.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: AppPallete.white,
                  size: 24,
                ),
              ),
              SizedBox(width: ValuesManager.marginMedium),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: AppPallete.white,
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: AppPallete.white,
                        fontSize: FontSize.s24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Store',
        style: TextStyle(
          fontSize: FontSize.s20,
          fontWeight: FontWeight.bold,
          color: AppPallete.blackForText,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppPallete.background,
      actions: [
        Container(
          margin: EdgeInsets.only(right: ValuesManager.marginSmall),
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _openNotifications(context),
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: AppPallete.darkGreyForText,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppPallete.redColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: ValuesManager.marginSmall),
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _openSettings(context),
            icon: const Icon(
              Icons.settings,
              color: AppPallete.darkGreyForText,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshDashboard(WidgetRef ref) async {
    await ref.read(dashboardNotifierProvider.notifier).refresh();
  }

  void _openNotifications(BuildContext context) {
    // Open notifications screen
    print('Open notifications');
  }

  void _openSettings(BuildContext context) {
    // Open settings screen
    print('Open settings');
  }
}
