import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../../core/data/local_storage.dart';

class CartItem {
  final Product product;
  int qty;
  final double selectedPrice;
  final String? priceLabel;

  CartItem({required this.product, this.qty = 1, required this.selectedPrice, this.priceLabel});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'qty': qty,
        'selectedPrice': selectedPrice,
        'priceLabel': priceLabel,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product'] as Map<String, dynamic>?),
        qty: (json['qty'] as num?)?.toInt() ?? 1,
        selectedPrice: (json['selectedPrice'] as num?)?.toDouble() ?? 0.0,
        priceLabel: json['priceLabel']?.toString(),
      );
}

class CartController extends ChangeNotifier {
  // Keyed by productId|price to allow multiple price variants per product
  final Map<String, CartItem> _items = {};

  CartController() {
    _load();
  }

  List<CartItem> get items => _items.values.toList(growable: false);

  int get totalItems => _items.values.fold(0, (s, it) => s + it.qty);

  // Parse a product price (string) into a double. Returns 0.0 on parse failure.
  double parsePrice(String? price) {
    if (price == null) return 0.0;
    try {
      // Remove common currency symbols and thousands separators
      final cleaned = price.replaceAll(RegExp(r"[^0-9.,-]"), '');
      // Replace comma decimal separators if present (e.g., "1.234,56")
      if (cleaned.contains(',') && cleaned.lastIndexOf(',') > cleaned.lastIndexOf('.')) {
        final normalized = cleaned.replaceAll('.', '').replaceAll(',', '.');
        return double.tryParse(normalized) ?? 0.0;
      }
      final normalized = cleaned.replaceAll(',', '');
      return double.tryParse(normalized) ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, it) => sum + (it.selectedPrice) * it.qty);
  }

  String formattedCurrency([double? value]) {
    final v = value ?? totalAmount;
    final fmt = NumberFormat.simpleCurrency(locale: 'es_US');
    return fmt.format(v);
  }

  Future<void> _load() async {
    try {
      final box = await LocalStorage.openBox(LocalStorage.cartBox);
      final raw = box.get('cart', defaultValue: []) as List? ?? [];
      for (var e in raw) {
        final item = CartItem.fromJson(Map<String, dynamic>.from(e as Map));
        _items[item.product.id] = item;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final box = await LocalStorage.openBox(LocalStorage.cartBox);
      final list = _items.values.map((c) => c.toJson()).toList();
      await box.put('cart', list);
    } catch (_) {}
  }

  void add(Product p, {int qty = 1, required double selectedPrice, String? priceLabel}) {
    final key = '${p.id}|$selectedPrice';
    final existing = _items[key];
    if (existing != null) {
      existing.qty += qty;
    } else {
      _items[key] = CartItem(product: p, qty: qty, selectedPrice: selectedPrice, priceLabel: priceLabel);
    }
    _save();
    notifyListeners();
  }

  /// Remove an item and return it so callers can offer an undo option.
  CartItem? removeItem(CartItem item) {
    final key = '${item.product.id}|${item.selectedPrice}';
    final removed = _items.remove(key);
    _save();
    notifyListeners();
    return removed;
  }

  /// Restore a previously removed item (used by undo).
  void restoreItem(CartItem item) {
    final key = '${item.product.id}|${item.selectedPrice}';
    _items[key] = item;
    _save();
    notifyListeners();
  }

  void updateQty(CartItem item, int qty) {
    final key = '${item.product.id}|${item.selectedPrice}';
    final existing = _items[key];
    if (existing != null) {
      existing.qty = qty;
      if (existing.qty <= 0) _items.remove(key);
      _save();
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _save();
    notifyListeners();
  }
}

