import 'package:flutter/material.dart';
import '../../core/widgets/app_card.dart';
// import '../../core/widgets/app_button.dart'; // not used here
import '../../core/widgets/metro_button.dart';

class DashboardDemoPage extends StatelessWidget {
  const DashboardDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => 'Cliente ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Clientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 56,
              child: Row(children: [
                MetroButton(label: 'Ventas', icon: Icons.point_of_sale, variant: MetroVariant.primary, onPressed: () {}),
                const SizedBox(width: 8),
                MetroButton(label: 'Clientes', icon: Icons.people, variant: MetroVariant.success, onPressed: () {}),
                const SizedBox(width: 8),
                MetroButton(label: 'Reportes', icon: Icons.pie_chart, variant: MetroVariant.warning, onPressed: () {}),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                return AppCard(
                  child: ListTile(
                    title: Text(items[idx]),
                    subtitle: const Text('Activo'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                    ]),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
