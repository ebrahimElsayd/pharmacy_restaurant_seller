
import 'package:riverpod/riverpod.dart';

import 'orders_filter_state.dart';

// Provider للفلاتر
final ordersFilterNotifierProvider = StateNotifierProvider<OrdersFilterNotifier, OrdersFilterState>(
      (ref) => OrdersFilterNotifier(),
);

class OrdersFilterNotifier extends StateNotifier<OrdersFilterState> {
  OrdersFilterNotifier() : super(OrdersFilterState.empty());

  // Modified to handle toggling filters
  void setStatus(String? status) {
    // If the same status is selected again, clear it
    if (state.status == status) {
      state = state.copyWith(status: null);
    } else {
      state = state.copyWith(status: status);
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  // Enhanced to ensure complete filter reset
  void clearFilters() {
    state = OrdersFilterState.empty();
  }
}