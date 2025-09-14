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
              tooltip: 'Cerrar sesi\u00f3n',
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
      // Background image + content stack
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: try to load an asset image `assets/background.jpg`.
          // If not provided, the Image.asset will throw at runtime; therefore we use
          // Image.asset inside a try/catch by loading with AssetImage and a fallback
          // gradient container behind it.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE8F1FF), Color(0xFFF7F9FC)],
              ),
            ),
          ),
          // Decorative composited background similar to the sample photo
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: CustomPaint(
                painter: _MetroBackgroundPainter(),
              ),
            ),
          ),
          // Foreground content with padding
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Accesos r\u00e1pidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
        ],
      ),
    );
  }
}

class _MetroBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // base gradient
    final rect = Offset.zero & size;
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE8F1FF), Color(0xFFF7F9FC)],
      ).createShader(rect)
      ..isAntiAlias = true;
    canvas.drawRect(rect, basePaint);

    // decorative colored blocks (semi-transparent)
    void drawBlock(double leftPct, double topPct, double wPct, double hPct, Color color, double rotation) {
      final w = size.width * wPct;
      final h = size.height * hPct;
      final cx = size.width * leftPct + w / 2;
      final cy = size.height * topPct + h / 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(rotation);
      final r = Rect.fromCenter(center: Offset(0, 0), width: w, height: h);
  final p = Paint()..color = color.withAlpha((0.22 * 255).round());
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(12)), p);
      canvas.restore();
    }

    drawBlock(0.05, 0.05, 0.45, 0.35, const Color(0xFF4DB6AC), -0.08); // teal
    drawBlock(0.55, 0.02, 0.38, 0.28, const Color(0xFF7E57C2), 0.03); // purple
    drawBlock(0.1, 0.55, 0.6, 0.4, const Color(0xFFFFC107), -0.05); // amber
    drawBlock(0.6, 0.45, 0.35, 0.45, const Color(0xFF29B6F6), 0.06); // cyan

    // subtle vignette overlay
    final vignette = Paint()
      ..shader = RadialGradient(colors: [Colors.transparent, Colors.black.withAlpha((0.04 * 255).round())], stops: const [0.7, 1.0]).createShader(rect)
      ..blendMode = BlendMode.multiply;
    canvas.drawRect(rect, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
