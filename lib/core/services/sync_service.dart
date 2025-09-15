import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/local_storage.dart';
import '../../data/datasources/api_client.dart';
import 'sync_notifier.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ApiClient _api = ApiClient.create();
  StreamSubscription<ConnectivityResult>? _sub;
  bool _running = false;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    // initial attempt
  SyncNotifier().setSyncing(true);
  await _flushPending();
  SyncNotifier().setSyncing(false);
    _sub = Connectivity().onConnectivityChanged.listen((event) async {
      if (event != ConnectivityResult.none) {
    SyncNotifier().setSyncing(true);
    await _flushPending();
    SyncNotifier().setSyncing(false);
      }
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _running = false;
  }

  Future<void> _flushPending() async {
    try {
      final box = await LocalStorage.openBox(LocalStorage.pendingBox);
      final items = (box.get('items', defaultValue: []) as List).toList();
      if (items.isEmpty) return;
      final remaining = <dynamic>[];
      final failed = <dynamic>[];
      for (final it in items) {
        try {
          if (it is Map) {
            // ensure attempts counter
            final attempts = (it['attempts'] is int) ? it['attempts'] as int : 0;
            if (attempts >= 3) {
              // give up, move to failed
              failed.add(it);
              continue;
            }
            final method = (it['method'] ?? 'GET').toString().toUpperCase();
            final endpoint = it['endpoint']?.toString() ?? '';
            final payload = it['payload'];
            late final response;
            try {
              if (method == 'POST') {
                response = await _api.post(endpoint, data: payload);
              } else if (method == 'PUT') {
                response = await _api.put(endpoint, data: payload);
              } else if (method == 'DELETE') {
                response = await _api.delete(endpoint);
              } else {
                // fallback to GET for other methods in this simple implementation
                response = await _api.get(endpoint);
              }
            } catch (e) {
              // increment attempts and requeue
              it['attempts'] = attempts + 1;
              // exponential backoff sleep before continuing
              final delayMs = 500 * (1 << attempts);
              await Future.delayed(Duration(milliseconds: delayMs));
              remaining.add(it);
              continue;
            }
            if (response.statusCode == 200 || response.statusCode == 201) {
              // if response contains entity, persist to relevant box by heuristics
              final data = response.data;
              // special handling: if this was a sale POST, update sales_box entry
              if (endpoint.contains('/sales')) {
                try {
                  final salesBox = await LocalStorage.openBox(LocalStorage.salesBox);
                  final current = (salesBox.get('items', defaultValue: []) as List).toList();
                  // try to find by local_id in the payload
                  if (payload is Map && payload['local_id'] != null) {
                    final lid = payload['local_id'].toString();
                    final idx = current.indexWhere((e) => (e is Map) && e['local_id'] == lid);
                    if (idx >= 0) {
                      final entry = Map<String, dynamic>.from(current[idx] as Map);
                      entry['status'] = 'synced';
                      // store server id if present in response
                      if (data is Map && data['id'] != null) entry['server_id'] = data['id'];
                      current[idx] = entry;
                      await salesBox.put('items', current);
                    }
                  }
                } catch (_) {}
              }
              if (data is Map && endpoint.contains('/customers')) {
                final boxC = await LocalStorage.openBox(LocalStorage.customersBox);
                final list = boxC.get('all_customers') as List? ?? [];
                list.add(data);
                await boxC.put('all_customers', list);
                SyncNotifier().setSyncing(false);
              } else if (data is Map && endpoint.contains('/products')) {
                final boxP = await LocalStorage.openBox(LocalStorage.productsBox);
                final list = boxP.get('all_products') as List? ?? [];
                list.add(data);
                await boxP.put('all_products', list);
                SyncNotifier().setSyncing(false);
              } else if (data is Map && endpoint.contains('/categories')) {
                final boxK = await LocalStorage.openBox(LocalStorage.categoriesBox);
                final list = boxK.get('all_categories') as List? ?? [];
                list.add(data);
                await boxK.put('all_categories', list);
                SyncNotifier().setSyncing(false);
              }
              // else assume success and drop
            } else {
              // non-2xx -> increment attempts and keep it for retry
              final newAttempts = ((it['attempts'] is int) ? it['attempts'] as int : 0) + 1;
              it['attempts'] = newAttempts;
              if (newAttempts >= 3) {
                failed.add(it);
              } else {
                remaining.add(it);
              }
            }
          }
        } catch (e) {
          // unexpected error, increment attempt and requeue unless max
          if (it is Map) {
            final a = (it['attempts'] is int) ? it['attempts'] as int : 0;
            if (a + 1 >= 3) {
              failed.add(it);
            } else {
              it['attempts'] = a + 1;
              remaining.add(it);
            }
          } else {
            remaining.add(it);
          }
        }
      }
      await box.put('items', remaining);
      if (failed.isNotEmpty) {
        final oldFailed = box.get('failed_items', defaultValue: []) as List;
        await box.put('failed_items', [...oldFailed, ...failed]);
      }
    } catch (e) {
      // ignore
    }
  }

  /// Requeue a failed item (reset attempts and move to pending items), then flush.
  Future<void> requeueFailedItem(Map item) async {
    final box = await LocalStorage.openBox(LocalStorage.pendingBox);
    final failed = (box.get('failed_items', defaultValue: []) as List).toList();
    final remainingFailed = failed.where((f) => f != item).toList();
    await box.put('failed_items', remainingFailed);
    final items = (box.get('items', defaultValue: []) as List).toList();
    final copy = Map<String, dynamic>.from(item);
    copy['attempts'] = 0;
    items.add(copy);
    await box.put('items', items);
    // attempt flush
    SyncNotifier().setSyncing(true);
    await _flushPending();
    SyncNotifier().setSyncing(false);
  }

  Future<void> deleteFailedItem(Map item) async {
    final box = await LocalStorage.openBox(LocalStorage.pendingBox);
    final failed = (box.get('failed_items', defaultValue: []) as List).toList();
    final remainingFailed = failed.where((f) => f != item).toList();
    await box.put('failed_items', remainingFailed);
  }

  /// Requeue a sale stored in `sales_box` by its local_id.
  Future<bool> requeueSaleFromSalesBox(String localId) async {
    try {
      final salesBox = await LocalStorage.openBox(LocalStorage.salesBox);
      final current = (salesBox.get('items', defaultValue: []) as List).toList();
      final idx = current.indexWhere((e) => (e is Map) && e['local_id'] == localId);
      if (idx < 0) return false;
      final saleEntry = Map<String, dynamic>.from(current[idx] as Map);
      // prepare pending queue
      final pending = await LocalStorage.openBox(LocalStorage.pendingBox);
      final items = (pending.get('items', defaultValue: []) as List).toList();
      final payload = Map<String, dynamic>.from(saleEntry);
      // reset attempts
      items.add({'method': 'POST', 'endpoint': '/api/sales', 'payload': payload, 'attempts': 0});
      await pending.put('items', items);
      // mark local sales entry as 'queued' again
      saleEntry['status'] = 'queued';
      current[idx] = saleEntry;
      await salesBox.put('items', current);
      // trigger flush
      SyncNotifier().setSyncing(true);
      await _flushPending();
      SyncNotifier().setSyncing(false);
      return true;
    } catch (e) {
      return false;
    }
  }
}
