import 'package:flutter/material.dart';

/// Central color palette for the premium, Apple-inspired UI.
/// Keep everything soft, light, and gradient-driven.
class AppColors {
  AppColors._();

  // Base surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundTintTop = Color(0xFFF7F7FB);
  static const Color backgroundTintBottom = Color(0xFFFCFAFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8A8A93);
  static const Color textTertiary = Color(0xFFB9B9C2);

  // Brand gradient (Apple-esque violet -> blue -> pink)
  static const List<Color> brandGradient = [
    Color(0xFF7C6CF6),
    Color(0xFF9B6CF6),
    Color(0xFFF66CA6),
  ];

  static const Color brandPrimary = Color(0xFF7C6CF6);
  static const Color brandSecondary = Color(0xFFF66CA6);

  // Chip / mood accent colors
  static const Map<String, Color> moodColors = {
    'All': Color(0xFF6C6C72),
    'Happy': Color(0xFFFFB020),
    'Laugh': Color(0xFFFF8A3D),
    'Love': Color(0xFFFF5C8A),
    'Sad': Color(0xFF6C8CFF),
    'Cry': Color(0xFF4FA8FF),
    'Sleep': Color(0xFF9C7CFF),
    'Angry': Color(0xFFFF5C5C),
    'Cool': Color(0xFF35C6C6),
    'Thinking': Color(0xFF7C6CF6),
    'Heart Eyes': Color(0xFFFF4FA0),
    'Party': Color(0xFFB05CFF),
    'Thumbs Up': Color(0xFF35C97A),
  };

  static Color moodColor(String mood) => moodColors[mood] ?? brandPrimary;

  // Shadows
  static Color cardShadow = const Color(0xFF1C1C1E).withOpacity(0.06);
  static Color softShadow = const Color(0xFF1C1C1E).withOpacity(0.04);
  static Color glassBorder = Colors.white.withOpacity(0.6);

  // Skin tones (sample Fitzpatrick-inspired scale)
  static const Map<String, Color> skinTones = {
    'Light': Color(0xFFFFDFC4),
    'Fair': Color(0xFFF0C8A0),
    'Medium': Color(0xFFD3A177),
    'Tan': Color(0xFFB07E56),
    'Deep': Color(0xFF8D5A3B),
    'Dark': Color(0xFF5A3825),
  };

  static Color skinToneColor(String tone) =>
      skinTones[tone] ?? skinTones['Medium']!;
}
