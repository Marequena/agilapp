import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../controllers/category_controller.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart' as model;
import '../../core/theme/color_tokens.dart';
import '../../core/utils/color_contrast.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Product> _displayedProducts = [];
  final List<String> _displayedIds = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catCtrl = Provider.of<CategoryController>(context, listen: false);
      catCtrl.load();
      Provider.of<ProductController>(context, listen: false).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<ProductController>(context);
    // sync displayed list with controller after build to animate changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncList(ctrl);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTokens.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        title: const Text('Productos'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ProductController>(context, listen: false).load(),
        child: Builder(builder: (_) {
          if (ctrl.loading) return const Center(child: CircularProgressIndicator());
          if (ctrl.error != null) return Center(child: Text('Error: ${ctrl.error}'));
          if (ctrl.products.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const SizedBox(height: 8), const Text('No hay productos'), const SizedBox(height: 8), ElevatedButton(onPressed: () => ctrl.load(), child: const Text('Cargar'))]));

          return Column(
            children: [
              // categories carousel
              SizedBox(
                height: 64,
                child: Consumer<CategoryController>(builder: (context, cctrl, _) {
                  if (cctrl.loading) return const Center(child: CircularProgressIndicator());
                  if (cctrl.error != null) return Center(child: Text('Error categories: ${cctrl.error}'));
                  final cats = cctrl.categories;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, idx) {
                      if (idx == 0) {
                        final selected = ctrl.selectedCategoryId == null;
                        return ChoiceChip(
                          label: Text('Todas', style: TextStyle(color: highContrastColor(ColorTokens.primary))),
                          selected: selected,
                          selectedColor: ColorTokens.primary,
                          onSelected: (_) => Provider.of<ProductController>(context, listen: false).filterByCategory(null),
                        );
                      }
                        final model.Category cat = cats[idx - 1];
                      final selected = cat.id == ctrl.selectedCategoryId;
                      Color? bg;
                      try {
                        if (cat.color != null && cat.color!.isNotEmpty) {
                          final hex = cat.color!.replaceAll('#', '').trim();
                          bg = Color(int.parse('0xFF$hex'));
                        }
                      } catch (_) {
                        bg = null;
                      }
                      final chipBg = bg ?? ColorTokens.primary;
                      return ChoiceChip(
                        label: Text(cat.name ?? 'Sin nombre', style: TextStyle(color: highContrastColor(chipBg))),
                        selected: selected,
                        backgroundColor: chipBg.withAlpha((0.14 * 255).round()),
                        selectedColor: chipBg,
                        onSelected: (_) {
                          Provider.of<ProductController>(context, listen: false).filterByCategory(selected ? null : cat.id);
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: cats.length + 1,
                  );
                }),
              ),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _displayedProducts.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index, animation) {
                    final p = _displayedProducts[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: _buildItem(context, p),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Product p) {
    // determine category color (if available)
    final catCtrl = Provider.of<CategoryController>(context, listen: false);
    Color avatarBg = ColorTokens.primary;
    try {
      final cat = catCtrl.categories.firstWhere((c) => c.id == (p.categoryId ?? ''));
      if (cat.color != null && cat.color!.isNotEmpty) {
        final hex = cat.color!.replaceAll('#', '').trim();
        avatarBg = Color(int.parse('0xFF$hex'));
      }
    } catch (_) {
      // keep default
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: avatarBg, child: Icon(Icons.inventory, color: highContrastColor(avatarBg))),
        title: Row(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle, border: Border.all(color: avatarBg.computeLuminance() < 0.5 ? Colors.white24 : Colors.black12))),
          const SizedBox(width: 8),
          Expanded(child: Text(p.name ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        subtitle: Text(p.sku ?? ''),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(p.price ?? '-', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text('Stock: ${p.stock ?? '-'}', style: const TextStyle(fontSize: 12, color: Colors.black54))]),
      ),
    );
  }

  void _syncList(ProductController ctrl) {
    final newList = ctrl.products;
    final newIds = newList.map((p) => p.id).toList();

    // quick equal check
    if (listEquals(newIds, _displayedIds)) return;

    // if currently empty, insert all
    if (_displayedIds.isEmpty) {
      for (var i = 0; i < newList.length; i++) {
        _displayedProducts.insert(i, newList[i]);
        _displayedIds.insert(i, newList[i].id);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 220));
      }
      return;
    }

    // removals (from end to start)
    for (int i = _displayedIds.length - 1; i >= 0; i--) {
      final id = _displayedIds[i];
      if (!newIds.contains(id)) {
        final removed = _displayedProducts.removeAt(i);
        _displayedIds.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, anim) => SizeTransition(sizeFactor: anim, child: _buildItem(context, removed)),
          duration: const Duration(milliseconds: 200),
        );
      }
    }

    // insertions and moves
    for (int i = 0; i < newList.length; i++) {
      final id = newList[i].id;
      if (!_displayedIds.contains(id)) {
        _displayedProducts.insert(i, newList[i]);
        _displayedIds.insert(i, id);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 200));
      } else {
        final oldIndex = _displayedIds.indexOf(id);
        if (oldIndex != i) {
          final moving = _displayedProducts.removeAt(oldIndex);
          _displayedIds.removeAt(oldIndex);
          _displayedProducts.insert(i, moving);
          _displayedIds.insert(i, moving.id);
          // no animation for move
        }
      }
    }
  }
}
