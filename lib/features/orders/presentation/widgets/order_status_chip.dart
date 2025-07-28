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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: ValuesManager.marginSmall),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (AppPallete.pending, Icons.access_time);
      case 'processing':
        return (AppPallete.processing, Icons.build);
      case 'shipped':
        return (AppPallete.shipped, Icons.local_shipping);
      case 'delivered':
        return (AppPallete.delivered, Icons.check_circle);
      case 'cancelled':
        return (AppPallete.redColor, Icons.cancel);
      case 'returned':
        return (AppPallete.orangeColor, Icons.replay);
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
