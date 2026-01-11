// lib/feature/dashboard/domain/entities/top_product.dart

import 'package:equatable/equatable.dart';

class TopProduct extends Equatable {
  final String name;
  final int sales;
  final double revenue;
  final int rank;

  const TopProduct({
    required this.name,
    required this.sales,
    required this.revenue,
    required this.rank,
  });

  @override
  List<Object?> get props => [name, sales, revenue, rank];
}