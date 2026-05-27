import 'package:flutter/material.dart';

import 'app_theme_id.dart';
import 'app_theme_palette.dart';

class AppThemes {
  static AppThemePalette palette(AppThemeId id) =>
      _palettes[id] ?? _palettes[AppThemeId.darkGold]!;

  static ThemeData themeData(AppThemeId id) {
    final p = palette(id);
    final isDark = id.isDark;
    final borderSubtle = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: p.primary,
            onPrimary: p.onPrimary,
            secondary: p.primaryLight,
            onSecondary: p.onPrimary,
            surface: p.surface,
            onSurface: p.textPrimary,
          )
        : ColorScheme.light(
            primary: p.primary,
            onPrimary: p.onPrimary,
            secondary: p.primaryLight,
            onSecondary: p.onPrimary,
            surface: p.surface,
            onSurface: p.textPrimary,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      dividerColor: borderSubtle,
      extensions: [p],
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: p.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: p.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: p.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: p.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: p.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0 : 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderSubtle),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.backgroundElevated,
        labelStyle: TextStyle(color: p.textSecondary),
        hintStyle: TextStyle(color: p.textSecondary.withValues(alpha: 0.55)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textPrimary,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: p.backgroundElevated,
        selectedIconTheme: IconThemeData(color: p.primary),
        selectedLabelTextStyle:
            TextStyle(color: p.primary, fontWeight: FontWeight.w600),
        unselectedIconTheme:
            IconThemeData(color: p.textSecondary.withValues(alpha: 0.75)),
        unselectedLabelTextStyle:
            TextStyle(color: p.textSecondary.withValues(alpha: 0.75)),
      ),
    );
  }

  static final Map<AppThemeId, AppThemePalette> _palettes = {
    AppThemeId.darkGold: const AppThemePalette(
      id: AppThemeId.darkGold,
      background: Color(0xFF070B14),
      backgroundElevated: Color(0xFF111827),
      surface: Color(0xFF151D2E),
      primary: Color(0xFFC9A962),
      primaryLight: Color(0xFFE8D5A3),
      primaryDim: Color(0xFF8A7340),
      onPrimary: Color(0xFF070B14),
      textPrimary: Color(0xFFF4F1EA),
      textSecondary: Color(0xFF9CA8C3),
      accentOrb: Color(0xFF0A66C2),
      backdropGradient: [Color(0xFF0A0F1C), Color(0xFF121A2B), Color(0xFF0D1524)],
      glowColor: Color(0xFFC9A962),
    ),
    AppThemeId.darkOcean: const AppThemePalette(
      id: AppThemeId.darkOcean,
      background: Color(0xFF061018),
      backgroundElevated: Color(0xFF0C1A28),
      surface: Color(0xFF122433),
      primary: Color(0xFF4DA3FF),
      primaryLight: Color(0xFF9CCBFF),
      primaryDim: Color(0xFF2B6CB0),
      onPrimary: Color(0xFF061018),
      textPrimary: Color(0xFFE8F4FF),
      textSecondary: Color(0xFF8FA8C4),
      accentOrb: Color(0xFF00D4AA),
      backdropGradient: [Color(0xFF061018), Color(0xFF0E2235), Color(0xFF081520)],
      glowColor: Color(0xFF4DA3FF),
    ),
    AppThemeId.darkPlum: const AppThemePalette(
      id: AppThemeId.darkPlum,
      background: Color(0xFF120A18),
      backgroundElevated: Color(0xFF1E1228),
      surface: Color(0xFF281A34),
      primary: Color(0xFFD48CFF),
      primaryLight: Color(0xFFE8C4FF),
      primaryDim: Color(0xFF9B59C4),
      onPrimary: Color(0xFF120A18),
      textPrimary: Color(0xFFF5EEFA),
      textSecondary: Color(0xFFB8A4C8),
      accentOrb: Color(0xFFFF6B9D),
      backdropGradient: [Color(0xFF120A18), Color(0xFF1A1024), Color(0xFF140C1C)],
      glowColor: Color(0xFFD48CFF),
    ),
    AppThemeId.lightIvory: const AppThemePalette(
      id: AppThemeId.lightIvory,
      background: Color(0xFFF8F6F1),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF8B6914),
      primaryLight: Color(0xFFC9A962),
      primaryDim: Color(0xFF6B5210),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1C1917),
      textSecondary: Color(0xFF57534E),
      accentOrb: Color(0xFF0A66C2),
      backdropGradient: [Color(0xFFF8F6F1), Color(0xFFF0EDE6), Color(0xFFFAF8F5)],
      glowColor: Color(0xFFC9A962),
    ),
    AppThemeId.lightCloud: const AppThemePalette(
      id: AppThemeId.lightCloud,
      background: Color(0xFFF0F4F8),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF0A66C2),
      primaryLight: Color(0xFF5BA4E6),
      primaryDim: Color(0xFF084A8C),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF0F172A),
      textSecondary: Color(0xFF64748B),
      accentOrb: Color(0xFF38BDF8),
      backdropGradient: [Color(0xFFEFF6FF), Color(0xFFF0F4F8), Color(0xFFF8FAFC)],
      glowColor: Color(0xFF0A66C2),
    ),
    AppThemeId.lightSage: const AppThemePalette(
      id: AppThemeId.lightSage,
      background: Color(0xFFF2F6F2),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF3D7A5C),
      primaryLight: Color(0xFF6BAF88),
      primaryDim: Color(0xFF2D5A44),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1A2E24),
      textSecondary: Color(0xFF5C7268),
      accentOrb: Color(0xFF94C9A9),
      backdropGradient: [Color(0xFFF2F6F2), Color(0xFFE8F0EA), Color(0xFFF7FAF8)],
      glowColor: Color(0xFF3D7A5C),
    ),
    AppThemeId.lightPearl: const AppThemePalette(
      id: AppThemeId.lightPearl,
      background: Color(0xFFF5F5F7),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF4B5563),
      primaryLight: Color(0xFF9CA3AF),
      primaryDim: Color(0xFF374151),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF111827),
      textSecondary: Color(0xFF6B7280),
      accentOrb: Color(0xFF6366F1),
      backdropGradient: [Color(0xFFF9FAFB), Color(0xFFF3F4F6), Color(0xFFFFFFFF)],
      glowColor: Color(0xFF6366F1),
    ),
    AppThemeId.lightSand: const AppThemePalette(
      id: AppThemeId.lightSand,
      background: Color(0xFFFAF6F0),
      backgroundElevated: Color(0xFFFFFCF8),
      surface: Color(0xFFFFFCF8),
      primary: Color(0xFFB45309),
      primaryLight: Color(0xFFF59E0B),
      primaryDim: Color(0xFF92400E),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF292524),
      textSecondary: Color(0xFF78716C),
      accentOrb: Color(0xFFD97706),
      backdropGradient: [Color(0xFFFAF6F0), Color(0xFFF5EDE4), Color(0xFFFFFBF5)],
      glowColor: Color(0xFFF59E0B),
    ),
    AppThemeId.lightMint: const AppThemePalette(
      id: AppThemeId.lightMint,
      background: Color(0xFFF0FAF8),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFF0D9488),
      primaryLight: Color(0xFF5EEAD4),
      primaryDim: Color(0xFF0F766E),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF134E4A),
      textSecondary: Color(0xFF5B7A75),
      accentOrb: Color(0xFF2DD4BF),
      backdropGradient: [Color(0xFFECFDF5), Color(0xFFF0FAF8), Color(0xFFF8FDFC)],
      glowColor: Color(0xFF14B8A6),
    ),
    AppThemeId.lightAmber: const AppThemePalette(
      id: AppThemeId.lightAmber,
      background: Color(0xFFFFFBEB),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFFD97706),
      primaryLight: Color(0xFFFBBF24),
      primaryDim: Color(0xFFB45309),
      onPrimary: Color(0xFF1C1917),
      textPrimary: Color(0xFF422006),
      textSecondary: Color(0xFF92400E),
      accentOrb: Color(0xFFF59E0B),
      backdropGradient: [Color(0xFFFFFBEB), Color(0xFFFEF3C7), Color(0xFFFFFAF0)],
      glowColor: Color(0xFFF59E0B),
    ),
    AppThemeId.pinkRose: const AppThemePalette(
      id: AppThemeId.pinkRose,
      background: Color(0xFFFFF5F7),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFFE11D74),
      primaryLight: Color(0xFFF472B6),
      primaryDim: Color(0xFFBE185D),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF4A1942),
      textSecondary: Color(0xFF9D5C8A),
      accentOrb: Color(0xFFFBCFE8),
      backdropGradient: [Color(0xFFFFF1F5), Color(0xFFFFE4EC), Color(0xFFFFF5F7)],
      glowColor: Color(0xFFE11D74),
    ),
    AppThemeId.pinkBlush: const AppThemePalette(
      id: AppThemeId.pinkBlush,
      background: Color(0xFFFFF0F3),
      backgroundElevated: Color(0xFFFFFBFC),
      surface: Color(0xFFFFFBFC),
      primary: Color(0xFFDB5A7A),
      primaryLight: Color(0xFFF9A8C4),
      primaryDim: Color(0xFFB83D5E),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF5C2D3A),
      textSecondary: Color(0xFF9E6B7A),
      accentOrb: Color(0xFFFFD6E0),
      backdropGradient: [Color(0xFFFFF0F3), Color(0xFFFFE8EE), Color(0xFFFFF8F9)],
      glowColor: Color(0xFFDB5A7A),
    ),
    AppThemeId.pinkLilac: const AppThemePalette(
      id: AppThemeId.pinkLilac,
      background: Color(0xFFFAF5FF),
      backgroundElevated: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      primary: Color(0xFFA855F7),
      primaryLight: Color(0xFFD8B4FE),
      primaryDim: Color(0xFF7C3AED),
      onPrimary: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF3B1F5C),
      textSecondary: Color(0xFF7C6B94),
      accentOrb: Color(0xFFF0ABFC),
      backdropGradient: [Color(0xFFFAF5FF), Color(0xFFF3E8FF), Color(0xFFFDF4FF)],
      glowColor: Color(0xFFA855F7),
    ),
  };

  static List<AppThemeId> get darkThemes => [
        AppThemeId.darkGold,
        AppThemeId.darkOcean,
        AppThemeId.darkPlum,
      ];

  static List<AppThemeId> get lightThemes => [
        AppThemeId.lightIvory,
        AppThemeId.lightCloud,
        AppThemeId.lightSage,
        AppThemeId.lightPearl,
        AppThemeId.lightSand,
        AppThemeId.lightMint,
        AppThemeId.lightAmber,
      ];

  static List<AppThemeId> get pinkThemes => [
        AppThemeId.pinkRose,
        AppThemeId.pinkBlush,
        AppThemeId.pinkLilac,
      ];
}
