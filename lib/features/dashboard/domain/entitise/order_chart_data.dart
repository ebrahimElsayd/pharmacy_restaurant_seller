
import 'package:equatable/equatable.dart';

class OrderChartData extends Equatable {
  final List<MonthlySalesData> monthlySales;

  const OrderChartData({
    required this.monthlySales,
  });

  @override
  List<Object?> get props => [monthlySales];
}

class MonthlySalesData extends Equatable {
  final String month;
  final double value;
  final int index;

  const MonthlySalesData({
    required this.month,
    required this.value,
    required this.index,
  });

  @override
  List<Object?> get props => [month, value, index];
}