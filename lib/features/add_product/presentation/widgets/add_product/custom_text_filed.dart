import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({super.key, required this.paddingVertical, this.hint});

  final double paddingVertical;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: paddingVertical,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: hint ?? "",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}