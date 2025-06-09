import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'models/order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(OrderAdapter());
  await Hive.openBox<Product>('products');
  await Hive.openBox<Order>('orders');
  runApp(const MyApp());
}
