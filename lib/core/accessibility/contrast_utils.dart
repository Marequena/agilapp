import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Utilities for WCAG contrast calculations
class ContrastUtils {
  /// Relative luminance for color (0..1)
  static double luminance(Color c) {
    double srgb(double channel) {
      final v = channel / 255.0;
      return v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    }

    final r = (c.r * 255.0).round().toDouble();
    final g = (c.g * 255.0).round().toDouble();
    final b = (c.b * 255.0).round().toDouble();
    return 0.2126 * srgb(r) + 0.7152 * srgb(g) + 0.0722 * srgb(b);
  }

  /// Contrast ratio (1..21)
  static double contrastRatio(Color a, Color b) {
    final L1 = luminance(a);
    final L2 = luminance(b);
    final high = L1 > L2 ? L1 : L2;
    final low = L1 > L2 ? L2 : L1;
    return (high + 0.05) / (low + 0.05);
  }
}
