import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DevCollab Palette — Uxintace Rose Collection
///
/// Raw swatches (palette order, light → dark):
///   peach      #FFBB94
///   blush      #FB9590
///   rose       #DC586D
///   berry      #A33757  ← primary brand
///   burgundy   #852E4E
///   plum       #4C1D3D
/// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Raw palette swatches ──────────────────────────────────────────────────
  static const Color peach    = Color(0xFFFFBB94);
  static const Color blush    = Color(0xFFFB9590);
  static const Color rose     = Color(0xFFDC586D);
  static const Color berry    = Color(0xFFA33757); // ← primary brand
  static const Color burgundy = Color(0xFF852E4E);
  static const Color plum     = Color(0xFF4C1D3D);

  // ── Backward-compat aliases (used in login_screen, splash, etc.) ──────────
  static const Color primary      = berry;
  static const Color primaryLight = Color(0xFFFDE8EE);
  static const Color textDark     = Color(0xFF1F0A12);
  static const Color textLight    = Color(0xFF7A4057);
  static const Color error        = rose;

  // ── Light Theme ───────────────────────────────────────────────────────────
  static const AppColorScheme light = AppColorScheme(
    // Brand
    primary:       berry,
    primaryLight:  Color(0xFFFDE8EE), // very light rose tint
    primaryDark:   plum,

    // Accent tiers
    accent1: peach,
    accent2: blush,
    accent3: rose,

    // Backgrounds
    background:    Color(0xFFFFFBFC), // near-white with a blush warmth
    surface:       Colors.white,
    surfaceAlt:    Color(0xFFFFF0F3), // cards / chips
    surfaceMuted:  Color(0xFFFAEBEE), // subtle dividers, tags bg

    // Text
    textPrimary:   Color(0xFF1F0A12),   // near-black plum
    textSecondary: Color(0xFF7A4057),   // mid-tone rose
    textMuted:     Color(0xFFB8809A),   // placeholder / hints
    textOnPrimary: Colors.white,

    // Border
    border:        Color(0xFFE8C4CF),
    borderFocus:   berry,

    // Status
    success: Color(0xFF1D9E75),
    warning: Color(0xFFEF9F27),
    error:   Color(0xFFDC586D), // rose-red
    info:    Color(0xFF5B6EF6),

    // Status surfaces
    successSurface: Color(0xFFE1F5EE),
    warningSurface: Color(0xFFFAEEDA),
    errorSurface:   Color(0xFFFDE8EE),
    infoSurface:    Color(0xFFEEEDFE),

    // Gradient stops for hero areas
    gradientStart: Color(0xFFFFBB94),
    gradientEnd:   Color(0xFFA33757),

    // Nav bar
    navBar:         Colors.white,
    navBarBorder:   Color(0xFFE8C4CF),
    navItemActive:  berry,
    navItemInactive: Color(0xFFB8809A),

    isDark: false,
  );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static const AppColorScheme dark = AppColorScheme(
    // Brand
    primary:       Color(0xFFDC586D), // rose is the primary in dark (pops nicely)
    primaryLight:  Color(0xFF5A1B2F), // dark tinted bg for chips/badges
    primaryDark:   peach,             // peach as highlight on dark

    // Accent tiers
    accent1: Color(0xFF4C1D3D),  // plum
    accent2: Color(0xFF852E4E),  // burgundy
    accent3: Color(0xFFA33757),  // berry

    // Backgrounds
    background:   Color(0xFF1A0A10),  // very dark plum-black
    surface:      Color(0xFF2B1220),  // dark surface cards
    surfaceAlt:   Color(0xFF3C1B2A),  // elevated surfaces
    surfaceMuted: Color(0xFF4C253A),  // chips / tags

    // Text
    textPrimary:   Color(0xFFFDE8EE), // near-white rose tint
    textSecondary: Color(0xFFD4829A), // light rose
    textMuted:     Color(0xFF8A5468), // muted
    textOnPrimary: Colors.white,

    // Border
    border:      Color(0xFF5A2A3D),
    borderFocus: Color(0xFFDC586D),

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

    // Gradient stops for hero areas
    gradientStart: Color(0xFF4C1D3D),
    gradientEnd:   Color(0xFF852E4E),

    // Nav bar
    navBar:          Color(0xFF2B1220),
    navBarBorder:    Color(0xFF5A2A3D),
    navItemActive:   Color(0xFFDC586D),
    navItemInactive: Color(0xFF8A5468),

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

  // ── Avatar palette (maps colorIndex → [bg, text]) ───────────────────────
  static const List<List<Color>> avatarPalette = [
    [Color(0xFFFDE8EE), Color(0xFF4C1D3D)], // rose-blush
    [Color(0xFFFFBB94), Color(0xFF4C1D3D)], // peach
    [Color(0xFFFB9590), Color(0xFF4C1D3D)], // blush
    [Color(0xFFE1F5EE), Color(0xFF085041)], // green
    [Color(0xFFFAEEDA), Color(0xFF633806)], // amber
    [Color(0xFFEEEDFE), Color(0xFF26215C)], // purple
  ];

  Color avatarBg(int index)   => avatarPalette[index % avatarPalette.length][0];
  Color avatarText(int index) => avatarPalette[index % avatarPalette.length][1];
}