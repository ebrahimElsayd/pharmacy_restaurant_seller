import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
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
      padding: EdgeInsets.all(ValuesManager.paddingLarge),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppPallete.blueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppPallete.blueColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: ValuesManager.marginMedium),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s18,
                  color: AppPallete.blackForText,
                ),
              ),
            ],
          ),
          SizedBox(height: ValuesManager.paddingLarge),
          Container(
            padding: EdgeInsets.all(ValuesManager.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.primaryColor.withOpacity(0.05),
                  AppPallete.primaryColor.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppPallete.primaryColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Order ID',
                  value: '#${order.id?.substring(0, 8) ?? 'N/A'}',
                  isBold: true,
                  icon: Icons.tag_rounded,
                  iconColor: AppPallete.primaryColor,
                ),
                _buildDivider(),
                _SummaryRow(
                  label: 'Order Date',
                  value: _formatDate(order.createdAt),
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppPallete.blueColor,
                ),
                _SummaryRow(
                  label: 'Expected Delivery',
                  value: order.expectedDeliveryDate != null
                      ? _formatDate(order.expectedDeliveryDate!)
                      : 'Not set',
                  icon: Icons.local_shipping_rounded,
                  iconColor: AppPallete.orangeColor,
                ),
                _buildDivider(),
                _SummaryRow(
                  label: 'Total Items',
                  value: '${order.items.length}',
                  icon: Icons.inventory_2_rounded,
                  iconColor: AppPallete.greenColor,
                ),
                _SummaryRow(
                  label: 'Total Quantity',
                  value: '${order.items.fold(0, (sum, item) => sum + item.quantity)}',
                  icon: Icons.shopping_cart_rounded,
                  iconColor: AppPallete.processing,
                ),
                _buildDivider(),
                Container(
                  padding: EdgeInsets.all(ValuesManager.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: _SummaryRow(
                    label: 'Order Total',
                    value: '\$${order.orderTotal.toStringAsFixed(2)}',
                    isBold: true,
                    valueColor: AppPallete.primaryColor,
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppPallete.primaryColor,
                    fontSize: FontSize.s16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ValuesManager.paddingSmall),
      height: 1.h,
      color: AppPallete.borderColor.withOpacity(0.5),
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
  final IconData? icon;
  final Color? iconColor;
  final double? fontSize;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
    this.icon,
    this.iconColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ValuesManager.paddingSmall),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16.sp,
              color: iconColor ?? AppPallete.lightGreyForText,
            ),
            SizedBox(width: ValuesManager.marginSmall),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppPallete.lightGreyForText,
                fontSize: fontSize ?? FontSize.s14,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: fontSize ?? FontSize.s14,
              color: valueColor ?? AppPallete.blackForText,
            ),
          ),
        ],
      ),
    );
  }
}