import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'custom_category_deop_down.dart';

class CustomDropImage extends StatefulWidget {
  final Function(String imageUrl) onImageUploaded;

  const CustomDropImage({super.key, required this.onImageUploaded});

  @override
  State<CustomDropImage> createState() => _CustomDropImageState();
}

class _CustomDropImageState extends State<CustomDropImage> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      final file = File(pickedImage.path);
      setState(() {
        _imageFile = file;
      });

      final fileName = p.basename(file.path);

      try {
        await Supabase.instance.client.storage
            .from('product-images')
            .upload('products/$fileName', file);

        final imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl('products/$fileName');

        widget.onImageUploaded(imageUrl);
      } catch (e) {
        print('err*********************: $e');
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context ,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Images & CTA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Cover images', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: _imageFile == null
                  ? Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file),
                        SizedBox(width: 8),
                        Text("Click or drop image"),
                      ],
                    ),
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _imageFile!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const CustomCategoryDropdown(),
          ],
        ),
      ),
    );
  }
}
