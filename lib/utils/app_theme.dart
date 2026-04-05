// lib/utils/app_theme.dart
// Extended theme helpers used across home screen widgets

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Color palette — mirrors the DevCollab design system exactly
// ─────────────────────────────────────────────────────────────────────────────
class DC {
  DC._();

  // Primary purple
  static const Color p   = Color(0xFF5B47E0);
  static const Color p2  = Color(0xFF7B6EF6);
  static const Color p3  = Color(0xFFEEEDFE);
  static const Color p4  = Color(0xFF26215C);
  static const Color p5  = Color(0xFF3C3489);

  // Green
  static const Color g   = Color(0xFF1D9E75);
  static const Color g2  = Color(0xFFE1F5EE);
  static const Color g3  = Color(0xFF085041);

  // Amber
  static const Color a   = Color(0xFFEF9F27);
  static const Color a2  = Color(0xFFFAEEDA);
  static const Color a3  = Color(0xFF633806);

  // Coral
  static const Color co  = Color(0xFFD85A30);
  static const Color co2 = Color(0xFFFAECE7);
  static const Color co3 = Color(0xFF712B13);

  // Pink
  static const Color pk  = Color(0xFFD4537E);
  static const Color pk2 = Color(0xFFFBEAF0);
  static const Color pk3 = Color(0xFF72243E);

  // Blue
  static const Color bl  = Color(0xFF378ADD);
  static const Color bl2 = Color(0xFFE6F1FB);
  static const Color bl3 = Color(0xFF0C447C);

  // Gray
  static const Color gr  = Color(0xFF888780);
  static const Color gr2 = Color(0xFFF1EFE8);
  static const Color gr3 = Color(0xFF444441);

  // Red
  static const Color r   = Color(0xFFE24B4A);
  static const Color r2  = Color(0xFFFCEBEB);

  // Semantic text
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF888780);
  static const Color textTertiary  = Color(0xFFB4B2A9);

  // Borders
  static const Color border      = Color(0xFFD3D1C7);
  static const Color borderLight = Color(0xFFE8E6DF);

  // Background tiers
  static const Color bg0 = Colors.white;
  static const Color bg1 = Color(0xFFF8F7F4);
  static const Color bg2 = Color(0xFFF1EFE8);

  // Avatar palette — maps colorIndex → (bg, text) pair
  static const List<List<Color>> avatarPalette = [
    [Color(0xFFEEEDFE), Color(0xFF26215C)], // purple
    [Color(0xFFE1F5EE), Color(0xFF085041)], // green
    [Color(0xFFFAEEDA), Color(0xFF633806)], // amber
    [Color(0xFFFAECE7), Color(0xFF712B13)], // coral
    [Color(0xFFFBEAF0), Color(0xFF72243E)], // pink
    [Color(0xFFE6F1FB), Color(0xFF0C447C)], // blue
  ];

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
    Color borderColor = const Color(0xFFE8E6DF),
  }) =>
      BoxDecoration(
        color: color ?? DC.bg0,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 0.5),
      );

  static BoxDecoration pill({Color? bg, double radius = 20}) => BoxDecoration(
    color: bg ?? DC.p3,
    borderRadius: BorderRadius.circular(radius),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Text styles
// ─────────────────────────────────────────────────────────────────────────────
class DCText {
  DCText._();

  static const h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w800,
      color: DC.textPrimary, letterSpacing: -0.8, height: 1.1);
  static const h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
      color: DC.textPrimary, letterSpacing: -0.5);
  static const h3 = TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
      color: DC.textPrimary, letterSpacing: -0.3);
  static const body = TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
      color: DC.textPrimary, height: 1.5);
  static const caption = TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
      color: DC.textSecondary);
  static const label = TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: DC.textSecondary, letterSpacing: 0.5);
  static const micro = TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
      color: DC.textSecondary, letterSpacing: 0.3);
  static const tag = TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
      color: DC.p4, letterSpacing: 0.2);
}