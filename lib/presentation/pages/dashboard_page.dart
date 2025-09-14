import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../core/widgets/widgets.dart';
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
                final labels = ['Ventas', 'Clientes', 'Reportes', 'Inventario', 'Ajustes', 'Usuarios', 'Pagos', 'Calendario', 'Notificaciones', 'Soporte'];
                final icons = [
                  Icons.point_of_sale,
                  Icons.people,
                  Icons.bar_chart,
                  Icons.inventory,
                  Icons.settings,
                  Icons.person_add,
                  Icons.payment,
                  Icons.calendar_today,
                  Icons.notifications,
                  Icons.headset_mic,
                ];
                final colors = [
                  Colors.teal.shade400,
                  Colors.deepPurple.shade400,
                  Colors.amber.shade600,
                  Colors.cyan.shade400,
                  Colors.indigo.shade600,
                  Colors.pink.shade400,
                  Colors.deepOrange.shade400,
                  Colors.lightGreen.shade500,
                  Colors.blueAccent.shade700,
                  Colors.deepPurpleAccent.shade400,
                ];

                // varied heights to mimic Metro live tile sizes
                final heights = [180.0, 120.0, 140.0, 160.0, 100.0, 140.0, 120.0, 160.0, 130.0, 150.0];

                return MetroTile(label: labels[index], icon: icons[index], color: colors[index], height: heights[index], onTap: () {});
              },
            ),
          ),
        ]),
      ),
    );
  }
}
