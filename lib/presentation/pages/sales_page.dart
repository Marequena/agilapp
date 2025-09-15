import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/price_picker_sheet.dart';
import '../../core/widgets/product_metro_tile.dart';
import '../../domain/entities/product.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(context, listen: false).load();
      Provider.of<ProductController>(context, listen: false).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productCtrl = Provider.of<ProductController>(context);
    final catCtrl = Provider.of<CategoryController>(context);
    final cart = Provider.of<CartController>(context);

    final products = selectedCategory == null || selectedCategory!.isEmpty
        ? productCtrl.products
        : productCtrl.products.where((p) => (p.categoryId ?? '') == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        actions: [
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => Navigator.of(context).pushNamed('/cart')),
            if (cart.totalItems > 0)
              Positioned(right: 6, top: 8, child: CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Text('${cart.totalItems}', style: const TextStyle(fontSize: 12, color: Colors.white)))),
          ])
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 64,
          child: catCtrl.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemBuilder: (context, idx) {
                    if (idx == 0) {
                      final sel = selectedCategory == null;
                      return ChoiceChip(label: const Text('Todas'), selected: sel, onSelected: (_) => setState(() => selectedCategory = null));
                    }
                    final c = catCtrl.categories[idx - 1];
                    final sel = c.id == selectedCategory;
                    return ChoiceChip(label: Text(c.name ?? 'Sin nombre'), selected: sel, onSelected: (_) => setState(() => selectedCategory = sel ? null : c.id));
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: (catCtrl.categories.length) + 1,
                ),
        ),
        Expanded(
          child: productCtrl.loading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(child: Text('No hay productos'))
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (ctx, idx) {
                          final Product p = products[idx];
                          return ProductMetroTile(
                            product: p,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => PricePickerSheet(product: p, cart: cart),
                              );
                            },
                          );
                        },
                      ),
                    ),
        ),
      ]),
    );
  }
}
