// lib/utils/app_theme.dart
// Extended theme helpers using the Uxintace Rose palette

import 'package:flutter/material.dart';
import 'AppColors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ThemeData builders
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppColors.light);
  static ThemeData dark()  => _build(AppColors.dark);

  static ThemeData _build(AppColorScheme c) {
    return ThemeData(
      useMaterial3: true,
      brightness: c.isDark ? Brightness.dark : Brightness.light,
      fontFamily: 'PlusJakartaSans',

      // ── ColorScheme ───────────────────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness:       c.isDark ? Brightness.dark : Brightness.light,
        primary:          c.primary,
        onPrimary:        c.textOnPrimary,
        primaryContainer: c.primaryLight,
        onPrimaryContainer: c.primaryDark,
        secondary:        c.accent3,
        onSecondary:      c.textOnPrimary,
        secondaryContainer: c.surfaceAlt,
        onSecondaryContainer: c.textPrimary,
        tertiary:         c.accent1,
        onTertiary:       c.textPrimary,
        error:            c.error,
        onError:          c.textOnPrimary,
        errorContainer:   c.errorSurface,
        onErrorContainer: c.error,
        surface:          c.surface,
        onSurface:        c.textPrimary,
        surfaceContainerHighest: c.surfaceMuted,
        outline:          c.border,
        outlineVariant:   c.border.withValues(alpha: 0.5),
      ),

      scaffoldBackgroundColor: c.background,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        shadowColor: c.border.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          fontFamily: 'PlusJakartaSans',
        ),
        iconTheme: IconThemeData(color: c.textPrimary),
      ),

      // ── Bottom Nav Bar ────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:      c.navBar,
        selectedItemColor:    c.navItemActive,
        unselectedItemColor:  c.navItemInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── NavigationBar (Material 3) ────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:      c.navBar,
        indicatorColor:       c.primaryLight,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.navItemActive);
          }
          return IconThemeData(color: c.navItemInactive);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: c.navItemActive,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlusJakartaSans',
            );
          }
          return TextStyle(
            color: c.navItemInactive,
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
          backgroundColor: c.primary,
          foregroundColor: c.textOnPrimary,
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
          foregroundColor: c.primary,
          side: BorderSide(color: c.border, width: 1),
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
          foregroundColor: c.primary,
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
        fillColor: c.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(
          color: c.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          fontFamily: 'PlusJakartaSans',
        ),
        labelStyle: TextStyle(
          color: c.textSecondary,
          fontSize: 13,
          fontFamily: 'PlusJakartaSans',
        ),
        prefixIconColor: c.textMuted,
        suffixIconColor: c.textMuted,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceAlt,
        selectedColor: c.primary,
        disabledColor: c.surfaceMuted,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlusJakartaSans',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 0.5,
        space: 0,
      ),

      // ── Icon ──────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: c.textSecondary),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.textOnPrimary;
          return c.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.primary;
          return c.surfaceMuted;
        }),
      ),

      // ── Snack Bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.isDark ? c.surface : AppColors.plum,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'PlusJakartaSans',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          fontFamily: 'PlusJakartaSans',
        ),
        contentTextStyle: TextStyle(
          color: c.textSecondary,
          fontSize: 13,
          fontFamily: 'PlusJakartaSans',
        ),
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.surfaceMuted,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy DC class — kept for backward compat, delegates to AppColors
// New code should use AppColors.of(context) directly.
// ─────────────────────────────────────────────────────────────────────────────
class DC {
  DC._();

  // Palette raw swatches
  static const Color peach    = AppColors.peach;
  static const Color blush    = AppColors.blush;
  static const Color rose     = AppColors.rose;
  static const Color berry    = AppColors.berry;
  static const Color burgundy = AppColors.burgundy;
  static const Color plum     = AppColors.plum;

  // Light-mode aliases (for legacy usages)
  static const Color p   = AppColors.berry;
  static const Color p2  = AppColors.rose;
  static const Color p3  = Color(0xFFFDE8EE);
  static const Color p4  = AppColors.plum;
  static const Color p5  = AppColors.burgundy;

  static const Color g   = Color(0xFF1D9E75);
  static const Color g2  = Color(0xFFE1F5EE);
  static const Color g3  = Color(0xFF085041);

  static const Color a   = Color(0xFFEF9F27);
  static const Color a2  = Color(0xFFFAEEDA);
  static const Color a3  = Color(0xFF633806);

  static const Color r   = AppColors.rose;
  static const Color r2  = Color(0xFFFDE8EE);

  static const Color gr  = Color(0xFF8A5468);
  static const Color gr2 = Color(0xFFFDE8EE);
  static const Color gr3 = Color(0xFF4C1D3D);

  static const Color textPrimary   = Color(0xFF1F0A12);
  static const Color textSecondary = Color(0xFF7A4057);
  static const Color textTertiary  = Color(0xFFB8809A);

  static const Color border      = Color(0xFFE8C4CF);
  static const Color borderLight = Color(0xFFFDE8EE);

  static const Color bg0 = Colors.white;
  static const Color bg1 = Color(0xFFFFF0F3);
  static const Color bg2 = Color(0xFFFAEBEE);

  static const List<List<Color>> avatarPalette =
      AppColorScheme.avatarPalette;

  static Color avatarBg(int index)   => avatarPalette[index % avatarPalette.length][0];
  static Color avatarText(int index) => avatarPalette[index % avatarPalette.length][1];
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
        color: bg ?? DC.p3,
        borderRadius: BorderRadius.circular(radius),
      );

  static BoxDecoration gradient({double radius = 16}) => BoxDecoration(
        gradient: AppColors.light.primaryGradient,
        borderRadius: BorderRadius.circular(radius),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Text styles
// ─────────────────────────────────────────────────────────────────────────────
class DCText {
  DCText._();

  static const h1 = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w800,
      color: DC.textPrimary, letterSpacing: -0.8, height: 1.1);
  static const h2 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w800,
      color: DC.textPrimary, letterSpacing: -0.5);
  static const h3 = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w700,
      color: DC.textPrimary, letterSpacing: -0.3);
  static const body = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w400,
      color: DC.textPrimary, height: 1.5);
  static const caption = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: DC.textSecondary);
  static const label = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w700,
      color: DC.textSecondary, letterSpacing: 0.5);
  static const micro = TextStyle(
      fontSize: 9, fontWeight: FontWeight.w700,
      color: DC.textSecondary, letterSpacing: 0.3);
  static const tag = TextStyle(
      fontSize: 9, fontWeight: FontWeight.w700,
      color: DC.p4, letterSpacing: 0.2);
}