import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/font_weight_helper.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? buttonColor;
  final Color? textColor;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.buttonColor,
    this.textColor,
    this.isOutlined = false,
  });

  const CustomButton.outlined({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.buttonColor,
    this.textColor,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isOutlined
            ? Colors.transparent
            : (buttonColor ?? AppPallete.primaryColor);
    final borderColor = buttonColor ?? AppPallete.primaryColor;
    final labelColor =
        textColor ?? (isOutlined ? borderColor : AppPallete.whiteColor);

    return SizedBox(
      width: double.infinity,
      height: AppSize.s50,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                  ),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          height: AppSize.s20,
                          width: AppSize.s20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          text,
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeightHelper.bold,
                            color: labelColor,
                          ),
                        ),
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: labelColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                  ),
                  elevation: 4,
                ),
                child:
                    isLoading
                        ? SizedBox(
                          height: AppSize.s20,
                          width: AppSize.s20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          text,
                          style: TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeightHelper.bold,
                            color: labelColor,
                          ),
                        ),
              ),
    );
  }
}
