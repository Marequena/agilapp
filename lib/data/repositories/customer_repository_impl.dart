import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/api_client.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<List<Customer>> fetchFullDetails() async {
    final res = await _apiClient.get('/api/customers/full-details');
    if (res.statusCode == 200) {
      if (res.data is List) {
        final List data = res.data as List;
        return data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (res.data is Map && (res.data as Map).containsKey('customers')) {
        final List data = (res.data as Map)['customers'] as List;
        return data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    // fallback empty
    return [];
  }

  @override
  Future<dynamic> fetchFullDetailsRaw() async {
    final res = await _apiClient.get('/api/customers/full-details');
    return res.data;
  }

  @override
  Future<Customer?> createCustomer(Map<String, dynamic> payload) async {
    final res = await _apiClient.post('/api/customers', data: payload);
    if ((res.statusCode == 201 || res.statusCode == 200) && res.data is Map) {
      final e = res.data as Map<String, dynamic>;
      return Customer.fromJson(e);
    }
    return null;
  }

  @override
  Future<Customer?> updateCustomer(String id, Map<String, dynamic> payload) async {
  // ApiClient currently exposes post and get. Use POST to update endpoint (adjust if API differs).
  final res = await _apiClient.post('/api/customers/$id', data: payload);
    if (res.statusCode == 200 && res.data is Map) {
      final e = res.data as Map<String, dynamic>;
      return Customer.fromJson(e);
    }
    return null;
  }
}
