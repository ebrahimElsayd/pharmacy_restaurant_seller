import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import '../../riverpods/product_river_pod/add_product_river_pod.dart';
import 'custom_row_title.dart';

class CustomCategoryDropdown extends ConsumerWidget {
  const CustomCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> categories = [
      'Electronics',
      'Accessories',
      'Computers',
      'Mobiles',
      'Clothing',
      'Home',
      'Other',
    ];

    final state = ref.watch(addProductProvider);
    final selectedCategory = state.category ?? categories[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowTitle(text: 'Category'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppPallete.borderColor),
            borderRadius: BorderRadius.circular(24),
            color: AppPallete.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(
                color: AppPallete.blackForText,
                fontSize: 16,
              ),
              items: categories.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                ref
                    .read(addProductProvider.notifier)
                    .setCategory(value ?? categories[0]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
