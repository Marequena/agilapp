import 'package:flutter/material.dart';
import 'figma_screens.dart';

class FigmaGallery extends StatefulWidget {
  const FigmaGallery({super.key});
  @override
  State<FigmaGallery> createState() => _FigmaGalleryState();
}

class _FigmaGalleryState extends State<FigmaGallery> {
  String filter = '';
  late final List<String> routes;

  @override
  void initState() {
    super.initState();
    routes = figmaRoutes.keys.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = routes.where((r) => r.contains(filter)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Figma Gallery')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar...'),
              onChanged: (v) => setState(() => filter = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: filtered.length,
              itemBuilder: (c,i){
                final r = filtered[i];
                // We can't easily get the asset path from the builder; show route text as placeholder
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, r),
                  child: Card(child: Center(child: Text(r))),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
