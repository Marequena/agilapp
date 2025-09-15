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
      for (final it in items) {
        try {
          if (it is Map) {
            final method = (it['method'] ?? 'GET').toString().toUpperCase();
            final endpoint = it['endpoint']?.toString() ?? '';
            final payload = it['payload'];
            late final response;
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
            if (response.statusCode == 200 || response.statusCode == 201) {
              // if response contains entity, persist to relevant box by heuristics
              final data = response.data;
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
              // keep it
              remaining.add(it);
            }
          }
        } catch (e) {
          remaining.add(it);
        }
      }
      await box.put('items', remaining);
    } catch (e) {
      // ignore
    }
  }
}
