import '../../domain/entities/sale.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/api_client.dart';
import '../../core/data/local_storage.dart';

class SalesRepositoryImpl implements SalesRepository {
  final ApiClient _api;

  SalesRepositoryImpl({ApiClient? apiClient}) : _api = apiClient ?? ApiClient.create();

  @override
  Future<Sale?> createSale(Map<String, dynamic> payload) async {
    try {
      final res = await _api.post('/api/sales', data: payload);
      if ((res.statusCode == 200 || res.statusCode == 201) && res.data is Map) {
        return Sale.fromJson(Map<String, dynamic>.from(res.data as Map));
      }
    } catch (e) {
      // queue pending write and save optimistic local copy
      try {
        final box = await LocalStorage.openBox(LocalStorage.pendingBox);
        final items = (box.get('items', defaultValue: []) as List).toList();
        // create local id and attach to payload so SyncService can correlate
        final localId = 'local-${DateTime.now().millisecondsSinceEpoch}';
        final queuedPayload = Map<String, dynamic>.from(payload);
        queuedPayload['local_id'] = localId;
        items.add({'method': 'POST', 'endpoint': '/api/sales', 'payload': queuedPayload, 'attempts': 0});
        await box.put('items', items);

        // also store optimistic local copy in a sales box
        final sales = await LocalStorage.openBox(LocalStorage.salesBox);
        final entry = Map<String, dynamic>.from(queuedPayload);
        entry['status'] = 'queued';
        final current = (sales.get('items', defaultValue: []) as List).toList();
        current.add(entry);
        await sales.put('items', current);
      } catch (_) {}
    }
    return null;
  }
}
