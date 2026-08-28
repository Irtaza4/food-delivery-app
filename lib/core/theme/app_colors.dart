import 'package:flutter/material.dart';

/// Semantic color tokens specified in `design.md` and extracted from reference UI
class AppColors {
  // Brand Primary & Accents
  static const Color primary = Color(0xFFAD0E04);        // Primary Red
  static const Color primaryDark = Color(0xFF5A2B17);    // Deep Brown
  static const Color accent = Color(0xFFD04420);         // Warm Orange
  static const Color gold = Color(0xFFCC973F);           // Rating Gold
  static const Color green = Color(0xFF22C55E);          // Success / Active timeline step

  // Neutrals & Surfaces
  static const Color background = Color(0xFFF5F6F6);     // Light Gray Background
  static const Color surface = Color(0xFFFFFFFF);        // White Card / Sheet Surface
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7E7);         // Subtle Border Gray
  static const Color divider = Color(0xFFEEEEEE);

  // Typography
  static const Color textPrimary = Color(0xFF0E0805);     // Dark Brown / Near-Black
  static const Color textSecondary = Color(0xFF5A2B17);   // Warm Brown Subtext
  static const Color textMuted = Color(0xFFA8B3B3);       // Muted Gray Inactive
  static const Color textLight = Color(0xFF7D8888);

  // Gradient helper for hero banners
  static const LinearGradient redHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFCE1B0E),
      Color(0xFFAD0E04),
      Color(0xFF730700),
    ],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1E1E),
      Color(0xFF0E0805),
    ],
  );
}
