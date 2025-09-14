import 'package:flutter/material.dart';

/// Returns either white or near-black depending on which provides better contrast
/// against [background]. Uses a simple luminance threshold for performance.
Color highContrastColor(Color background) {
  // relative luminance per WCAG
  final l = background.computeLuminance();
  // threshold tuned: below 0.5 -> white, else dark text
  return l < 0.5 ? Colors.white : Colors.black87;
}
