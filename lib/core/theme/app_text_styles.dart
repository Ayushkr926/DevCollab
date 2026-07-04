import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Premium typography scale, inspired by Apple's SF Pro rhythm.
/// Uses Inter as a widely available, geometrically similar substitute.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.inter(color: AppColors.textPrimary);

  static TextStyle get largeTitle => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        height: 1.15,
      );

  static TextStyle get subtitle => _base.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: -0.1,
        height: 1.4,
      );

  static TextStyle get sectionTitle => _base.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      );

  static TextStyle get seeAll => _base.copyWith(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: AppColors.brandPrimary,
      );

  static TextStyle get cardTitle => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  static TextStyle get badge => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: -0.1,
      );

  static TextStyle get chip => _base.copyWith(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      );

  static TextStyle get searchHint => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      );

  static TextStyle get detailName => _base.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      );

  static TextStyle get detailLabel => _base.copyWith(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  static TextStyle get buttonPrimary => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.2,
      );

  static TextStyle get buttonSecondary => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.brandPrimary,
        letterSpacing: -0.2,
      );
}
