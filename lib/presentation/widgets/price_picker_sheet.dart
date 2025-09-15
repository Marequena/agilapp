import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../../domain/entities/product.dart';

class PricePickerSheet extends StatelessWidget {
  final Product product;
  final CartController cart;
  const PricePickerSheet({Key? key, required this.product, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      builder: (context, sc) {
        return Container(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: SingleChildScrollView(
            controller: sc,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _PricePickerContent(product: product, cart: cart),
            ),
          ),
        );
      },
    );
  }
}

class _PricePickerContent extends StatefulWidget {
  final Product product;
  final CartController cart;
  const _PricePickerContent({Key? key, required this.product, required this.cart}) : super(key: key);

  @override
  State<_PricePickerContent> createState() => _PricePickerContentState();
}

class _PricePickerContentState extends State<_PricePickerContent> {
  late double selectedPrice;
  String? priceLabel;
  int qty = 1;
  late List<Map<String, dynamic>> priceOptions;

  double parseToDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) {
      final cleaned = v.replaceAll(',', '.');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    priceOptions = (widget.product.prices ?? [])
        .map((e) {
          if (e is Map) {
            final dynPrice = e['price'];
            final priceD = parseToDouble(dynPrice);
            final lbl = e['label']?.toString() ?? dynPrice?.toString() ?? priceD.toString();
            return {'label': lbl, 'price': priceD};
          }
          final priceD = parseToDouble(e);
          return {'label': e?.toString() ?? priceD.toString(), 'price': priceD};
        })
        .toList()
      ..cast<Map<String, dynamic>>();

    if (priceOptions.isEmpty) {
      selectedPrice = parseToDouble(widget.product.price);
      priceLabel = widget.product.price;
    } else {
      final first = priceOptions.first;
      selectedPrice = (first['price'] as double?) ?? 0.0;
      priceLabel = first['label']?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        leading: p.image != null ? Image.network(p.image!, width: 56, height: 56, fit: BoxFit.cover) : const SizedBox.shrink(),
        title: Text(p.name ?? 'Sin nombre'),
        subtitle: Text('Stock: ${p.stock ?? '0'}'),
      ),
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(children: [
          const Align(alignment: Alignment.centerLeft, child: Text('Precios')),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: priceOptions.map<Widget>((opt) {
              final optPrice = (opt['price'] as double?) ?? 0.0;
              final optLabel = opt['label']?.toString() ?? optPrice.toString();
              final selected = (optPrice == selectedPrice);
              return ChoiceChip(label: Text(optLabel), selected: selected, onSelected: (_) => setState(() { selectedPrice = optPrice; priceLabel = optLabel; }));
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Cantidad:'),
            const SizedBox(width: 12),
            IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (qty > 1) qty--; })),
            Text('$qty'),
            IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { qty++; })),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {
            if (qty <= 0) return;
            Navigator.of(context).pop();
            widget.cart.add(widget.product, qty: qty, selectedPrice: selectedPrice, priceLabel: priceLabel);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.product.name ?? 'Producto'} agregado al carrito')));
          }, child: const Text('Agregar al carrito'))
        ]),
      )
    ]);
  }
}
