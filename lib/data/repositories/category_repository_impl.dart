import '../../domain/repositories/category_repository.dart';
import '../datasources/api_client.dart';
import '../../core/data/local_storage.dart';
import '../../domain/entities/category.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<List<dynamic>> fetchList() async {
    try {
      final res = await _apiClient.get('/api/category/list');
      final data = res.data;
      List<Map<String, dynamic>> maps = [];
      if (data is List) {
        maps = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (data is Map && data['categories'] is List) {
        maps = (data['categories'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (data is Map && data['data'] is List) {
        maps = (data['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      final box = await LocalStorage.openBox(LocalStorage.categoriesBox);
      await box.put('all_categories', maps);
      return maps;
    } catch (e) {
      // fallback to local
    }
    final box = await LocalStorage.openBox(LocalStorage.categoriesBox);
    final raw = box.get('all_categories');
    if (raw is List) return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListRaw() async {
    try {
      final res = await _apiClient.get('/api/category/list');
      final data = res.data;
      if (data is List) return data.map((e) => e as Map<String, dynamic>).toList();
      if (data is Map && data['categories'] is List) return (data['categories'] as List).map((e) => e as Map<String, dynamic>).toList();
      if (data is Map && data['data'] is List) return (data['data'] as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      final box = await LocalStorage.openBox(LocalStorage.categoriesBox);
      final raw = box.get('all_categories');
      if (raw is List) return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> createCategory(Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/categories', data: payload);
      if ((res.statusCode == 201 || res.statusCode == 200) && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final cat = Category.fromJson(e);
        final box = await LocalStorage.openBox(LocalStorage.categoriesBox);
        final list = box.get('all_categories') as List? ?? [];
        list.add(cat.toJson());
        await box.put('all_categories', list);
        return cat.toJson();
      }
    } catch (e) {
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/categories', 'payload': payload});
      await box.put('items', pending);
      final temp = Category.fromJson({'id': DateTime.now().millisecondsSinceEpoch.toString(), ...payload});
      final cbox = await LocalStorage.openBox(LocalStorage.categoriesBox);
      final list = cbox.get('all_categories') as List? ?? [];
      list.add(temp.toJson());
      await cbox.put('all_categories', list);
      return temp.toJson();
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateCategory(String id, Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/categories/$id', data: payload);
      if (res.statusCode == 200 && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final cat = Category.fromJson(e);
        final box = await LocalStorage.openBox(LocalStorage.categoriesBox);
        final list = box.get('all_categories') as List? ?? [];
        final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
        if (idx >= 0) list[idx] = cat.toJson();
        await box.put('all_categories', list);
        return cat.toJson();
      }
    } catch (e) {
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/categories/$id', 'payload': payload});
      await box.put('items', pending);
      final cbox = await LocalStorage.openBox(LocalStorage.categoriesBox);
      final list = cbox.get('all_categories') as List? ?? [];
      final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
      if (idx >= 0) {
        final updated = Map<String, dynamic>.from(list[idx] as Map);
        updated.addAll(payload);
        list[idx] = updated;
        await cbox.put('all_categories', list);
        return updated;
      }
    }
    return null;
  }
}
