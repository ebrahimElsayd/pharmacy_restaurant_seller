
// حل بدون Freezed
class OrdersFilterState {
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const OrdersFilterState({
    this.status,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  factory OrdersFilterState.empty() => const OrdersFilterState();

  OrdersFilterState copyWith({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return OrdersFilterState(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrdersFilterState &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      startDate,
      endDate,
      searchQuery,
    );
  }

  @override
  String toString() {
    return 'OrdersFilterState(status: $status, startDate: $startDate, endDate: $endDate, searchQuery: $searchQuery)';
  }
}