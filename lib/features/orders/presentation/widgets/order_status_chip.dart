import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';

class OrderStatusChip extends StatelessWidget {
  final String status;
  final String? displayText;

  const OrderStatusChip({
    super.key,
    required this.status,
    this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStatusInfo(status);
    final text = displayText ?? _getStatusText(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ValuesManager.paddingMedium,
        vertical: ValuesManager.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: ValuesManager.marginSmall / 2),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusInfo(String status) {
    switch (status) {
      case 'pending':
        return (AppPallete.orangeColor, Icons.access_time);
      case 'processing':
        return (AppPallete.blueColor, Icons.build);
      case 'shipped':
        return (AppPallete.primaryColor, Icons.local_shipping);
      case 'delivered':
        return (AppPallete.greenColor, Icons.check_circle);
      case 'cancelled':
        return (AppPallete.redColor, Icons.cancel);
      case 'returned':
        return (AppPallete.greyColor, Icons.replay);
      default:
        return (AppPallete.lightGreyForText, Icons.help);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'returned':
        return 'Returned';
      default:
        return status;
    }
  }
}
