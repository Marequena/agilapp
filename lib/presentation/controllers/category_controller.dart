import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories.dart';

class CategoryController extends ChangeNotifier {
  final GetCategories usecase;
  final CategoryRepository repository;
  CategoryController(this.usecase, this.repository);

  bool loading = false;
  List<Category> categories = [];
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final raw = await usecase.call();
      categories = raw.map((e) => Category.fromJson(e as Map<String, dynamic>?)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchRaw() => repository.fetchListRaw();
}
