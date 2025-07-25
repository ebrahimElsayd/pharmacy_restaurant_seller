import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';

class OrderTimeline extends StatelessWidget {
  final String currentStatus;

  const OrderTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusOrder = [
      'pending',
      'processing',
      'shipped',
      'delivered',
    ];

    final currentIndex = statusOrder.indexOf(currentStatus);

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
            'حالة الطلب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          Row(
            children: statusOrder.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isActive = index <= currentIndex;
              final isCurrent = index == currentIndex;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: isActive ? AppPallete.primaryColor : AppPallete.borderColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ValuesManager.paddingSmall),
                    _TimelineItem(
                      status: status,
                      isActive: isActive,
                      isCurrent: isCurrent,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String status;
  final bool isActive;
  final bool isCurrent;

  const _TimelineItem({
    required this.status,
    required this.isActive,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = _getStatusInfo(status);

    return Column(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: isActive ? color : AppPallete.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? color : AppPallete.borderColor,
              width: 2.w,
            ),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: isActive ? AppPallete.white : AppPallete.lightGreyForText,
          ),
        ),
        SizedBox(height: ValuesManager.marginSmall / 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isCurrent ? AppPallete.primaryColor : AppPallete.lightGreyForText,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  (IconData, Color, String) _getStatusInfo(String status) {
    switch (status) {
      case 'pending':
        return (Icons.access_time, AppPallete.orangeColor, 'قيد الانتظار');
      case 'processing':
        return (Icons.build, AppPallete.blueColor, 'قيد التجهيز');
      case 'shipped':
        return (Icons.local_shipping, AppPallete.primaryColor, 'تم الشحن');
      case 'delivered':
        return (Icons.check_circle, AppPallete.greenColor, 'تم التوصيل');
      default:
        return (Icons.help, AppPallete.lightGreyForText, 'غير معروف');
    }
  }
}