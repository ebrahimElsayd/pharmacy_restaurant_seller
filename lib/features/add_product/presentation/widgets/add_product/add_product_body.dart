import 'package:flutter/material.dart';

import '../../../../../core/theme/text_style.dart';
import 'custom_name_and_des.dart';

class AddProductBody extends StatelessWidget {
  const AddProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [CustomNameAndDes()]),
    );
  }
}






