import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decoration(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppPallete.greyColor),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppPallete.greyColor,
            ),
            onPressed: onToggleVisibility,
          ),
          filled: true,
          fillColor: AppPallete.whiteColor,
          contentPadding: EdgeInsets.all(AppPadding.p16),
          border: _defaultBorder(),
          enabledBorder: _defaultBorder(),
          focusedBorder: _focusedBorder(),
        ),
      ),
    );
  }

  BoxDecoration _decoration() => BoxDecoration(
    color: AppPallete.whiteColor,
    borderRadius: BorderRadius.circular(AppSize.s12),
    boxShadow: [
      BoxShadow(
        color: AppPallete.greyColor.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 1),
      ),
    ],
  );

  OutlineInputBorder _defaultBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.s12),
    borderSide: BorderSide(color: AppPallete.greyColor, width: AppSize.s1_5),
  );

  OutlineInputBorder _focusedBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.s12),
    borderSide: BorderSide(color: AppPallete.primaryColor, width: AppSize.s2),
  );
}
