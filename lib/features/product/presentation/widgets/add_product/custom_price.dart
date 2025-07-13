import 'package:flutter/material.dart';

import '../../../../../core/theme/app_pallete.dart';
import 'custom_row_title.dart';
import 'custom_text_filed.dart';

class CustomPrice extends StatelessWidget {
   const CustomPrice({super.key, required this.amount, required this.disAmount});
final TextEditingController amount ;
final TextEditingController disAmount ;




@override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price'),
            SizedBox(height: 50),
            CustomRowTitle(text: "Amount"),
            SizedBox(height: 15),

            CustomTextFiled(paddingVertical: 15, icon: true, inputNumber: true, controller: amount,),
            SizedBox(height: 50),
            CustomRowTitle(text: "Discount Amount"),
            SizedBox(height: 15),

            CustomTextFiled(paddingVertical: 15, icon: true, inputNumber: true, controller: disAmount,),
          ],
        ),
      ),
    );
  }
}