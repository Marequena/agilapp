import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_card.dart';

class DesignDemoPage extends StatelessWidget {
  const DesignDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design system demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Colors', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            _colorBox('Primary', DesignColors.primary),
            _colorBox('Secondary', DesignColors.secondary),
            _colorBox('Success', DesignColors.success),
            _colorBox('Warning', DesignColors.warning),
            _colorBox('Error', DesignColors.error),
          ]),
          const SizedBox(height: 20),
          Text('Buttons', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Row(children: [
            AppButton(label: 'Primary', onPressed: () {}),
            const SizedBox(width: 12),
            AppButton(label: 'Outline', outline: true, onPressed: () {}),
          ]),
          const SizedBox(height: 20),
          Text('Inputs', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          const AppInput(label: 'Nombre'),
          const SizedBox(height: 20),
          Text('Cards', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          const AppCard(child: Text('Contenido dentro de una card')),
        ]),
      ),
    );
  }

  Widget _colorBox(String name, Color color) => Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(_colorHex(color), style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      );
}

String _colorHex(Color c) {
  // Return #RRGGBB using non-deprecated component accessors
  final r = ((c.r) * 255.0).round() & 0xff;
  final g = ((c.g) * 255.0).round() & 0xff;
  final b = ((c.b) * 255.0).round() & 0xff;
  return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
}
