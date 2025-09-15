import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/data/local_storage.dart';
import '../../core/services/sync_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> failed = [];

  bool _busy = false;

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

  Future<void> _requeueAllSales() async {
    setState(() => _busy = true);
    try {
      final salesBox = await LocalStorage.openBox(LocalStorage.salesBox);
      final current = (salesBox.get('items', defaultValue: []) as List).toList();
      final svc = SyncService();
      int enqueued = 0;
      for (final e in current) {
        if (e is Map && (e['status'] == 'queued' || e['status'] == null)) {
          final lid = e['local_id']?.toString();
          if (lid != null) {
            final ok = await svc.requeueSaleFromSalesBox(lid);
            if (ok) enqueued++;
          }
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reintentos encolados: $enqueued')));
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _cleanSyncedSales() async {
    final salesBox = await LocalStorage.openBox(LocalStorage.salesBox);
    final current = (salesBox.get('items', defaultValue: []) as List).toList();
    final remaining = current.where((e) => (e is Map) && e['status'] != 'synced').toList();
    await salesBox.put('items', remaining);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ventas sincronizadas limpiadas')));
  }

  Future<void> _archiveSyncedOlderThan(Duration age) async {
    final salesBox = await LocalStorage.openBox(LocalStorage.salesBox);
    final current = (salesBox.get('items', defaultValue: []) as List).toList();
    final now = DateTime.now();
    final remaining = <dynamic>[];
    int archived = 0;
    for (final e in current) {
      if (e is Map && e['status'] == 'synced' && e['created_at'] != null) {
        try {
          final dt = DateTime.parse(e['created_at'].toString());
          if (now.difference(dt) > age) {
            archived++;
            continue; // skip (archive)
          }
        } catch (_) {
          // if parse fails, keep the item
          remaining.add(e);
          continue;
        }
      } else {
        remaining.add(e);
      }
    }
    await salesBox.put('items', remaining);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Archivadas: $archived')));
  }

  Future<void> _retry(int idx) async {
    final svc = SyncService();
    await svc.requeueFailedItem(failed[idx]);
    await _loadFailed();
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item re-enqueued for retry')));
  }

  Future<void> _delete(int idx) async {
    final svc = SyncService();
    await svc.deleteFailedItem(failed[idx]);
    await _loadFailed();
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item eliminado')));
  }

  Future<void> _confirmDelete(int idx) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Eliminar este item fallido permanentemente?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
        ],
      );
    });
    if (ok == true) {
      await _delete(idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), actions: [
        IconButton(onPressed: _busy ? null : _requeueAllSales, icon: const Icon(Icons.refresh), tooltip: 'Reintentar todo'),
        IconButton(onPressed: _cleanSyncedSales, icon: const Icon(Icons.cleaning_services), tooltip: 'Limpiar sincronizadas'),
        IconButton(onPressed: () => _archiveSyncedOlderThan(const Duration(days: 7)), icon: const Icon(Icons.archive), tooltip: 'Archivar >7d'),
      ]),
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
            final payload = item['payload'];
            final pretty = payload != null ? JsonEncoder.withIndent('  ').convert(payload) : '{}';
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ExpansionTile(
                title: Text(item['endpoint']?.toString() ?? 'unknown'),
                subtitle: Text(item['method']?.toString() ?? ''),
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(pretty, style: const TextStyle(fontFamily: 'monospace')),
                    ),
                  ),
                    OverflowBar(children: [
                      TextButton.icon(onPressed: () => _retry(idx), icon: const Icon(Icons.refresh), label: const Text('Retry')),
                      TextButton.icon(onPressed: () => _confirmDelete(idx), icon: const Icon(Icons.delete), label: const Text('Delete')),
                    ])
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
