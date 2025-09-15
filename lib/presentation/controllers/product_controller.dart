import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/services/sync_notifier.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository repository;
  ProductController(this.repository) {
    _bindSync();
  }
  // bind sync notifier
  void _bindSync() {
    try {
      final notifier = SyncNotifier();
      notifier.addListener(() {
        if (!notifier.syncing) load();
      });
    } catch (_) {}
  }
  
  // call bind
  // ...existing code...

  bool loading = false;
  List<Product> products = [];
  List<Product> fullProducts = []; // unfiltered
  String? selectedCategoryId;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final raw = await repository.fetchFullDetails();
      fullProducts = raw.map((e) => Product.fromJson(e as Map<String, dynamic>?)).toList();
  // apply current filter (if any) using existing filter function
  debugPrint('[ProductController] loaded fullProducts=${fullProducts.length}, selectedCategoryId=$selectedCategoryId');
  filterByCategory(selectedCategoryId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    debugPrint('[ProductController] filterByCategory -> categoryId=$categoryId, full=${fullProducts.length}');
    if (categoryId == null || categoryId.isEmpty) {
      products = List.from(fullProducts);
    } else {
      final needle = categoryId.toString().trim();
      products = fullProducts.where((p) {
        final pid = (p.categoryId ?? '').toString().trim();
        if (pid.isNotEmpty && pid == needle) return true;
        // fallback: some APIs embed category in description or use 'category_id:123'
        final desc = (p.description ?? '').toString();
        if (desc.contains('category:$needle') || desc.contains('category_id:$needle') || desc.contains('categoryId:$needle')) return true;
        return false;
      }).toList();
    }
    debugPrint('[ProductController] after filter -> products=${products.length}');
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchRaw() => repository.fetchFullDetailsRaw();
}
