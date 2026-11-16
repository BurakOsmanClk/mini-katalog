import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart.dart';

void main() {
  const p = Product(
      id: 1, name: 'Test', category: 'X', price: 1299.9, rating: 4, stock: 3, image: '', description: '');

  test('fromJson / toJson dönüşümü', () {
    final copy = Product.fromJson(p.toJson());
    expect(copy.name, 'Test');
    expect(copy.price, 1299.9);
  });

  test('fiyat biçimlendirme', () {
    expect(p.formattedPrice, '1.299,90 ₺');
  });

  test('sepet ekleme / azaltma / toplam', () {
    final cart = Cart.instance..clear();
    cart.add(p);
    cart.add(p);
    expect(cart.totalItems, 2);
    expect(cart.totalPrice, closeTo(2599.8, 0.001));
    cart.decrease(p);
    expect(cart.totalItems, 1);
    cart.decrease(p);
    expect(cart.items, isEmpty);
  });
}
