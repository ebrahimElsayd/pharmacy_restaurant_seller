import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({super.key, required this.paddingVertical, this.hint, this.icon, this.inputNumber, required this.controller});
final TextEditingController controller;
  final double paddingVertical;
  final String? hint;
final bool? icon;
final bool? inputNumber;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
keyboardType: inputNumber!= null?TextInputType.phone:TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(CupertinoIcons.money_dollar) : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: paddingVertical,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: hint ?? "",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppPallete.lightGrey),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPallete.lightGrey),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPallete.lightGrey),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}