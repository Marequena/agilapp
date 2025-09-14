import 'package:flutter/material.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';

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
            AppButton(label: 'Nuevo', onPressed: () {}),
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
