
import 'package:equatable/equatable.dart';
import 'order_item.dart';

class Order extends Equatable {
  final String? id;
  final String sellerId;
  final String customerName;
  final String? customerPhone;
  final String? shippingAddress;
  final double orderTotal;
  final String status;
  final String paymentStatus;
  final String? notes;
  final DateTime? expectedDeliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  const Order({
    this.id,
    required this.sellerId,
    required this.customerName,
    this.customerPhone,
    this.shippingAddress,
    required this.orderTotal,
    required this.status,
    required this.paymentStatus,
    this.notes,
    this.expectedDeliveryDate,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  Order copyWith({
    String? id,
    String? sellerId,
    String? customerName,
    String? customerPhone,
    String? shippingAddress,
    double? orderTotal,
    String? status,
    String? paymentStatus,
    String? notes,
    DateTime? expectedDeliveryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      orderTotal: orderTotal ?? this.orderTotal,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sellerId,
    customerName,
    customerPhone,
    shippingAddress,
    orderTotal,
    status,
    paymentStatus,
    notes,
    expectedDeliveryDate,
    createdAt,
    updatedAt,
    items,
  ];
}