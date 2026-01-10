import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'custom_category_deop_down.dart';

class CustomDropImage extends StatefulWidget {
  final Function(String imageUrl) onImageUploaded;
  final String? initialImageUrl;

  const CustomDropImage({
    super.key,
    required this.onImageUploaded,
    this.initialImageUrl,
  });

  @override
  State<CustomDropImage> createState() => _CustomDropImageState();
}

class _CustomDropImageState extends State<CustomDropImage> {
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      final file = File(pickedImage.path);
      setState(() {
        _imageFile = file;
        _imageUrl = null;
      });

      final fileName = p.basename(file.path);

      try {
        await Supabase.instance.client.storage
            .from('product-images')
            .update(
              'products/$fileName',
              file,
              fileOptions: const FileOptions(upsert: true),
            );
        final imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl('products/$fileName');
        widget.onImageUploaded(imageUrl);
      } catch (e) {
        print('رفع الصورة فشل: $e');
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Image Source'),
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

  void _showDeleteImageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Delete'),
                  onTap: () {
                    deleteImage(imageUrl: _imageUrl!);
                    print("Url: $_imageUrl ***********************************");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> deleteImage({required String imageUrl}) async {
    final supabase = Supabase.instance.client;

    try {
      final uri = Uri.parse(imageUrl);
      final imageName = uri.pathSegments.last;
      final fullPath = 'products/$imageName';

      await supabase.storage.from('product-images').remove([fullPath]);

      setState(() {
        _imageFile = null;
        _imageUrl = null;
      });
      widget.onImageUploaded('');
    } catch (e) {
      print('فشل الحذف: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف الصورة')),
      );
    }
  }


  Widget _buildImageWidget() {
    if (_imageFile != null || _imageUrl != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                _imageFile != null
                    ? Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                    : Image.network(
                      _imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _showDeleteImageDialog,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
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
                child: _buildImageWidget(),
              ),

              const SizedBox(height: 20),
              const CustomCategoryDropdown(),
            ],
          ),
        ),
      ),
    );
  }
}
