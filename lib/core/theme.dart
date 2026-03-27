// core/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryBlue   = Color(0xFF4A90E2);
  static const Color primaryPink   = Color(0xFFFF6B9D);
  static const Color bgDark        = Color(0xFF1A1A2E);
  static const Color cardDark      = Color(0xFF25253A);
  static const Color textWhite     = Color(0xFFFFFFFF);
  static const Color textGray      = Color(0xFFA0A0B0);
  static const Color successGreen  = Color(0xFF4CAF50);
  static const Color warnOrange    = Color(0xFFFF9800);
  static const Color errorRed      = Color(0xFFF44336);
  static const Color dividerColor  = Color(0xFF3A3A50);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryPink,
        surface: cardDark,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textWhite,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textWhite,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryBlue, width: 1.5)),
        hintStyle: const TextStyle(color: textGray),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
