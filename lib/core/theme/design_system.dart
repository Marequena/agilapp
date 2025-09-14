import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignColors {
  static const primary = Color(0xFF0EA5A4); // Teal profundo
  static const primaryVariant = Color(0xFF0B9A94);
  static const secondary = Color(0xFFFF6B6B); // Coral
  static const background = Color(0xFFF7F8FB);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const border = Color(0xFFE6E9F2);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);

  // Dark theme variants
  static const backgroundDark = Color(0xFF0F172A);
  static const surfaceDark = Color(0xFF0B1220);
  static const textOnDark = Color(0xFFE6EEF6);

  // Tokens
  static const elevation1 = 2.0;
  static const elevation2 = 6.0;
  static const cornerRadius = 10.0;
}

class AppTypography {
  static TextTheme textTheme = GoogleFonts.interTextTheme(const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ));
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignColors.primary,
        brightness: Brightness.light,
        primary: DesignColors.primary,
        secondary: DesignColors.secondary,
        error: DesignColors.error,
  surface: DesignColors.surface,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: DesignColors.background,
      cardColor: DesignColors.surface,
      dividerColor: DesignColors.border,
      textTheme: AppTypography.textTheme.apply(bodyColor: DesignColors.textPrimary, displayColor: DesignColors.textPrimary),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: DesignColors.textPrimary),
        titleTextStyle: TextStyle(color: DesignColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.textPrimary,
          side: BorderSide(color: DesignColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: DesignColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: DesignColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: DesignColors.primary)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: DesignColors.error)),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: DesignColors.primary, brightness: Brightness.dark),
      scaffoldBackgroundColor: DesignColors.backgroundDark,
      cardColor: DesignColors.surfaceDark,
      dividerColor: Colors.grey.shade800,
      textTheme: AppTypography.textTheme.apply(bodyColor: DesignColors.textOnDark, displayColor: DesignColors.textOnDark),
      appBarTheme: const AppBarTheme(backgroundColor: DesignColors.surfaceDark, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignColors.cornerRadius)),
          elevation: DesignColors.elevation1,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(filled: true, fillColor: Color(0xFF0B1220)),
    );
  }
}
