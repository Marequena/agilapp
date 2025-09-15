import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository repository;
  ProductController(this.repository);

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
      // apply current filter (if any)
      if (selectedCategoryId == null) {
        products = List.from(fullProducts);
      } else {
        products = fullProducts.where((p) => (p.description ?? '').contains('category:${selectedCategoryId}')).toList();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    if (categoryId == null || categoryId.isEmpty) {
      products = List.from(fullProducts);
    } else {
  // filter by parsed categoryId from product (string)
  products = fullProducts.where((p) => (p.categoryId ?? '').toString() == categoryId.toString()).toList();
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchRaw() => repository.fetchFullDetailsRaw();
}
