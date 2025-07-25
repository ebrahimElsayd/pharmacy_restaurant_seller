
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order_item.dart';

class ProductsList extends StatelessWidget {
  final List<OrderItem> items;

  const ProductsList({
    super.key,
    required this.items,
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
            'المنتجات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(height: ValuesManager.marginMedium),
            itemBuilder: (context, index) {
              final item = items[index];
              return _ProductItem(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final OrderItem item;

  const _ProductItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
                fontSize: FontSize.s16,
              ),
            ),
          ),
        ),
        SizedBox(width: ValuesManager.marginMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ValuesManager.marginSmall / 2),
              Text(
                '${item.productPrice.toStringAsFixed(2)} ر.س × ${item.quantity}',
                style: const TextStyle(
                  color: AppPallete.lightGreyForText,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${item.totalPrice.toStringAsFixed(2)} ر.س',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}