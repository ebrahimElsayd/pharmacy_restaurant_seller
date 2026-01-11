
import '../../domain/entitise/order_chart_data.dart';

class OrderChartDataModel {
  final List<MonthlySalesDataModel> monthlySales;

  OrderChartDataModel({
    required this.monthlySales,
  });

  factory OrderChartDataModel.fromJson(Map<String, dynamic> json) {
    final monthlySalesList = json['monthly_sales'] as List?;
    final monthlySales = monthlySalesList
        ?.map((item) => MonthlySalesDataModel.fromJson(item as Map<String, dynamic>))
        .toList() ??
        [];

    return OrderChartDataModel(
      monthlySales: monthlySales,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_sales': monthlySales.map((item) => item.toJson()).toList(),
    };
  }

  // ✅ الحل: إضافة وظيفة لتحويل Model إلى Entity
  OrderChartData toEntity() {
    return OrderChartData(
      monthlySales: monthlySales.map((model) => model.toEntity()).toList(),
    );
  }

  // ✅ الحل: إضافة وظيفة لتحويل Entity إلى Model
  factory OrderChartDataModel.fromEntity(OrderChartData entity) {
    return OrderChartDataModel(
      monthlySales: entity.monthlySales.map((item) => MonthlySalesDataModel.fromEntity(item)).toList(),
    );
  }
}

class MonthlySalesDataModel {
  final String month;
  final double value;
  final int index;

  MonthlySalesDataModel({
    required this.month,
    required this.value,
    required this.index,
  });

  factory MonthlySalesDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesDataModel(
      month: json['month'] as String,
      value: (json['value'] as num).toDouble(),
      index: json['index'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'value': value,
      'index': index,
    };
  }

  // ✅ الحل: تحويل Model إلى Entity
  MonthlySalesData toEntity() {
    return MonthlySalesData(
      month: month,
      value: value,
      index: index,
    );
  }

  // ✅ الحل: إنشاء Model من Entity
  factory MonthlySalesDataModel.fromEntity(MonthlySalesData entity) {
    return MonthlySalesDataModel(
      month: entity.month,
      value: entity.value,
      index: entity.index,
    );
  }
}