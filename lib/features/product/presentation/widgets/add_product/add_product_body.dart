import 'package:flutter/material.dart';
import 'custom_drop_image.dart';
import 'custom_name_and_des.dart';


class AddProductBody extends StatelessWidget {
  const AddProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameAndDes(),
            SizedBox(height: 15),
            CustomDropImage(),

          ],
        ),
      ),
    );
  }
}

