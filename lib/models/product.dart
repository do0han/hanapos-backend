import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int stock;
  @HiveField(4)
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        price: json['price'] as int,
        stock: json['stock'] as int,
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
        'image_url': imageUrl,
      };

  Product copyWith({
    String? id,
    String? name,
    int? price,
    int? stock,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ProductListNotifier extends StateNotifier<List<Product>> {
  ProductListNotifier() : super([]);

  final _box = Hive.box<Product>('products');

  void setProducts(List<Product> products) {
    state = products;
    _box.clear();
    for (final p in products) {
      _box.put(p.id, p);
    }
  }

  void addProduct(Product product) {
    state = [...state, product];
    _box.put(product.id, product);
  }

  void updateProduct(Product product) {
    state = [
      for (final p in state)
        if (p.id == product.id) product else p
    ];
    _box.put(product.id, product);
  }

  void removeProduct(String id) {
    state = state.where((p) => p.id != id).toList();
    _box.delete(id);
  }

  void loadFromLocal() {
    final products = _box.values.toList();
    state = products;
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, List<Product>>(
  (ref) => ProductListNotifier(),
);
