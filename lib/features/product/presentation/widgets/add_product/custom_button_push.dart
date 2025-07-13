import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';

import '../../../../../core/theme/text_style.dart';

class CustomButtonPubilsh extends StatelessWidget {
  const CustomButtonPubilsh({super.key, this.onTap});
final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppPallete.lightBlack,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
            "Publish now",
            style: TextStyles.textStyle16bold.copyWith(color: AppPallete.white),
        ),
      ),
    );
  }
}