import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/features/product/data/model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../riverpods/product_river_pod/add_product/add_product_river_pod.dart';
import '../../riverpods/product_river_pod/show_product_river_pod.dart';
import '../add_product/custom_button_push.dart';
import '../add_product/custom_drop_image.dart';
import '../add_product/custom_name_and_des.dart';
import '../add_product/custom_price.dart';

class EditProductBody extends ConsumerStatefulWidget {
  const EditProductBody({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<EditProductBody> createState() => _EditProductBodyState();
}

class _EditProductBodyState extends ConsumerState<EditProductBody> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController disAmount = TextEditingController();
  final _supabase = Supabase.instance.client;

  Future<void> _addProduct() async {
    final state = ref.read(addProductProvider);

    if (state.imageUrl == null) {
      showSnackBar(context, 'The image must be uploaded first.');
      return;
    }

    if (title.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        amount.text.trim().isEmpty ||
        state.category == null) {
      showSnackBar(context, 'All fields are required');
      return;
    }

    ref.read(addProductProvider.notifier).setLoading(true);

    try {
      await _supabase
          .from('products')
          .update({
            "title": title.text.trim(),
            "description": description.text.trim(),
            "image": state.imageUrl,
            "category": state.category,
            "amount": double.tryParse(amount.text.trim()) ?? 0.0,
            "discount_amount": double.tryParse(disAmount.text.trim()) ?? 0.0,
            "status": "Available",
            "views": 0,
            "likes": 0,
            "created_at": DateTime.now().toUtc().toIso8601String(),
            "updated_at": DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', widget.product.id);

      showSnackBar(context, 'Done');
      ref.invalidate(productsProvider);
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context, 'Not Done: $error');
    } finally {
      ref.read(addProductProvider.notifier).setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    title.text = widget.product.title;
    description.text = widget.product.description;
    amount.text = widget.product.amount.toString();
    disAmount.text = widget.product.discountAmount.toString();
    Future.microtask(() {
      ref.read(addProductProvider.notifier).setImageUrl(widget.product.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameAndDes(title: title, description: description),
            const SizedBox(height: 15),

            const SizedBox(height: 15),
            CustomDropImage(
              initialImageUrl: state.imageUrl,
              onImageUploaded: (url) {
                ref.read(addProductProvider.notifier).setImageUrl(url);
              },
            ),
            const SizedBox(height: 15),
            CustomPrice(amount: amount, disAmount: disAmount),
            const SizedBox(height: 15),
            state.isLoading
                ? const CircularProgressIndicator()
                : CustomButtonPubilsh(onTap: _addProduct),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
