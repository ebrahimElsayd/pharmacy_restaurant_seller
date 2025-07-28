import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
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

    final currentIndex = statusOrder.indexOf(currentStatus.toLowerCase());
    final (currentIcon, currentColor, currentLabel) = _getStatusInfo(currentStatus);

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primaryColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact header with current status
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: currentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  currentIcon,
                  color: currentColor,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: ValuesManager.marginSmall),
              Text(
                'Status: $currentLabel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s16,
                  color: AppPallete.blackForText,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: currentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: currentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentIcon,
                      size: 14.sp,
                      color: currentColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      currentLabel,
                      style: TextStyle(
                        color: currentColor,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ValuesManager.paddingMedium),
          // Compact timeline
          Container(
            padding: EdgeInsets.all(ValuesManager.paddingSmall),
            decoration: BoxDecoration(
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                ...statusOrder.asMap().entries.map((entry) {
                  final index = entry.key;
                  final status = entry.value;
                  final isActive = index <= currentIndex;
                  final isCurrent = index == currentIndex;
                  final isLast = index == statusOrder.length - 1;

                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _CompactTimelineItem(
                            status: status,
                            isActive: isActive,
                            isCurrent: isCurrent,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 20.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? _getStatusColor(status)
                                  : AppPallete.borderColor,
                              borderRadius: BorderRadius.circular(1.r),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppPallete.pending;
      case 'processing':
        return AppPallete.processing;
      case 'shipped':
        return AppPallete.shipped;
      case 'delivered':
        return AppPallete.delivered;
      default:
        return AppPallete.lightGreyForText;
    }
  }

  (IconData, Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (Icons.access_time_rounded, AppPallete.pending, 'Pending');
      case 'processing':
        return (Icons.build_rounded, AppPallete.processing, 'Processing');
      case 'shipped':
        return (Icons.local_shipping_rounded, AppPallete.shipped, 'Shipped');
      case 'delivered':
        return (Icons.check_circle_rounded, AppPallete.delivered, 'Delivered');
      case 'cancelled':
        return (Icons.cancel_rounded, AppPallete.redColor, 'Cancelled');
      default:
        return (Icons.help_outline_rounded, AppPallete.lightGreyForText, 'Unknown');
    }
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

    return Container(
      padding: EdgeInsets.all(ValuesManager.paddingMedium),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withOpacity(0.1)
            : isActive
            ? AppPallete.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: isCurrent
            ? Border.all(color: color.withOpacity(0.3), width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              color: isActive ? null : AppPallete.borderColor,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: isActive ? AppPallete.white : AppPallete.lightGreyForText,
            ),
          ),
          SizedBox(width: ValuesManager.marginMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    color: isCurrent
                        ? color
                        : isActive
                        ? AppPallete.blackForText
                        : AppPallete.lightGreyForText,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                if (isCurrent) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'Current Status',
                    style: TextStyle(
                      fontSize: FontSize.s12,
                      color: color.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isActive)
            Icon(
              Icons.check_circle_rounded,
              color: color,
              size: 20.sp,
            ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (Icons.access_time_rounded, AppPallete.pending, 'Pending');
      case 'processing':
        return (Icons.build_rounded, AppPallete.processing, 'Processing');
      case 'shipped':
        return (Icons.local_shipping_rounded, AppPallete.shipped, 'Shipped');
      case 'delivered':
        return (Icons.check_circle_rounded, AppPallete.delivered, 'Delivered');
      case 'cancelled':
        return (Icons.cancel_rounded, AppPallete.redColor, 'Cancelled');
      default:
        return (Icons.help_outline_rounded, AppPallete.lightGreyForText, 'Unknown');
    }
  }
}

class _CompactTimelineItem extends StatelessWidget {
  final String status;
  final bool isActive;
  final bool isCurrent;

  const _CompactTimelineItem({
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
            gradient: isActive
                ? LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isActive ? null : AppPallete.borderColor,
            shape: BoxShape.circle,
            boxShadow: isActive && isCurrent
                ? [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: isActive ? AppPallete.white : AppPallete.lightGreyForText,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: FontSize.s8,
            color: isCurrent
                ? color
                : isActive
                ? AppPallete.blackForText
                : AppPallete.lightGreyForText,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  (IconData, Color, String) _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (Icons.access_time_rounded, AppPallete.pending, 'Pending');
      case 'processing':
        return (Icons.build_rounded, AppPallete.processing, 'Processing');
      case 'shipped':
        return (Icons.local_shipping_rounded, AppPallete.shipped, 'Shipped');
      case 'delivered':
        return (Icons.check_circle_rounded, AppPallete.delivered, 'Delivered');
      case 'cancelled':
        return (Icons.cancel_rounded, AppPallete.redColor, 'Cancelled');
      default:
        return (Icons.help_outline_rounded, AppPallete.lightGreyForText, 'Unknown');
    }
  }
}