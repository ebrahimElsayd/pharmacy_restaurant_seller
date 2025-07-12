import 'package:flutter/material.dart';

import '../widgets/add_product_body.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: AddProductBody(),
    );
  }
}
