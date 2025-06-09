import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../models/cart.dart';
import '../../services/supabase_service.dart';
import '../../screens/pos/order_history_screen.dart';
import '../../screens/pos/inventory_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'payment_screen.dart';
import 'receipt_screen.dart';
import 'product_detail_screen.dart';

class PosScreen extends ConsumerStatefulWidget {
  final String jwtToken;
  const PosScreen({super.key, required this.jwtToken});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  List<CartItem> cart = [];
  final supabaseService = SupabaseService();
  String? storeId;
  String? cashierId;

  @override
  void initState() {
    super.initState();
    // 오프라인 캐싱: local DB 먼저 로드
    ref.read(productListProvider.notifier).loadFromLocal();
    loadProfileAndProducts();
  }

  Future<void> loadProfileAndProducts() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    cashierId = user.id;
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('store_id')
        .eq('id', user.id)
        .maybeSingle();
    storeId = profile?['store_id'] as String?;
    if (storeId == null) return;
    try {
      final products = await SupabaseService.getProducts(storeId!);
      ref.read(productListProvider.notifier).setProducts(products);
    } catch (e) {
      // 네트워크 실패 시 local DB만 사용
    }
    setState(() {});
  }

  void addToCart(Product product) {
    setState(() {
      final idx = cart.indexWhere((item) => item.product.id == product.id);
      if (idx >= 0) {
        cart[idx].quantity += 1;
      } else {
        cart.add(CartItem(product: product));
      }
    });
  }

  void removeFromCart(CartItem item) {
    setState(() {
      cart.remove(item);
    });
  }

  void changeQuantity(CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity <= 0) {
        cart.remove(item);
      }
    });
  }

  double get total => cart.fold(0, (sum, item) => sum + item.subtotal);

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderHistoryScreen(
                    role: null,
                    jwtToken: widget.jwtToken,
                    storeId: storeId,
                    userId: cashierId,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InventoryScreen(
                    jwtToken: widget.jwtToken,
                    storeId: storeId ?? '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, idx) {
                final p = products[idx];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('${p.price}원'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      addToCart(p);
                    },
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    );
                    // 수정/삭제 후 필요시 추가 액션(예: 스낵바 등) 가능
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
