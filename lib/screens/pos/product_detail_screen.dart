import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

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
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final categoryController =
        TextEditingController(text: product.category ?? '');
    final imageUrlController =
        TextEditingController(text: product.imageUrl ?? '');
    final formKey = GlobalKey<FormState>();
    XFile? pickedImage;
    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세/수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (picked != null)
                            setState(() => pickedImage = picked);
                        },
                        child: pickedImage != null
                            ? Image.file(
                                File(pickedImage!.path),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : (imageUrlController.text.isNotEmpty
                                ? Image.network(
                                    imageUrlController.text,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[300],
                                    child:
                                        const Icon(Icons.add_a_photo, size: 48),
                                  )),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '상품명'),
                validator: (v) => v == null || v.isEmpty ? '필수 입력' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: '가격'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null ? '숫자만 입력' : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: '이미지 URL'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      isLoading = true;
                      String? imageUrl = imageUrlController.text;
                      if (pickedImage != null) {
                        imageUrl = await uploadImageToSupabase(pickedImage!);
                      }
                      final updated = product.copyWith(
                        name: nameController.text,
                        price: int.parse(priceController.text),
                        category: categoryController.text,
                        imageUrl: imageUrl,
                      );
                      ref
                          .read(productListProvider.notifier)
                          .updateProduct(updated);
                      Navigator.pop(context, updated);
                    },
                    child: const Text('수정'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      // 서버/riverpod 상태 동기화(실제 구현 필요)
                      ref
                          .read(productListProvider.notifier)
                          .removeProduct(product.id);
                      Navigator.pop(context, 'deleted');
                    },
                    child: const Text('삭제'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
