
import 'package:riverpod/riverpod.dart';

import 'orders_filter_state.dart';

// Provider للفلاتر
final ordersFilterNotifierProvider = StateNotifierProvider<OrdersFilterNotifier, OrdersFilterState>(
      (ref) => OrdersFilterNotifier(),
);

class OrdersFilterNotifier extends StateNotifier<OrdersFilterState> {
  OrdersFilterNotifier() : super(OrdersFilterState.empty());

  void setStatus(String? status) {
    state = state.copyWith(status: status);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = OrdersFilterState.empty();
  }
}