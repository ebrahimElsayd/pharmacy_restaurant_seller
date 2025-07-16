import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/features/product/data/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/theme/app_pallete.dart';
import '../../riverpods/product_river_pod/show_product_river_pod.dart';

Future<void> deleteProductAndImage({
  required int productId,
  required String imageUrl,
}) async {
  final supabase = Supabase.instance.client;

  try {
    final imageName = imageUrl.split('/').last;
    final fullPath = 'products/$imageName';
    await supabase.from('products').delete().eq('id', productId);
    final result = await supabase.storage
        .from('product-images')
        .remove([fullPath]);

    print(' Done: $result');
  } catch (e) {
    print('Not Done: $e');
  }
}

class ProductOptions extends ConsumerWidget {
  const ProductOptions({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit, size: 20),
            title: Text('Edit product'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'view',
          enabled: false,
          child: ListTile(
            leading: const Icon(
              Icons.remove_red_eye,
              size: 20,
              color: Colors.grey,
            ),
            title: Text(
              'View comment',
              style: TextStyle(color: AppPallete.lightGrey),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            onTap: () async {
              Navigator.pop(context);
              await deleteProductAndImage(
                productId: product.id,
                imageUrl: product.image,
              );
              ref.invalidate(productsProvider);
            },
            leading: Icon(Icons.delete, size: 20, color: AppPallete.red),
            title: Text(
              'Delete forever',
              style: TextStyle(color: AppPallete.red),
            ),
          ),
        ),
      ],
    );
  }
}

