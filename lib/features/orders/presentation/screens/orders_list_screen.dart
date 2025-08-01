import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_filter_notifier.dart';
import '../providers/orders_filter_state.dart';
import '../providers/orders_notifier.dart';
import '../providers/orders_state.dart';
import '../widgets/advanced_filters_dialog.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/orders_filters.dart';
import '../widgets/search_bar.dart';
import 'order_details_screen.dart';


class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to filter changes and trigger refresh
    ref.listen<OrdersFilterState>(ordersFilterNotifierProvider, (previous, next) {
      // Trigger refresh in notifier when filters change
      ref.read(ordersNotifierProvider.notifier).filterOrders();
    });

    final ordersState = ref.watch(ordersNotifierProvider);

    return GestureDetector(
      // Unfocus any text field when tapping elsewhere on the screen
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context, ref),
        body: Column(
          children: [
            OrdersSearchBar(onSearch: () {
              // Trigger refresh when search is submitted (handled by notifier now)
              ref.read(ordersNotifierProvider.notifier).filterOrders();
            }),
            const OrdersFilters(), // This handles setting filters via notifier
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refreshOrders(ref), // This will now respect filters
                child: _buildContent(ordersState, ref, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text(
        'Orders', // Translated
        style: TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AdvancedFiltersDialog(),
            );
          },
          icon: const Icon(Icons.filter_list),
        ),
      ],
      backgroundColor: AppPallete.white,
      elevation: 0,
    );
  }

  Widget _buildContent(OrdersState state, WidgetRef ref, BuildContext context) {
    if (state.isLoading && state.orders.isEmpty) { // Show loading only for initial load
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return OrdersEmptyState(
        title: 'An error occurred', // Translated
        message: state.error!,
        icon: Icons.error_outline,
        onRetry: () => _refreshOrders(ref), // Retry respects filters now
      );
    }
    if (state.orders.isEmpty) {
      return OrdersEmptyState(
        title: 'No orders found', // Translated
        message: 'New orders will appear here once received.', // Translated
        icon: Icons.shopping_cart_outlined,
        onRetry: () => _refreshOrders(ref), // Retry respects filters now
      );
    }
    // If there are orders, display the list
    return _OrdersList(
      orders: state.orders,
      hasMore: state.hasMore,
      onLoadMore: () => ref.read(ordersNotifierProvider.notifier).loadMore(),
      onOrderTap: (order) {
        if (order.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: order.id!), // Pass order ID
            ),
          );
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot open order details')), // Translated
            );
          }
        }
      },
    );
  }

  // // Simplified _performSearch - just trigger filter in notifier
  // void _performSearch(WidgetRef ref) {
  //   ref.read(ordersNotifierProvider.notifier).filterOrders();
  // }

  Future<void> _refreshOrders(WidgetRef ref) async {
    // This now correctly refreshes based on current filters/search
    await ref.read(ordersNotifierProvider.notifier).refresh();
  }
}


class _OrdersList extends StatefulWidget {
  final List<Order> orders;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Function(Order) onOrderTap;

  const _OrdersList({
    required this.orders,
    required this.hasMore,
    required this.onLoadMore,
    required this.onOrderTap,
  });

  @override
  State<_OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<_OrdersList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.w) {
      if (widget.hasMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      itemCount: widget.orders.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.orders.length) {
          return Padding(
            padding: EdgeInsets.all(ValuesManager.paddingMedium),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final order = widget.orders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: ValuesManager.marginSmall),
          child: OrderCard(order: order, onTap: () => widget.onOrderTap(order)),
        );
      },
    );
  }
}
