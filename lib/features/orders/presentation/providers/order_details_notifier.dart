
import 'package:pharmacy_restaurant_seller/features/orders/presentation/providers/usecases_providers.dart';
import 'package:riverpod/riverpod.dart';

import 'order_details_state.dart';


// Provider للتفاصيل
final orderDetailsNotifierProvider = StateNotifierProvider.family<OrderDetailsNotifier, OrderDetailsState, String>(
      (ref, orderId) => OrderDetailsNotifier(ref, orderId),
);

class OrderDetailsNotifier extends StateNotifier<OrderDetailsState> {
  final Ref ref;
  final String orderId;

  OrderDetailsNotifier(this.ref, this.orderId) : super( OrderDetailsState.initial()) {
    _loadOrderDetails(orderId);
  }

  Future<void> _loadOrderDetails(String orderId) async {
    state =  OrderDetailsState.loading();

    try {
      final getOrderDetails = ref.read(getOrderDetailsProvider);
      final result = await getOrderDetails(orderId);

      result.fold(
            (failure) => state = OrderDetailsState.error(failure.toString()),
            (order) => state = OrderDetailsState.loaded(order),
      );
    } catch (e) {
      state = OrderDetailsState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await _loadOrderDetails(orderId);
  }
}