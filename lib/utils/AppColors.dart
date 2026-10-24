import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DevCollab Palette — Monochrome (White & Black)
/// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Core Monochrome Colors ───────────────────────────────────────────────
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  static const Color gray900 = Color(0xFF111111); // near-black
  static const Color gray800 = Color(0xFF1F1F1F);
  static const Color gray700 = Color(0xFF2C2C2C);
  static const Color gray600 = Color(0xFF3A3A3C);
  static const Color gray500 = Color(0xFF6C6C70);
  static const Color gray400 = Color(0xFF8E8E93);
  static const Color gray300 = Color(0xFFBEBEBF);
  static const Color gray200 = Color(0xFFE5E5EA);
  static const Color gray100 = Color(0xFFF2F2F7);
  static const Color gray50  = Color(0xFFFAFAFC);

  // ── Backward-compat aliases ───────────────────────────────────────────────
  static const Color primary      = black;
  static const Color primaryLight = gray100;
  static const Color textDark     = black;
  static const Color textLight    = white;
  static const Color error        = Color(0xFFFF3B30); // keep red for errors

  // ── Light Theme ───────────────────────────────────────────────────────────
  static const AppColorScheme light = AppColorScheme(
    // Brand
    primary:       black,
    primaryLight:  gray100,
    primaryDark:   gray900,

    // Accent tiers (grays)
    accent1: gray700,
    accent2: gray600,
    accent3: gray500,

    // Backgrounds
    background:    white,
    surface:       white,
    surfaceAlt:    gray50,
    surfaceMuted:  gray100,

    // Text
    textPrimary:   black,
    textSecondary: gray700,
    textMuted:     gray500,
    textOnPrimary: white,

    // Border
    border:        gray200,
    borderFocus:   black,

    // Status
    success: Color(0xFF1D9E75),
    warning: Color(0xFFEF9F27),
    error:   Color(0xFFFF3B30),
    info:    Color(0xFF5B6EF6),

    // Status surfaces
    successSurface: Color(0xFFE1F5EE),
    warningSurface: Color(0xFFFAEEDA),
    errorSurface:   Color(0xFFFFE5E5),
    infoSurface:    Color(0xFFEEEDFE),

    // Gradient stops (black to dark gray)
    gradientStart: gray900,
    gradientEnd:   black,

    // Nav bar
    navBar:         white,
    navBarBorder:   gray200,
    navItemActive:  black,
    navItemInactive: gray500,

    isDark: false,
  );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static const AppColorScheme dark = AppColorScheme(
    // Brand
    primary:       white,
    primaryLight:  gray800,
    primaryDark:   white,

    // Accent tiers
    accent1: gray400,
    accent2: gray500,
    accent3: gray600,

    // Backgrounds
    background:   gray900,
    surface:      gray800,
    surfaceAlt:   gray700,
    surfaceMuted: gray600,

    // Text
    textPrimary:   white,
    textSecondary: gray300,
    textMuted:     gray400,
    textOnPrimary: black,

    // Border
    border:      gray600,
    borderFocus: white,

    // Status
    success: Color(0xFF3DD68C),
    warning: Color(0xFFFFBE57),
    error:   Color(0xFFFF6B80),
    info:    Color(0xFF8B9FFF),

    // Status surfaces
    successSurface: Color(0xFF0D3322),
    warningSurface: Color(0xFF3D2800),
    errorSurface:   Color(0xFF4C1020),
    infoSurface:    Color(0xFF1A1854),

    // Gradient stops
    gradientStart: gray900,
    gradientEnd:   black,

    // Nav bar
    navBar:          gray800,
    navBarBorder:    gray600,
    navItemActive:   white,
    navItemInactive: gray400,

    isDark: true,
  );

  // ── Helper: resolve based on BuildContext brightness ──────────────────────
  static AppColorScheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

/// Immutable color scheme bag consumed by all widgets.
@immutable
class AppColorScheme {
  const AppColorScheme({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.border,
    required this.borderFocus,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.successSurface,
    required this.warningSurface,
    required this.errorSurface,
    required this.infoSurface,
    required this.gradientStart,
    required this.gradientEnd,
    required this.navBar,
    required this.navBarBorder,
    required this.navItemActive,
    required this.navItemInactive,
    required this.isDark,
  });

  // Brand
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  // Accents
  final Color accent1;
  final Color accent2;
  final Color accent3;

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceMuted;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;

  // Borders
  final Color border;
  final Color borderFocus;

  // Status
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Status surfaces
  final Color successSurface;
  final Color warningSurface;
  final Color errorSurface;
  final Color infoSurface;

  // Gradient
  final Color gradientStart;
  final Color gradientEnd;

  LinearGradient get primaryGradient => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Nav bar
  final Color navBar;
  final Color navBarBorder;
  final Color navItemActive;
  final Color navItemInactive;

  final bool isDark;

  // ── Avatar palette (monochrome) ───────────────────────────────────────────


}