import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Basit sepet durumu (simülasyon). Ek paket kullanmadan ChangeNotifier ile
/// değişiklikleri dinleyen widget'ları günceller.
class Cart extends ChangeNotifier {
  Cart._();
  static final Cart instance = Cart._();

  final Map<int, int> _quantities = {};
  final Map<int, Product> _products = {};

  int get totalItems => _quantities.values.fold(0, (a, b) => a + b);

  double get totalPrice =>
      _quantities.entries.fold(0, (sum, e) => sum + _products[e.key]!.price * e.value);

  List<MapEntry<Product, int>> get items =>
      _quantities.entries.map((e) => MapEntry(_products[e.key]!, e.value)).toList();

  int quantityOf(Product p) => _quantities[p.id] ?? 0;

  void add(Product p) {
    _products[p.id] = p;
    _quantities[p.id] = quantityOf(p) + 1;
    notifyListeners();
  }

  void decrease(Product p) {
    final q = quantityOf(p);
    if (q <= 1) {
      _quantities.remove(p.id);
    } else {
      _quantities[p.id] = q - 1;
    }
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    notifyListeners();
  }
}
