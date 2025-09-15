import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/data/local_storage.dart';
import '../../core/services/sync_service.dart';
import 'receipt_page.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({Key? key}) : super(key: key);

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final box = await LocalStorage.openBox(LocalStorage.salesBox);
      final raw = box.get('items', defaultValue: []) as List;
      final items = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList().reversed.toList();
      if (!mounted) return;
      setState(() {
        _items = items;
      });
    } catch (_) {}
  }

  Widget _saleCard(Map<String, dynamic> it) {
    final created = it['created_at'] ?? '';
    final total = (it['total'] as num?)?.toDouble() ?? 0.0;
    final localId = it['local_id'] ?? '---';
    final status = (it['status'] ?? 'unknown').toString();
    final serverId = it['server_id'] ?? '';
    String dateLabel = created.toString();
    try {
      final dt = DateTime.parse(created.toString());
      dateLabel = DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_Hm().format(dt);
    } catch (_) {}
    final fmt = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());
    final totalLabel = fmt.format(total);
    Color bg = Colors.grey.shade300;
    Color fg = Colors.black;
    IconData icon = Icons.schedule;
    if (status == 'queued') {
      bg = Colors.orange.shade400;
      fg = Colors.white;
      icon = Icons.schedule;
    } else if (status == 'synced') {
      bg = Colors.green.shade600;
      fg = Colors.white;
      icon = Icons.check;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReceiptPage(sale: it))),
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 120),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                CircleAvatar(backgroundColor: Colors.white24, child: Icon(icon, color: fg)),
                const SizedBox(width: 8),
                Text('Venta ${localId}', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
              ]),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'retry') {
                    final ok = await SyncService().requeueSaleFromSalesBox(localId.toString());
                    if (ok) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reintento encolado')));
                      await _load();
                    }
                  }
                },
                itemBuilder: (_) => [const PopupMenuItem(value: 'retry', child: Text('Reintentar'))],
              )
            ]),
            const SizedBox(height: 8),
            Text('Fecha: $dateLabel', style: TextStyle(color: fg.withAlpha((0.95 * 255).round()))),
            const SizedBox(height: 6),
            Text('Total: $totalLabel', style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(status.toUpperCase(), style: TextStyle(color: fg.withAlpha((0.9 * 255).round()), fontWeight: FontWeight.w600)),
              if (serverId != '') Text('ID: $serverId', style: TextStyle(color: fg.withAlpha((0.85 * 255).round())))
            ])
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: _items.isEmpty
          ? const Center(child: Text('No hay ventas'))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  try {
                    return _saleCard(_items[i]);
                  } catch (e) {
                    // return a simple fallback card to avoid crashing the grid
                    return Material(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(padding: const EdgeInsets.all(12), child: const Text('Error al mostrar venta')),
                    );
                  }
                },
              ),
            ),
    );
  }
}
