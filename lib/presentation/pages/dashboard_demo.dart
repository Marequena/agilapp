import 'package:flutter/material.dart';
// import '../../core/widgets/app_card.dart';
// import '../../core/widgets/app_button.dart'; // not used here
import 'package:provider/provider.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../core/widgets/metro_button.dart';

class DashboardDemoPage extends StatelessWidget {
  const DashboardDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard demo'),
        automaticallyImplyLeading: false, // hide default back button
        leading: IconButton(
          icon: const Icon(Icons.login),
          tooltip: 'Iniciar sesión',
          onPressed: () => Navigator.of(context).pushNamed('/login'),
        ),
        actions: [
          Builder(builder: (ctx) {
            // use Builder to get context inside AppBar for Provider lookup
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
          // Grid of metro buttons that occupy available width
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3,
              children: [
                MetroButton(label: 'Productos', icon: Icons.inventory_2, variant: MetroVariant.primary, size: MetroSize.large, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Clientes', icon: Icons.people, variant: MetroVariant.success, size: MetroSize.medium, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Reportes', icon: Icons.pie_chart, variant: MetroVariant.warning, size: MetroSize.medium, fullWidth: true, onPressed: () {}),
                MetroButton(label: 'Ventas', icon: Icons.sell, variant: MetroVariant.warning, size: MetroSize.large, fullWidth: true, onPressed: () => Navigator.of(context).pushNamed('/sales')),
                MetroButton(label: 'Ajustes', icon: Icons.settings, variant: MetroVariant.primary, size: MetroSize.medium, fullWidth: true, onPressed: () {}),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
