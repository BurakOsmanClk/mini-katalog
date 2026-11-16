import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart.dart';

/// GridView içindeki ürün kartı
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.image, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 2),
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 4, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(product.formattedPrice,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    tooltip: 'Sepete ekle',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                    onPressed: () {
                      Cart.instance.add(product);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text('${product.name} sepete eklendi'),
                          duration: const Duration(seconds: 1),
                        ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
