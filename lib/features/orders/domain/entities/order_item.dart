import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String? id;
  final String orderId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double totalPrice;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    productName,
    productPrice,
    quantity,
    totalPrice,
  ];
}