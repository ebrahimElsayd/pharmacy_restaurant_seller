import 'package:flutter/material.dart';
import '../../../../core/functions/navigate.dart';
import '../widgets/show_product/show_product_body.dart';
import 'add_product.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key});

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          NavigateFN(context, () => AddProduct());
        },
      ),
      appBar: AppBar(
        title: Text('All Product'),
      ),
      body:  ShowProductBody(),
    );
  }
}
