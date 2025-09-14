import 'package:flutter/material.dart';
import 'figma_screens.dart';

class FigmaIndex extends StatelessWidget {
  const FigmaIndex({super.key});
  @override
  Widget build(BuildContext context) {
    final routes = figmaRoutes.keys.toList();
    routes.sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Figma Index')),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (c,i) {
          final r = routes[i];
          return ListTile(
            title: Text(r),
            onTap: () => Navigator.pushNamed(context, r),
          );
        },
      ),
    );
  }
}
