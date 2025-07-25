
import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';

class OrderDetailsState extends Equatable {
  final Order? order;
  final bool isLoading;
  final String? error;

  const OrderDetailsState({
    this.order,
    this.isLoading = false,
    this.error,
  });

  // Factory methods لتسهيل الإنشاء
  factory OrderDetailsState.initial() {
    return const OrderDetailsState();
  }

  factory OrderDetailsState.loading() {
    return const OrderDetailsState(isLoading: true);
  }

  factory OrderDetailsState.loaded(Order order) {
    return OrderDetailsState(order: order);
  }

  factory OrderDetailsState.error(String message) {
    return OrderDetailsState(error: message);
  }

  // Method لنسخ الحالة مع تغيير قيمة واحدة
  OrderDetailsState copyWith({
    Order? order,
    bool? isLoading,
    String? error,
  }) {
    return OrderDetailsState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [order, isLoading, error];
}