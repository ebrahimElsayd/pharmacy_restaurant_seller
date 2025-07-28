

import '../../domain/entitise/top_product.dart';

class TopProductModel {
  final String name;
  final int sales;
  final double revenue;
  final int rank;

  TopProductModel({
    required this.name,
    required this.sales,
    required this.revenue,
    required this.rank,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      name: json['name'] as String,
      sales: json['sales'] as int,
      revenue: (json['revenue'] as num).toDouble(),
      rank: json['rank'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sales': sales,
      'revenue': revenue,
      'rank': rank,
    };
  }

  // ✅ تحويل Model إلى Entity بدون وراثة
  TopProduct toEntity() {
    return TopProduct(
      name: name,
      sales: sales,
      revenue: revenue,
      rank: rank,
    );
  }

  // ✅ إنشاء Model من Entity
  factory TopProductModel.fromEntity(TopProduct entity) {
    return TopProductModel(
      name: entity.name,
      sales: entity.sales,
      revenue: entity.revenue,
      rank: entity.rank,
    );
  }
}