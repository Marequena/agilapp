import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../core/widgets/metro_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: 10,
              itemBuilder: (context, index) {
                // define varied sizes and variants for visual variety
                final variants = [
                  MetroVariant.primary,
                  MetroVariant.success,
                  MetroVariant.warning,
                  MetroVariant.danger,
                  MetroVariant.neutral,
                ];
                final sizes = [MetroSize.large, MetroSize.medium, MetroSize.small];
                final v = variants[index % variants.length];
                final s = sizes[index % sizes.length];
                final labels = ['Ventas', 'Clientes', 'Reportes', 'Inventario', 'Ajustes', 'Usuarios', 'Pagos', 'Calendario', 'Notificaciones', 'Soporte'];
                return MetroButton(label: labels[index], icon: Icons.circle, variant: v, size: s, fullWidth: true, onPressed: () {});
              },
            ),
          ),
        ]),
      ),
    );
  }
}
