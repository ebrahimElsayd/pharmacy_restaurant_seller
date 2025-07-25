import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
        child: Padding(
          padding: EdgeInsets.all(ValuesManager.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة - معلومات أساسية
              _buildHeader(context),
              SizedBox(height: ValuesManager.paddingSmall),

              // المنتجات
              _buildProductsPreview(),
              SizedBox(height: ValuesManager.paddingSmall),

              // السطر السفلي - الإجمالي والحالة
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${order.id?.substring(0, 8) ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ValuesManager.paddingSmall / 2),
              Text(
                order.customerName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPallete.lightGreyForText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          '${order.orderTotal.toStringAsFixed(2)} ر.س',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppPallete.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsPreview() {
    final items = order.items;
    if (items.isEmpty) {
      return const Text('لا توجد منتجات');
    }

    final visibleItems = items.take(3).toList();
    final remainingCount = items.length - 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visibleItems.length,
            separatorBuilder: (_, __) => SizedBox(width: ValuesManager.marginSmall),
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              return Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppPallete.borderColor,
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                  border: Border.all(color: AppPallete.borderColor),
                ),
                child: Center(
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (remainingCount > 0)
          Padding(
            padding: EdgeInsets.only(top: ValuesManager.paddingSmall),
            child: Text(
              '+$remainingCount منتج إضافي',
              style: const TextStyle(
                color: AppPallete.lightGreyForText,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OrderStatusChip(status: order.status),
        Text(
          _formatDate(order.createdAt),
          style: const TextStyle(
            color: AppPallete.lightGreyForText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}