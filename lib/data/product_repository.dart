import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

/// API simülasyonu: ürünler assets/data/products.json dosyasından okunur.
/// Gerçek bir API'ye geçildiğinde yalnızca bu sınıfın değişmesi yeterlidir.
class ProductRepository {
  static Future<List<Product>> fetchProducts() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final list = data['products'] as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}
