// import '../../domain/entitise/monthly_sales.dart';
//
// class MonthlySalesModel {
//   final String month;
//   final double value;
//   final int index;
//
//   const MonthlySalesModel({
//     required this.month,
//     required this.value,
//     required this.index,
//   });
//
//   factory MonthlySalesModel.fromMap(Map<String, dynamic> map) {
//     return MonthlySalesModel(
//       month: map['month'] as String,
//       value: (map['value'] as num).toDouble(),
//       index: map['index'] as int,
//     );
//   }
//
//   MonthlySales toEntity() {
//     return MonthlySales(
//       month: month,
//       value: value,
//       index: index,
//     );
//   }
// }