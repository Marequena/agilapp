import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiptPage extends StatelessWidget {
  final Map<String, dynamic> sale;
  const ReceiptPage({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hive/ListView often returns LinkedHashMap<dynamic,dynamic>; normalize safely
    final rawItems = (sale['items'] as List<dynamic>? ?? []);
    final items = rawItems.map<Map<String, dynamic>>((e) {
      if (e is Map<String, dynamic>) return e;
      if (e is Map) return Map<String, dynamic>.from(e.cast<dynamic, dynamic>());
      return <String, dynamic>{};
    }).toList();

    final rawCustomer = sale['customer'];
    final customer = (rawCustomer is Map<String, dynamic>)
        ? rawCustomer
        : (rawCustomer is Map ? Map<String, dynamic>.from(rawCustomer.cast<dynamic, dynamic>()) : <String, dynamic>{});
    final total = (sale['total'] as num?)?.toDouble() ?? 0.0;
  final locale = Localizations.localeOf(context).toString();
  final fmt = NumberFormat.simpleCurrency(locale: locale);

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket (Simulado)'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: Colors.black87),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // header
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 48, height: 48, color: Colors.black12, child: const Icon(Icons.store, size: 28)),
              const SizedBox(width: 12),
              Column(children: [
                const Text('AGILAPP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('TICKET', style: TextStyle(color: Colors.grey[700]))
              ])
            ]),
            const SizedBox(height: 12),
            if (sale['local_id'] != null) ...[
              Center(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: QrImageView(data: sale['local_id'].toString()),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text('Fecha: ${sale['created_at'] ?? DateTime.now().toIso8601String()}'),
            const SizedBox(height: 8),
            Text('Cliente: ${customer['name'] ?? '-'}'),
            const Divider(),
            // items
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 8),
                itemBuilder: (ctx, i) {
                  final it = items[i];
                  final qty = (it['qty'] as num?)?.toInt() ?? 0;
                  final price = (it['unit_price'] as num?)?.toDouble() ?? 0.0;
                  final subtotal = qty * price;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${it['name'] ?? ''} x$qty')),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(fmt.format(price)),
                        const SizedBox(height: 4),
                        Text(fmt.format(subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
                      ])
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(fmt.format(total), style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.print), label: const Text('Cerrar (Simular impresión)'))
          ]),
        ),
      ),
    );
  }
}
