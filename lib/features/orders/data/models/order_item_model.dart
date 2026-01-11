
import '../../domain/entities/order_item.dart';

class OrderItemModel {
  final String? id;
  final String orderId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double totalPrice;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String?,
      orderId: json['order_id'] as String,
      productName: json['product_name'] as String,
      productPrice: (json['product_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_name': productName,
      'product_price': productPrice,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      orderId: orderId,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity,
      totalPrice: totalPrice,
    );
  }

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      productName: entity.productName,
      productPrice: entity.productPrice,
      quantity: entity.quantity,
      totalPrice: entity.totalPrice,
    );
  }
}