import 'package:flutter/material.dart';
import '../../core/data/local_storage.dart';
import '../../core/services/sync_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> failed = [];

  @override
  void initState() {
    super.initState();
    _loadFailed();
  }

  Future<void> _loadFailed() async {
    final box = await LocalStorage.openBox(LocalStorage.pendingBox);
    final f = (box.get('failed_items', defaultValue: []) as List).toList();
    setState(() {
      failed = f.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    });
  }

  Future<void> _retry(int idx) async {
    final svc = SyncService();
    await svc.requeueFailedItem(failed[idx]);
    await _loadFailed();
  }

  Future<void> _delete(int idx) async {
    final svc = SyncService();
    await svc.deleteFailedItem(failed[idx]);
    await _loadFailed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RefreshIndicator(
        onRefresh: _loadFailed,
        child: ListView.builder(
          itemCount: failed.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return const ListTile(title: Text('Failed pending writes'));
            }
            final idx = i - 1;
            final item = failed[idx];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(item['endpoint']?.toString() ?? 'unknown'),
                subtitle: Text(item['method']?.toString() ?? ''),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: () => _retry(idx), icon: const Icon(Icons.refresh)),
                  IconButton(onPressed: () => _delete(idx), icon: const Icon(Icons.delete)),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
