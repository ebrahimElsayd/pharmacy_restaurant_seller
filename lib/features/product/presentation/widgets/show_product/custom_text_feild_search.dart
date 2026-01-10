
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomSearchProduct extends StatelessWidget {
  const CustomSearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Product',
        prefixIcon: Icon(Icons.search),         focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPallete.darkGreyForText),
      ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppPallete.darkGreyForText),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppPallete.darkGreyForText),
        ),
      ),
    );
  }
}