import 'package:flutter/material.dart';

class AppColors {
  static const Color forest = Color(0xFF24513F);
  static const Color forestDark = Color(0xFF17392D);
  static const Color leaf = Color(0xFF6B9478);

  static const Color mint = Color(0xFFE6F0E8);
  static const Color cream = Color(0xFFF7F7F1);
  static const Color white = Color(0xFFFFFFFF);

  static const Color ink = Color(0xFF1F2B25);
  static const Color muted = Color(0xFF748078);

  static const Color orange = Color(0xFFD88A52);
  static const Color line = Color(0xFFE5EAE4);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: Brightness.light,
        surface: AppColors.cream,
      ),

      scaffoldBackgroundColor: AppColors.cream,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 29,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),

        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 23,
          fontWeight: FontWeight.w800,
        ),

        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),

        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),

        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 15, height: 1.5),

        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 13,
          height: 1.4,
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.line),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
