import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';

import '../../../../../core/theme/text_style.dart';
import 'custom_row_title.dart';
import 'custom_text_filed.dart';

class CustomNameAndDes extends StatelessWidget {
  const CustomNameAndDes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name & description", style: TextStyles.textStyle20),
            SizedBox(height: 20),
            CustomRowTitle(text: 'Product title'),
            SizedBox(height: 10),
            CustomTextFiled(paddingVertical: 15, hint: 'Input your text'),
            SizedBox(height: 20),
            CustomRowTitle(text: 'Description'),
            SizedBox(height: 10),
            CustomTextFiled(paddingVertical: 40),
          ],
        ),
      ),
    );
  }
}