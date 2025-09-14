import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../core/widgets/metro_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, // hide default back button
        actions: [
          Builder(builder: (ctx) {
            return IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () async {
                try {
                  final controller = Provider.of<AuthController?>(ctx, listen: false);
                  if (controller != null) {
                    await controller.logout();
                  }
                } catch (_) {}
                Navigator.of(ctx).pushReplacementNamed('/login');
              },
            );
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Accesos rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3,
              children: [
                MetroButton(label: 'Ventas', icon: Icons.point_of_sale, variant: MetroVariant.primary, size: MetroSize.large, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Clientes', icon: Icons.people, variant: MetroVariant.success, size: MetroSize.medium, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Reportes', icon: Icons.pie_chart, variant: MetroVariant.warning, size: MetroSize.medium, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Inventario', icon: Icons.inventory, variant: MetroVariant.neutral, size: MetroSize.large, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Ajustes', icon: Icons.settings, variant: MetroVariant.primary, size: MetroSize.small, fullWidth: true, onPressed: () {}),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
