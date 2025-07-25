
import '../../domain/entities/order.dart';
import 'order_item_model.dart';

class OrderModel {
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
  final List<OrderItemModel> items;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<OrderItemModel> items = itemsList
        ?.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
        .toList() ??
        [];

    return OrderModel(
      id: json['id'] as String?,
      sellerId: json['seller_id'] as String,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String?,
      shippingAddress: json['shipping_address'] as String?,
      orderTotal: (json['order_total'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      notes: json['notes'] as String?,
      expectedDeliveryDate: json['expected_delivery_date'] == null
          ? null
          : DateTime.parse(json['expected_delivery_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'shipping_address': shippingAddress,
      'order_total': orderTotal,
      'status': status,
      'payment_status': paymentStatus,
      'notes': notes,
      'expected_delivery_date': expectedDeliveryDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      sellerId: sellerId,
      customerName: customerName,
      customerPhone: customerPhone,
      shippingAddress: shippingAddress,
      orderTotal: orderTotal,
      status: status,
      paymentStatus: paymentStatus,
      notes: notes,
      expectedDeliveryDate: expectedDeliveryDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      id: entity.id,
      sellerId: entity.sellerId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      shippingAddress: entity.shippingAddress,
      orderTotal: entity.orderTotal,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      notes: entity.notes,
      expectedDeliveryDate: entity.expectedDeliveryDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      items: entity.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
    );
  }
}