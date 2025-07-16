import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/features/product/presentation/widgets/show_product/product_options.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../data/model/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: TextStyles.textStyle16bold),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: TextStyle(color: AppPallete.lightGrey),
                      ),
                    ],
                  ),
                ),
                ProductOptions(product: product,),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '\$${product.amount.toStringAsFixed(2)}',
              style: TextStyles.textStyle18bold.copyWith(
                color: AppPallete.lightBlueForText,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text('Status: '),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppPallete.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.status,
                    style: TextStyles.textStyle14bold.copyWith(
                      color: AppPallete.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Views: ', style: TextStyles.textStyle14bold),
                Text('${product.views}', style: TextStyles.textStyle14bold),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Likes: ', style: TextStyles.textStyle14bold),
                Text('${product.likes}', style: TextStyles.textStyle14bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
