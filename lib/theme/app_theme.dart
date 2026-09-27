import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDim = Color(0xFFA8842A);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textDim = Color(0xFF6E6E6E);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE53935);

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: gold,
      onPrimary: Colors.black,
      secondary: goldDim,
      onSecondary: Colors.black,
      surface: surface,
      onSurface: textPrimary,
      error: danger,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: gold,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: gold,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: gold,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: surfaceLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: surfaceLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 2),
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: gold,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
      bodySmall: TextStyle(color: textSecondary, fontSize: 12),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: gold,
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      actionTextColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
