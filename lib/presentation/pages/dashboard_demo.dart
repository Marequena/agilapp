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
          // Grid/wrap of metro buttons for system actions
          Wrap(spacing: 12, runSpacing: 12, children: [
            MetroButton(label: 'Ventas', icon: Icons.point_of_sale, variant: MetroVariant.primary, onPressed: () {}),
            MetroButton(label: 'Clientes', icon: Icons.people, variant: MetroVariant.success, onPressed: () {}),
            MetroButton(label: 'Reportes', icon: Icons.pie_chart, variant: MetroVariant.warning, onPressed: () {}),
            MetroButton(label: 'Inventario', icon: Icons.inventory, variant: MetroVariant.neutral, onPressed: () {}),
            MetroButton(label: 'Ajustes', icon: Icons.settings, variant: MetroVariant.primary, onPressed: () {}),
          ]),
        ]),
      ),
    );
  }
}
