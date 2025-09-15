import 'package:flutter/foundation.dart';

class SyncNotifier extends ChangeNotifier {
  static final SyncNotifier _instance = SyncNotifier._internal();
  factory SyncNotifier() => _instance;
  SyncNotifier._internal();

  bool _syncing = false;
  bool get syncing => _syncing;

  void setSyncing(bool v) {
    _syncing = v;
    notifyListeners();
  }
}
