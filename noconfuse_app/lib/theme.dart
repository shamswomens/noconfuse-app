import 'package:flutter/material.dart';

// Brand palette pulled from the original site's CSS (style1.css): deep
// space background with a violet -> blue accent gradient.
class AppColors {
  static const bg = Color(0xFF0A0B14);
  static const surface = Color(0xFF13151F);
  static const surfaceAlt = Color(0xFF191C29);
  static const border = Color(0xFF262A3B);
  static const accent = Color(0xFF7C6CF6);
  static const accent2 = Color(0xFF3E8BFF);
  static const good = Color(0xFF37D67A);
  static const warn = Color(0xFFFFD166);
  static const textPrimary = Color(0xFFF3F4F8);
  static const textMuted = Color(0xFF9296AA);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      secondary: AppColors.accent2,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    useMaterial3: true,
  );
}

const gradientAccent = LinearGradient(
  colors: [AppColors.accent, AppColors.accent2],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

IconData categoryIcon(String category) {
  switch (category) {
    case "mobile":
      return Icons.smartphone;
    case "laptop":
      return Icons.laptop_mac;
    case "tv":
      return Icons.tv;
    case "earbuds":
      return Icons.headphones;
    case "tablet":
      return Icons.tablet_mac;
    case "appliance":
      return Icons.kitchen;
    default:
      return Icons.devices_other;
  }
}
