import 'package:flutter/material.dart';

class ColorTokens {
  // Primary swatch derived from DesignColors.primary
  static const int _primaryValue = 0xFF0EA5A4;
  static const MaterialColor primarySwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFEAF9F9),
      100: Color(0xFFCFF3F2),
      200: Color(0xFFB2ECEB),
      300: Color(0xFF93E4E2),
      400: Color(0xFF6FE0DB),
      500: Color(0xFF0EA5A4),
      600: Color(0xFF0DA09C),
      700: Color(0xFF0B918B),
      800: Color(0xFF097E78),
      900: Color(0xFF055F57),
    },
  );

  // Secondary swatch (coral)
  static const int _secondaryValue = 0xFFFF6B6B;
  static const MaterialColor secondarySwatch = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color(0xFFFFEFEF),
      100: Color(0xFFFFDDDD),
      200: Color(0xFFFFCACA),
      300: Color(0xFFFFB8B8),
      400: Color(0xFFFF9F9F),
      500: Color(0xFFFF6B6B),
      600: Color(0xFFFF6161),
      700: Color(0xFFFF5252),
      800: Color(0xFFFF4242),
      900: Color(0xFFE32E2E),
    },
  );

  // Convenience accessors for plain Colors
  static const Color primary = Color(_primaryValue);
  static const Color secondary = Color(_secondaryValue);

  // Small helper to build a ColorScheme seed from primary color
  static ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(seedColor: primary, brightness: brightness);
  }
}
