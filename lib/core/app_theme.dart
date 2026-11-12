
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

  static const Color terracotta = Color(0xFFC9794F);
  static const Color terracottaSoft = Color(0xFFFCEBDD);

  static const Color sage = Color(0xFF899A75);
  static const Color sageSoft = Color(0xFFE9EFE3);

  static const Color lavender = Color(0xFF777096);
  static const Color lavenderSoft = Color(0xFFEEEAF5);

  static const Color blue = Color(0xFF5B8291);
  static const Color blueSoft = Color(0xFFE7F0F3);

  static const Color gold = Color(0xFFD9AD6E);
  static const Color rose = Color(0xFFB96D70);
  static const Color roseSoft = Color(0xFFF7E8E8);
}

class AppTheme {
  static ThemeData get light {
    const roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: Brightness.light,
        surface: AppColors.cream,
        secondary: AppColors.terracotta,
        tertiary: AppColors.lavender,
        error: AppColors.rose,
      ),

      fontFamily: null,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AppColors.forest,
          size: 23,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),

      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: AppColors.forestDark,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
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
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: AppColors.forest,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 13,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),

      iconTheme: const IconThemeData(
        color: AppColors.forest,
        size: 22,
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: roundedShape,
        clipBehavior: Clip.antiAlias,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        hintStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
        ),
        labelStyle: const TextStyle(
          color: AppColors.forest,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: AppColors.forest,
        suffixIconColor: AppColors.leaf,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.line,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.forest,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.rose,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.rose,
            width: 1.5,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.line,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          shape: roundedShape,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(0, 48),
          shape: roundedShape,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forest,
          side: const BorderSide(
            color: AppColors.leaf,
            width: 1.2,
          ),
          minimumSize: const Size(0, 48),
          shape: roundedShape,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.forest,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.forest,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.mint,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.mint,
        useIndicator: true,
        minWidth: 76,
        selectedIconTheme: IconThemeData(
          color: AppColors.forest,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.muted,
          size: 22,
        ),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.forest,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.muted,
          fontSize: 11,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.mint,
        disabledColor: AppColors.line,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.forest,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        shape: const StadiumBorder(),
        side: const BorderSide(
          color: AppColors.line,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.forest,
        linearTrackColor: AppColors.mint,
        circularTrackColor: AppColors.mint,
        linearMinHeight: 5,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.forestDark,
        contentTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.forest,
        textColor: AppColors.ink,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
      ),

      splashColor: AppColors.mint,
      highlightColor: AppColors.mint.withValues(alpha: 0.35),
    );
  }
}
