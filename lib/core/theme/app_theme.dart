import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;

  static const double screenPadding = 16.0;
  static const double buttonHeight = 52.0;

  // Subtle shadows per design spec
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0E0805).withValues(alpha: 0.05),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF0E0805).withValues(alpha: 0.10),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.accent,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}
