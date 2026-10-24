// lib/utils/app_theme.dart
// Simplified White & Black (monochrome) theme

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(isDark: false);
  static ThemeData dark() => _build(isDark: true);

  static ThemeData _build({required bool isDark}) {
    final Color background = isDark ? Colors.black : Colors.white;
    final Color surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final Color textPrimary = isDark ? Colors.white : Colors.black;
    final Color textSecondary = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C6C6E);
    final Color textMuted = isDark ? const Color(0xFF636366) : const Color(0xFF9E9E9E);
    final Color border = isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA);
    final Color borderFocus = isDark ? Colors.white : Colors.black;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: 'PlusJakartaSans',

      // ── ColorScheme ───────────────────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? Colors.white : Colors.black,
        onPrimary: isDark ? Colors.black : Colors.white,
        primaryContainer: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
        onPrimaryContainer: textPrimary,
        secondary: const Color(0xFF8E8E93),
        onSecondary: textPrimary,
        secondaryContainer: surface,
        onSecondaryContainer: textPrimary,
        tertiary: textSecondary,
        onTertiary: textPrimary,
        error: const Color(0xFFFF3B30),
        onError: Colors.white,
        errorContainer: isDark ? const Color(0xFF3A1A1A) : const Color(0xFFFFE5E5),
        onErrorContainer: const Color(0xFFFF3B30),
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF6F6F8),
        outline: border,
        outlineVariant: border.withValues(alpha: 0.5),
      ),

      scaffoldBackgroundColor: background,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        shadowColor: border.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          fontFamily: 'PlusJakartaSans',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // ── Bottom Nav Bar ────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: textPrimary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── NavigationBar (Material 3) ────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: textPrimary);
          }
          return IconThemeData(color: textMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlusJakartaSans',
            );
          }
          return TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: 'PlusJakartaSans',
          );
        }),
        surfaceTintColor: Colors.transparent,
      ),

      // ── Elevated Button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: textPrimary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),

      // ── Outlined Button ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textPrimary,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),

      // ── Input ─────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(
          color: textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          fontFamily: 'PlusJakartaSans',
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontFamily: 'PlusJakartaSans',
        ),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
        selectedColor: textPrimary,
        disabledColor: border,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlusJakartaSans',
          color: textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 0.5,
        space: 0,
      ),

      // ── Icon ──────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: textSecondary),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return isDark ? Colors.black : Colors.white;
          return textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return textPrimary;
          return border;
        }),
      ),

      // ── Snack Bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? surface : Colors.black,
        contentTextStyle: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'PlusJakartaSans',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          fontFamily: 'PlusJakartaSans',
        ),
        contentTextStyle: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontFamily: 'PlusJakartaSans',
        ),
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: textPrimary,
        linearTrackColor: border,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy DC class — Updated for white/black
// ─────────────────────────────────────────────────────────────────────────────
class DC {
  DC._();

  static const Color primary = Colors.black;
  static const Color onPrimary = Colors.white;

  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF6C6C6E);
  static const Color textMuted = Color(0xFF9E9E9E);

  static const Color border = Color(0xFFE5E5EA);
  static const Color borderLight = Color(0xFFF2F2F7);

  static const Color bg0 = Colors.white;
  static const Color bg1 = Color(0xFFF6F6F8);
  static const Color bg2 = Color(0xFFF2F2F7);

  // Dark mode variants
  static Color get textPrimaryDark => Colors.white;
  static Color get textSecondaryDark => const Color(0xFF8E8E93);
  static Color get surfaceDark => const Color(0xFF1C1C1E);
  static Color get borderDark => const Color(0xFF38383A);



  static Color avatarBg(int index)   => bg0;
  static Color avatarText(int index) => textPrimary;
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable decorations
// ─────────────────────────────────────────────────────────────────────────────
class DCDecoration {
  DCDecoration._();

  static BoxDecoration card({
    Color? color,
    double radius = 16,
    Color? borderColor,
  }) =>
      BoxDecoration(
        color: color ?? DC.bg0,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? DC.border, width: 0.5),
      );

  static BoxDecoration pill({Color? bg, double radius = 20}) => BoxDecoration(
    color: bg ?? DC.bg1,
    borderRadius: BorderRadius.circular(radius),
  );

  static BoxDecoration gradient({double radius = 16}) => BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(radius),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Text styles (unchanged except colors)
// ─────────────────────────────────────────────────────────────────────────────
class DCText {
  DCText._();

  static const h1 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: DC.textPrimary,
      letterSpacing: -0.8,
      height: 1.1);
  static const h2 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: DC.textPrimary,
      letterSpacing: -0.5);
  static const h3 = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: DC.textPrimary,
      letterSpacing: -0.3);
  static const body = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: DC.textPrimary,
      height: 1.5);
  static const caption = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: DC.textSecondary);
  static const label = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: DC.textSecondary,
      letterSpacing: 0.5);
  static const micro = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: DC.textSecondary,
      letterSpacing: 0.3);
  static const tag = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: 0.2);
}