// Placeholder generated file for Figma assets

import 'package:flutter/widgets.dart';

class FigmaScreens {
  static const Map<String, String> assets = {
    // Populate by running scripts/figma_fetch.py --generate-flutter
  };

  static Widget byName(String name) {
    final p = assets[name];
    if (p == null) return const SizedBox.shrink();
    return Image.asset(p);
  }
}
