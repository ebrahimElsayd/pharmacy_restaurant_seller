import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/features/product/data/model/product_model.dart';
import 'package:pharmacy_restaurant_seller/features/product/presentation/widgets/edit_product/edit_product_body.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({super.key, required this.product});
final ProductModel product ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: EditProductBody(product: product,),
    );
  }
}
