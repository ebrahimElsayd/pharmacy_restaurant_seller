import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../../domain/entities/order.dart';

class CustomerInfo extends StatelessWidget {
  final Order order;

  const CustomerInfo({
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
            'معلومات العميل',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          ListTile(
            leading: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppPallete.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppPallete.primaryColor,
              ),
            ),
            title: Text(
              order.customerName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: order.customerPhone != null
                ? Text(order.customerPhone!)
                : null,
          ),
          if (order.shippingAddress != null) ...[
            const Divider(height: 24),
            const Text(
              'عنوان التوصيل',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s16,
              ),
            ),
            SizedBox(height: ValuesManager.marginSmall),
            Text(
              order.shippingAddress!,
              style: const TextStyle(
                color: AppPallete.lightGreyForText,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}