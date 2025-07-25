// lib/feature/orders/presentation/providers/usecases_providers.dart

import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/orders_remote_data_source.dart';
import '../../data/repo/orders_repository_impl.dart';
import '../../domain/repo/orders_repository.dart';
import '../../domain/usecases/get_order_details.dart';
import '../../domain/usecases/get_order_statistics.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/search_orders.dart';
import '../../domain/usecases/update_expected_delivery_date.dart';
import '../../domain/usecases/update_order_notes.dart';
import '../../domain/usecases/update_order_status.dart';

// Repository Provider
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final supabase = Supabase.instance.client;
  final remoteDataSource = OrdersRemoteDataSourceImpl(supabase);
  return OrdersRepositoryImpl(remoteDataSource);
});

// Use Cases Providers
final getOrdersProvider = Provider<GetOrders>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetOrders(repository);
});

final getOrderDetailsProvider = Provider<GetOrderDetails>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetOrderDetails(repository);
});

final updateOrderStatusProvider = Provider<UpdateOrderStatus>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return UpdateOrderStatus(repository);
});

final updateOrderNotesProvider = Provider<UpdateOrderNotes>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return UpdateOrderNotes(repository);
});

final updateExpectedDeliveryDateProvider = Provider<UpdateExpectedDeliveryDate>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return UpdateExpectedDeliveryDate(repository);
});

final searchOrdersProvider = Provider<SearchOrders>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return SearchOrders(repository);
});

final getOrderStatisticsProvider = Provider<GetOrderStatistics>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetOrderStatistics(repository);
});