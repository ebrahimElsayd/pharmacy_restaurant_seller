import 'package:flutter/material.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/features/product/presentation/widgets/add_product/custom_row_title.dart';

class CustomCategoryDropdown extends StatefulWidget {
  const CustomCategoryDropdown({super.key});

  @override
  State<CustomCategoryDropdown> createState() => _CustomCategoryDropdownState();
}

class _CustomCategoryDropdownState extends State<CustomCategoryDropdown> {
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Furniture',
  ];

  String selectedCategory = 'Electronics';

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(color: AppPallete.blackForText, fontSize: 16),
              items:
                  categories.map((String item) {
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
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
        ),

      ],
    );
  }
}
