import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import 'custom_button_push.dart';
import 'custom_drop_image.dart';
import 'custom_name_and_des.dart';
import 'custom_price.dart';

class AddProductBody extends StatefulWidget {
  const AddProductBody({super.key});

  @override
  State<AddProductBody> createState() => _AddProductBodyState();
}

class _AddProductBodyState extends State<AddProductBody> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController disAmount = TextEditingController();
  final _supabase = Supabase.instance.client;

  String? imageUrl;
  bool isLoading = false;

  Future<void> _addProduct() async {
    if (imageUrl == null) {
      showSnackBar(context, 'The image must be uploaded first.');
      return;
    }

    if (title.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        amount.text.trim().isEmpty) {
      showSnackBar(context, 'All fields are required');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _supabase.from('product').insert({
        "title": title.text.trim(),
        "description": description.text.trim(),
        "price": int.tryParse(amount.text.trim()) ?? 0,
        "dis_price": int.tryParse(disAmount.text.trim()) ?? 0,
        "image": imageUrl,
      });

      showSnackBar(context, 'Done');
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context, 'Not Done: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomNameAndDes(title: title, description: description),
            const SizedBox(height: 15),
            CustomDropImage(
              onImageUploaded: (url) {
                setState(() {
                  imageUrl = url;
                });
              },
            ),
            const SizedBox(height: 15),
            CustomPrice(amount: amount, disAmount: disAmount),
            const SizedBox(height: 15),
            isLoading
                ? const CircularProgressIndicator()
                : CustomButtonPubilsh(onTap: _addProduct),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
