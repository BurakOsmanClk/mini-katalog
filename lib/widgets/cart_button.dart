import 'package:flutter/material.dart';
import '../state/cart.dart';

/// AppBar'daki sepet ikonu; ürün sayısını rozet olarak gösterir.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Cart.instance,
      builder: (context, _) {
        final count = Cart.instance.totalItems;
        return IconButton(
          tooltip: 'Sepet',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        );
      },
    );
  }
}
