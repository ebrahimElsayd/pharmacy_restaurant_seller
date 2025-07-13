import 'package:flutter/material.dart';

import '../../../../../core/theme/text_style.dart';

class CustomRowTitle extends StatelessWidget {
  const CustomRowTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$text ", style: TextStyles.textStyle16),
        Icon(Icons.error_outline),
      ],
    );
  }
}