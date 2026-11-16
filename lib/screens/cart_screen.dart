import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart.dart';

/// Sepet sayfası (simülasyon): adet artırma/azaltma ve toplam tutar
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Cart.instance;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.black26),
                  const SizedBox(height: 12),
                  const Text('Sepetiniz boş'),
                  const SizedBox(height: 16),
                  // Navigator.pop ile bir önceki sayfaya dönüş
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Alışverişe devam et'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i].key;
                    final q = items[i].value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(p.image, width: 52, height: 52, fit: BoxFit.cover),
                        ),
                        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(formatPrice(p.price * q)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.decrease(p)),
                            Text('$q', style: theme.textTheme.titleMedium),
                            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.add(p)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Toplam (${cart.totalItems} ürün)', style: theme.textTheme.titleMedium),
                          const Spacer(),
                          Text(formatPrice(cart.totalPrice),
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                        onPressed: () {
                          cart.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Siparişiniz alındı (simülasyon)')),
                          );
                          Navigator.pop(context); // Sipariş sonrası önceki sayfaya dön
                        },
                        child: const Text('Siparişi Tamamla'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
