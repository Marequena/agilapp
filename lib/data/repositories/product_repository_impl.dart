import '../../domain/repositories/product_repository.dart';
import '../datasources/api_client.dart';
import '../../core/data/local_storage.dart';
import '../../domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<List<dynamic>> fetchFullDetails() async {
    try {
      final res = await _apiClient.get('/api/product-services/full-details');
      final data = res.data;
      List<Map<String, dynamic>> maps = [];
      if (data is List) {
        maps = data.map((e) => e as Map<String, dynamic>).toList();
      } else if (data is Map && data['product_services'] is List) {
        maps = (data['product_services'] as List).map((e) => e as Map<String, dynamic>).toList();
      } else if (data is Map && data['products'] is List) {
        maps = (data['products'] as List).map((e) => e as Map<String, dynamic>).toList();
      }
      // persist raw maps
      final box = await LocalStorage.openBox(LocalStorage.productsBox);
      await box.put('all_products', maps);
      return maps;
    } catch (e) {
      // fallback to local
    }

    final box = await LocalStorage.openBox(LocalStorage.productsBox);
    final raw = box.get('all_products');
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchFullDetailsRaw() async {
    try {
      final res = await _apiClient.get('/api/product-services/full-details');
      final data = res.data;
      if (data is Map && data['product_services'] is List) {
        return (data['product_services'] as List).map((e) => e as Map<String, dynamic>).toList();
      }
      if (data is List) return data.map((e) => e as Map<String, dynamic>).toList();
      if (data is Map && data['products'] is List) return (data['products'] as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      final box = await LocalStorage.openBox(LocalStorage.productsBox);
      final raw = box.get('all_products');
      if (raw is List) return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> createProduct(Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/products', data: payload);
      if ((res.statusCode == 201 || res.statusCode == 200) && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final product = Product.fromJson(e);
        final box = await LocalStorage.openBox(LocalStorage.productsBox);
        final list = box.get('all_products') as List? ?? [];
        list.add(product.toJson());
        await box.put('all_products', list);
        return product.toJson();
      }
    } catch (e) {
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/products', 'payload': payload});
      await box.put('items', pending);
      // optimistic
      final temp = Product.fromJson({'id': DateTime.now().millisecondsSinceEpoch.toString(), ...payload});
      final pbox = await LocalStorage.openBox(LocalStorage.productsBox);
      final list = pbox.get('all_products') as List? ?? [];
      list.add(temp.toJson());
      await pbox.put('all_products', list);
      return temp.toJson();
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateProduct(String id, Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/products/$id', data: payload);
      if (res.statusCode == 200 && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final product = Product.fromJson(e);
        final box = await LocalStorage.openBox(LocalStorage.productsBox);
        final list = box.get('all_products') as List? ?? [];
        final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
        if (idx >= 0) {
          list[idx] = product.toJson();
        }
        await box.put('all_products', list);
        return product.toJson();
      }
    } catch (e) {
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/products/$id', 'payload': payload});
      await box.put('items', pending);
      // optimistic local update
      final pbox = await LocalStorage.openBox(LocalStorage.productsBox);
      final list = pbox.get('all_products') as List? ?? [];
      final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
      if (idx >= 0) {
        final updated = Map<String, dynamic>.from(list[idx] as Map);
        updated.addAll(payload);
        list[idx] = updated;
        await pbox.put('all_products', list);
        return updated;
      }
    }
    return null;
  }
}
