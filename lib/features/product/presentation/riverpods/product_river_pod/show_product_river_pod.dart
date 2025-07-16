import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/model/product_model.dart';

final productsProvider = FutureProvider.autoDispose<List<ProductModel>>((
    ref) async {
  final supabase = Supabase.instance.client;
  final response = await supabase.from('products').select();

  final products =
  (response as List)
      .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
      .toList();

  return products;
});

