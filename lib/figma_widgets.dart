import 'package:flutter/material.dart';

class InteractiveFigmaScreen extends StatelessWidget {
  final String title;
  final String assetPath;
  const InteractiveFigmaScreen({super.key, required this.title, required this.assetPath});

  void _onTap(BuildContext context, Offset pos) {
    // Simple debug action: show a snackbar with coordinates
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tap at: ${pos.dx.toStringAsFixed(0)}, ${pos.dy.toStringAsFixed(0)}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GestureDetector(
        onTapDown: (details) => _onTap(context, details.localPosition),
        child: Center(
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class FigmaAssets {
  static Future<void> precacheAll(BuildContext context) async {
    final List<String> assets = [
      'assets/figma/adjuntos.png',
      'assets/figma/adjuntos_1.png',
      'assets/figma/aprobar_sala.png',
      'assets/figma/aprobar_vehiculo.png',
      'assets/figma/calendario.png',
      'assets/figma/calendario_1.png',
      'assets/figma/detalle_pedido_cerrado.png',
      'assets/figma/detalle_pedido_delay.png',
      'assets/figma/detalle_pedido_delay_1.png',
      'assets/figma/detalle_pedido_delay_2.png',
      'assets/figma/detalle_pedido_delay_3.png',
      'assets/figma/detalle_pedido_delay_4.png',
      'assets/figma/detalle_pedido_delay_5.png',
      'assets/figma/detalle_pedido_en_entrega.png',
      'assets/figma/detalle_pedido_no_recibido.png',
      'assets/figma/detalle_pedido_transporte.png',
      'assets/figma/detalle_pedido_transporte_1.png',
      'assets/figma/detalle_producto.png',
      'assets/figma/detalle_solicitud_ant.png',
      'assets/figma/detalle_solicitud_pago.png',
      'assets/figma/detalle_solicitud_sala.png',
      'assets/figma/detalle_solicitud_vacaciones.png',
      'assets/figma/detalle_solicitud_vehiculo.png',
      'assets/figma/detalle_tarea.png',
      'assets/figma/detalle_tarea_1.png',
      'assets/figma/detalle_tarea_2.png',
      'assets/figma/formulario_vacaciones.png',
      'assets/figma/historial_asistencia.png',
      'assets/figma/iconos_estado.png',
      'assets/figma/iconos_estado_1.png',
      'assets/figma/iconos_estado_2.png',
      'assets/figma/iconos_estado_3.png',
      'assets/figma/iconos_estado_4.png',
      'assets/figma/inicio_1.png',
      'assets/figma/inicio_2.png',
      'assets/figma/inicio_notificaciones.png',
      'assets/figma/iphone_13_1.png',
      'assets/figma/iphone_13_2.png',
      'assets/figma/like_notch.png',
      'assets/figma/like_notch_1.png',
      'assets/figma/like_notch_2.png',
      'assets/figma/like_notch_3.png',
      'assets/figma/like_notch_4.png',
      'assets/figma/lista_solicitudes_ant.png',
      'assets/figma/lista_solicitudes_pago.png',
      'assets/figma/login.png',
      'assets/figma/logo_google.png',
      'assets/figma/mapa_envio.png',
      'assets/figma/mis_pedidos.png',
      'assets/figma/notificaciones.png',
      'assets/figma/nueva_tarea.png',
      'assets/figma/nueva_tarea_1.png',
      'assets/figma/pedidos_entregados.png',
      'assets/figma/pedidos_pendientes.png',
      'assets/figma/pedidos_retrasados.png',
      'assets/figma/pedidos_retrasados_1.png',
      'assets/figma/registro_sala.png',
      'assets/figma/registro_vacaciones.png',
      'assets/figma/registro_vacaciones_1.png',
      'assets/figma/registro_vacaciones_2.png',
      'assets/figma/registro_vehiculo.png',
      'assets/figma/registro_vehiculo_1.png',
      'assets/figma/registro_vehiculo_2.png',
      'assets/figma/revisar_solicitudes.png',
      'assets/figma/sin_pedidos.png',
      'assets/figma/sin_pedidos_entrega.png',
      'assets/figma/tareas.png',
      'assets/figma/tareas_escritorio.png',
      'assets/figma/varios.png'
    ];
    for (final a in assets) {
      try {
        await precacheImage(AssetImage(a), context);
      } catch (_) {}
    }
  }
