import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/features/product/presentation/widgets/edit_product/edit_product_body.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: EditProductBody(),
    );
  }
}
