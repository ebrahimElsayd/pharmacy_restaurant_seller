
import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';

class OrdersState extends Equatable {
  final List<Order> orders;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = false,
    this.currentPage = 0,
  });

  factory OrdersState.initial() {
    return const OrdersState();
  }

  factory OrdersState.loading() {
    return const OrdersState(isLoading: true);
  }

  factory OrdersState.loaded({
    required List<Order> orders,
    required bool hasMore,
    required int currentPage,
  }) {
    return OrdersState(
      orders: orders,
      hasMore: hasMore,
      currentPage: currentPage,
    );
  }

  factory OrdersState.error(String message) {
    return OrdersState(error: message);
  }

  // Methods لنسخ الحالة مع تغيير قيمة واحدة
  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error, hasMore, currentPage];
}