import '../../domain/repositories/category_repository.dart';
import '../datasources/api_client.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _api = ApiClient.create();

  @override
  Future<List<dynamic>> fetchList() async {
    final res = await _api.get('/api/category/list');
    final data = res.data;
    if (data is List) return data;
    if (data is Map && data['categories'] is List) return data['categories'];
    if (data is Map && data['data'] is List) return data['data'];
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListRaw() async {
    final res = await _api.get('/api/category/list');
    final data = res.data;
    if (data is List) return data.map((e) => e as Map<String, dynamic>).toList();
    if (data is Map && data['categories'] is List) return (data['categories'] as List).map((e) => e as Map<String, dynamic>).toList();
    if (data is Map && data['data'] is List) return (data['data'] as List).map((e) => e as Map<String, dynamic>).toList();
    return [];
  }
}
