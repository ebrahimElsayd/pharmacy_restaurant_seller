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
                  color: AppPallete.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: AppPallete.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: ValuesManager.marginMedium),
              Text(
                'Customer Information',
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
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppPallete.primaryColor,
                        AppPallete.primaryColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppPallete.white,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: ValuesManager.marginMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s16,
                          color: AppPallete.blackForText,
                        ),
                      ),
                      if (order.customerPhone != null) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 16.sp,
                              color: AppPallete.lightGreyForText,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              order.customerPhone!,
                              style: TextStyle(
                                color: AppPallete.lightGreyForText,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'VIP',
                    style: TextStyle(
                      color: AppPallete.primaryColor,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (order.shippingAddress != null) ...[
            SizedBox(height: ValuesManager.paddingMedium),
            Container(
              padding: EdgeInsets.all(ValuesManager.paddingMedium),
              decoration: BoxDecoration(
                color: AppPallete.background,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppPallete.orangeColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: ValuesManager.marginSmall),
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s16,
                          color: AppPallete.blackForText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ValuesManager.marginSmall),
                  Text(
                    order.shippingAddress!,
                    style: TextStyle(
                      color: AppPallete.lightGreyForText,
                      fontSize: FontSize.s14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}