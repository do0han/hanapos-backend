import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends ConsumerStatefulWidget {
  final String storeId;
  const AddProductScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  XFile? _pickedImage;
  bool isLoading = false;

  Future<String?> uploadImageToSupabase(XFile image) async {
    final bytes = await image.readAsBytes();
    final fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    final storage = Supabase.instance.client.storage.from('product-images');
    final res = await storage.uploadBinary(fileName, bytes,
        fileOptions: const FileOptions(upsert: true));
    if (res.isEmpty) return null;
    final url = storage.getPublicUrl(fileName);
    return url;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 80);
                  if (picked != null) setState(() => _pickedImage = picked);
                },
                child: _pickedImage == null
                    ? Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo, size: 48),
                      )
                    : Image.file(
                        File(_pickedImage!.path),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '상품명'),
                validator: (v) => v == null || v.isEmpty ? '상품명은 필수입니다.' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: '가격'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return '가격은 필수입니다.';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return '0 이상의 숫자만 입력하세요.';
                  return null;
                },
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => isLoading = true);
                        String? imageUrl;
                        try {
                          if (_pickedImage != null) {
                            imageUrl =
                                await uploadImageToSupabase(_pickedImage!);
                          }
                          final insertRes = await Supabase.instance.client
                              .from('products')
                              .insert({
                                'name': nameController.text,
                                'price': int.parse(priceController.text),
                                'category': categoryController.text,
                                'store_id': widget.storeId,
                                if (imageUrl != null) 'image_url': imageUrl,
                              })
                              .select()
                              .single();
                          final product = Product.fromJson(insertRes);
                          ref
                              .read(productListProvider.notifier)
                              .addProduct(product);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('상품 추가 성공!')),
                          );
                          _formKey.currentState!.reset();
                          nameController.clear();
                          priceController.clear();
                          categoryController.clear();
                          setState(() => _pickedImage = null);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('상품 추가 실패: \\${e.toString()}')),
                          );
                        } finally {
                          if (mounted) setState(() => isLoading = false);
                        }
                      },
                      child: const Text('상품 추가'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
