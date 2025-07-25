import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/features/orders/presentation/providers/usecases_providers.dart';
import 'orders_filter_notifier.dart';
import 'orders_state.dart';


final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, OrdersState>(
      (ref) => OrdersNotifier(ref),
);

class OrdersNotifier extends StateNotifier<OrdersState> {
  final Ref ref;
  static const int _pageSize = 20;

  OrdersNotifier(this.ref) : super(OrdersState.initial()) {
    // Initial load respects filters/search
    _loadOrders();
  }

  // Core method to fetch orders respecting current filters/search
  Future<void> _fetchOrders({int offset = 0}) async {
    // If we are loading more, we don't want to show loading indicator and replace existing data
    // Only show loading indicator for initial load/refresh
    if (offset == 0) {
      state = OrdersState.loading(); // Indicate loading for initial load/refresh
    }
    try {
      final filterState = ref.read(ordersFilterNotifierProvider);

      if (filterState.searchQuery != null && filterState.searchQuery!.isNotEmpty) {
        // Handle Search
        final searchOrdersUseCase = ref.read(searchOrdersProvider);
        final result = await searchOrdersUseCase(filterState.searchQuery!);
        result.fold(
              (failure) => state = OrdersState.error(failure.toString()),
              (orders) {
            // Search results usually aren't paginated like this, so reset pagination state
            if (offset == 0) {
              state = OrdersState.loaded(
                orders: orders,
                hasMore: false, // No pagination for search
                currentPage: 0,
              );
            } else {
              // This case shouldn't really happen with search, but just in case
              state = state.copyWith(
                orders: [...state.orders, ...orders],
                hasMore: false,
                currentPage: state.currentPage,
              );
            }
          },
        );
      } else {
        // Handle Filtered or All Orders (Paginated)
        final getOrders = ref.read(getOrdersProvider);
        final result = await getOrders(
          status: filterState.status, // Pass status filter, null for 'All'
          limit: _pageSize,
          offset: offset,
        );
        result.fold(
              (failure) => state = OrdersState.error(failure.toString()),
              (orders) {
            if (offset == 0) {
              // Initial load or refresh
              state = OrdersState.loaded(
                orders: orders,
                hasMore: orders.length == _pageSize,
                currentPage: 0,
              );
            } else {
              // Load more
              if (orders.isNotEmpty) {
                state = state.copyWith(
                  orders: [...state.orders, ...orders],
                  hasMore: orders.length == _pageSize,
                  currentPage: offset ~/ _pageSize, // Calculate page correctly
                  // isLoading and error remain unchanged on successful loadMore
                );
              } else {
                // Handle case where loadMore returns empty (set hasMore to false)
                state = state.copyWith(hasMore: false);
              }
            }
          },
        );
      }
    } catch (e) {
      state = OrdersState.error(e.toString());
    }
  }


  Future<void> _loadOrders() async {
    // Initial load or refresh based on current filters/search
    await _fetchOrders(offset: 0);
  }

  Future<void> loadMore() async {
    // Prevent loading more during search or error/loading states or if no more data
    if (state.isLoading || state.error != null || !state.hasMore) {
      return; // Exit early if conditions aren't met
    }

    // Only proceed with loading more for paginated lists (not search results)
    final filterState = ref.read(ordersFilterNotifierProvider);
    if (filterState.searchQuery != null && filterState.searchQuery!.isNotEmpty) {
      return; // Don't paginate search results in this logic
    }

    // Proceed to load more
    await _fetchOrders(offset: (state.currentPage + 1) * _pageSize);
  }

  Future<void> refresh() async {
    // Refresh should re-fetch based on *current* filters/search
    await _fetchOrders(offset: 0);
  }

  // This method now just triggers a refresh, as filters/search are read from their provider
  Future<void> filterOrders() async {
    // Reset pagination when filters/search change
    await _fetchOrders(offset: 0);
  }

  // Optional: Method to explicitly clear search and refresh if needed by other UI parts
  Future<void> clearSearchAndRefresh() async {
    ref.read(ordersFilterNotifierProvider.notifier).setSearchQuery(null);
    await _fetchOrders(offset: 0);
  }
}
