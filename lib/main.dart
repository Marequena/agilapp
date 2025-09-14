import 'package:flutter/material.dart';
import 'figma_widgets.dart';
import 'figma_index.dart';

void main() {
  runApp(const AgilApp());
}

class AgilApp extends StatefulWidget {
  const AgilApp({super.key});

  @override
  State<AgilApp> createState() => _AgilAppState();
}

class _AgilAppState extends State<AgilApp> {
  @override
  void initState() {
    super.initState();
    // Pre-cache figma assets after first frame so images are ready when screens are opened.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FigmaAssets.precacheAll(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgilApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FigmaIndex(),
    );
  }
}
