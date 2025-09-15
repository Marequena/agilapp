import '../../domain/repositories/product_repository.dart';
import '../datasources/api_client.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _api = ApiClient.create();

  @override
  Future<List<dynamic>> fetchFullDetails() async {
    final res = await _api.get('/api/product-services/full-details');
    final data = res.data;
    if (data is List) return data;
    if (data is Map && data['product_services'] is List) return data['product_services'];
    if (data is Map && data['products'] is List) return data['products'];
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchFullDetailsRaw() async {
    final res = await _api.get('/api/product-services/full-details');
    final data = res.data;
    if (data is Map && data['product_services'] is List) {
      return (data['product_services'] as List).map((e) => e as Map<String, dynamic>).toList();
    }
  if (data is List) return data.map((e) => e as Map<String, dynamic>).toList();
    if (data is Map && data['products'] is List) return (data['products'] as List).map((e) => e as Map<String, dynamic>).toList();
    return [];
  }
}
