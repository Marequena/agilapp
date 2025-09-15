import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/api_client.dart';
import '../../core/data/local_storage.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<List<Customer>> fetchFullDetails() async {
    try {
      final res = await _apiClient.get('/api/customers/full-details');
      if (res.statusCode == 200) {
        List<Customer> customers = [];
        if (res.data is List) {
          final List data = res.data as List;
          customers = data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
        } else if (res.data is Map && (res.data as Map).containsKey('customers')) {
          final List data = (res.data as Map)['customers'] as List;
          customers = data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
        }
        // persist to local
        final box = await LocalStorage.openBox(LocalStorage.customersBox);
        await box.put('all_customers', customers.map((c) => c.toJson()).toList());
        return customers;
      }
    } catch (e) {
      // network error -> fallback to local
    }

    // fallback to local storage
    final box = await LocalStorage.openBox(LocalStorage.customersBox);
    final raw = box.get('all_customers');
    if (raw is List) {
      return raw.map((e) => Customer.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  @override
  Future<dynamic> fetchFullDetailsRaw() async {
    try {
      final res = await _apiClient.get('/api/customers/full-details');
      return res.data;
    } catch (_) {
      final box = await LocalStorage.openBox(LocalStorage.customersBox);
      return box.get('all_customers') ?? [];
    }
  }

  @override
  Future<Customer?> createCustomer(Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/customers', data: payload);
      if ((res.statusCode == 201 || res.statusCode == 200) && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final customer = Customer.fromJson(e);
        // store or update local
        final box = await LocalStorage.openBox(LocalStorage.customersBox);
        final list = box.get('all_customers') as List? ?? [];
        list.add(customer.toJson());
        await box.put('all_customers', list);
        return customer;
      }
    } catch (e) {
      // queue pending write
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/customers', 'payload': payload});
      await box.put('items', pending);
      // optimistic local save: create a temp id
      final temp = Customer.fromJson({'id': DateTime.now().millisecondsSinceEpoch.toString(), ...payload});
      final cbox = await LocalStorage.openBox(LocalStorage.customersBox);
      final list = cbox.get('all_customers') as List? ?? [];
      list.add(temp.toJson());
      await cbox.put('all_customers', list);
      return temp;
    }
    return null;
  }

  @override
  Future<Customer?> updateCustomer(String id, Map<String, dynamic> payload) async {
    try {
      final res = await _apiClient.post('/api/customers/$id', data: payload);
      if (res.statusCode == 200 && res.data is Map) {
        final e = res.data as Map<String, dynamic>;
        final customer = Customer.fromJson(e);
        final box = await LocalStorage.openBox(LocalStorage.customersBox);
        final list = box.get('all_customers') as List? ?? [];
        final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
        if (idx >= 0) {
          list[idx] = customer.toJson();
        }
        await box.put('all_customers', list);
        return customer;
      }
    } catch (e) {
      // queue pending update
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final pending = box.get('items', defaultValue: []) as List;
      pending.add({'method': 'POST', 'endpoint': '/api/customers/$id', 'payload': payload});
      await box.put('items', pending);
      // optimistic local update
      final cbox = await LocalStorage.openBox(LocalStorage.customersBox);
      final list = cbox.get('all_customers') as List? ?? [];
      final idx = list.indexWhere((m) => (m as Map)['id'].toString() == id.toString());
      if (idx >= 0) {
        final updated = Map<String, dynamic>.from(list[idx] as Map);
        updated.addAll(payload);
        list[idx] = updated;
        await cbox.put('all_customers', list);
        return Customer.fromJson(updated);
      }
    }
    return null;
  }
}
