import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: banner, arama, kategori filtresi ve ürün ızgarası
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Product>> _future = ProductRepository.fetchProducts();
  String _query = '';
  String _category = 'Tümü';

  List<Product> _filter(List<Product> all) {
    final q = _query.trim().toLowerCase();
    return all.where((p) {
      final matchCategory = _category == 'Tümü' || p.category == _category;
      final matchQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchCategory && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mini Katalog', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text('Keşfetmeye başla', style: theme.textTheme.bodySmall),
          ],
        ),
        actions: const [CartButton(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ürünler yüklenemedi: ${snapshot.error}'));
          }
          final all = snapshot.data!;
          final categories = ['Tümü', ...{for (final p in all) p.category}];
          final products = _filter(all);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Ürün ara',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  // Kategori çipleri: yatay ListView.builder
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      final c = categories[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: c == _category,
                          onSelected: (_) => setState(() => _category = c),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text('${products.length} ürün', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text('Aramanıza uygun ürün bulunamadı.')),
                  )
                else
                  // Ürün kartları: GridView.builder
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, i) => ProductCard(
                      product: products[i],
                      // Named route + argüman ile detay sayfasına geçiş
                      onTap: () => Navigator.pushNamed(context, '/detail', arguments: products[i]),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
