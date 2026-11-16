/// Ürün veri modeli. JSON <-> nesne dönüşümleri fromJson / toJson ile yapılır.
class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String image;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'rating': rating,
        'stock': stock,
        'image': image,
        'description': description,
      };

  /// 1299.9 -> "1.299,90 ₺"
  String get formattedPrice => formatPrice(price);
}

String formatPrice(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  return '$whole,${parts[1]} ₺';
}
