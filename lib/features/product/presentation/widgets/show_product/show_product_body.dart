import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/features/product/presentation/widgets/show_product/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../riverpods/product_river_pod/show_product_river_pod.dart';
import 'custom_text_feild_search.dart';

class ShowProductBody extends ConsumerWidget {
  const ShowProductBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return RefreshIndicator(
      onRefresh: ()async {
        ref.invalidate(productsProvider);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchProduct(),
            const SizedBox(height: 20),
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ProductCard(product: product),
                      );
                    },
                  );
                },
                loading: () => Skeletonizer(
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          height: 260,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                error: (error, stack) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
