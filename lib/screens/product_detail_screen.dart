import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart.dart';
import '../widgets/cart_button.dart';

/// Ürün detay sayfası. Ürün, route argümanı olarak gelir ve
/// MaterialPageRoute üzerinden constructor'a aktarılır.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: const [CartButton(), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Chip(label: Text(product.category)),
              const Spacer(),
              const Icon(Icons.star_rounded, color: Colors.amber),
              Text(product.rating.toStringAsFixed(1), style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(product.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(product.formattedPrice,
              style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text('Ürün açıklaması', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(product.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 18, color: product.stock < 10 ? Colors.red : Colors.green),
              const SizedBox(width: 6),
              Text(product.stock < 10 ? 'Son ${product.stock} ürün!' : 'Stokta (${product.stock} adet)'),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListenableBuilder(
            listenable: Cart.instance,
            builder: (context, _) {
              final qty = Cart.instance.quantityOf(product);
              return FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () => Cart.instance.add(product),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(qty == 0 ? 'Sepete Ekle' : 'Sepete Ekle  ($qty sepette)'),
              );
            },
          ),
        ),
      ),
    );
  }
}
