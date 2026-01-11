
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';

class OrdersEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const OrdersEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onRetry,
  });

  // Inside orders_empty_state.dart

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ValuesManager.paddingLarge),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64.sp,
                color: AppPallete.lightGreyForText.withValues(alpha: 0.3),
              ),
              SizedBox(height: ValuesManager.marginMedium),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s20,
                  color: AppPallete.lightGreyForText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ValuesManager.marginSmall),
              Text(
                message,
                style: TextStyle(
                  color: AppPallete.lightGreyForText,
                  fontSize: FontSize.s16,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: ValuesManager.marginLarge),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: ValuesManager.paddingLarge,
                      vertical: ValuesManager.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ValuesManager.borderRadius),
                    ),
                  ),
                  child: const Text('Reload'), // Translated
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}