import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agilapp/core/accessibility/contrast_utils.dart';
import 'package:agilapp/core/theme/design_system.dart';

void main() {
  test('textPrimary on background should meet WCAG AA', () {
    final ratio = ContrastUtils.contrastRatio(DesignColors.textPrimary, DesignColors.background);
    expect(ratio >= 4.5, isTrue, reason: 'Contrast ratio was $ratio');
  });

  test('onPrimary on primary should meet WCAG AA for large text', () {
    final ratio = ContrastUtils.contrastRatio(DesignColors.primary, Colors.white);
    // For large text requirement is 3.0; we check >=3.0
    expect(ratio >= 3.0, isTrue, reason: 'Contrast ratio was $ratio');
  });
}
