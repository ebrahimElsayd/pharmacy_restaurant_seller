import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order.dart';

class OrderSummary extends StatelessWidget {
  final Order order;

  const OrderSummary({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        border: Border.all(color: AppPallete.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الطلب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          _SummaryRow(
            label: 'رقم الطلب',
            value: '#${order.id?.substring(0, 8) ?? 'N/A'}',
            isBold: true,
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'تاريخ الطلب',
            value: _formatDate(order.createdAt),
          ),
          _SummaryRow(
            label: 'تاريخ التسليم المتوقع',
            value: order.expectedDeliveryDate != null
                ? _formatDate(order.expectedDeliveryDate!)
                : 'غير محدد',
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'عدد المنتجات',
            value: '${order.items.length}',
          ),
          _SummaryRow(
            label: 'كمية المنتجات',
            value: '${order.items.fold(0, (sum, item) => sum + item.quantity)}',
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'إجمالي الطلب',
            value: '${order.orderTotal.toStringAsFixed(2)} ر.س',
            isBold: true,
            valueColor: AppPallete.primaryColor,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ValuesManager.paddingSmall / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppPallete.lightGreyForText,
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
              color: valueColor ?? AppPallete.blackForText,
            ),
          ),
        ],
      ),
    );
  }
}