import 'package:flutter/material.dart';
import '../../domain/entities/customer.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../core/services/sync_notifier.dart';


class CustomerController extends ChangeNotifier {
  final GetCustomers getCustomers;
  final CustomerRepository repository;

  CustomerController(this.getCustomers, this.repository) {
    _bindSync();
  }
  // subscribe to sync events
  void _bindSync() {
    try {
      final notifier = SyncNotifier();
      notifier.addListener(() {
        if (!notifier.syncing) {
          // refresh after sync finishes
          load();
        }
      });
    } catch (_) {}
  }

  bool loading = false;
  List<Customer> customers = [];
  String? error;
  dynamic lastRawResponse;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      customers = await getCustomers.call();
    } catch (ex) {
      customers = [];
      error = ex.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<dynamic> fetchRaw() async {
    try {
      final raw = await repository.fetchFullDetailsRaw();
      lastRawResponse = raw;
      notifyListeners();
      return raw;
    } catch (e) {
      lastRawResponse = null;
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> create(Map<String, dynamic> payload) async {
    final created = await repository.createCustomer(payload);
    if (created != null) {
      customers.insert(0, created);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> update(String id, Map<String, dynamic> payload) async {
    final updated = await repository.updateCustomer(id, payload);
    if (updated != null) {
      final i = customers.indexWhere((c) => c.id == id);
      if (i >= 0) customers[i] = updated;
      notifyListeners();
      return true;
    }
    return false;
  }
}
