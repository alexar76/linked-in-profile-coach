import 'package:flutter/material.dart';

import 'app_theme_id.dart';

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.id,
    required this.background,
    required this.backgroundElevated,
    required this.surface,
    required this.primary,
    required this.primaryLight,
    required this.primaryDim,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentOrb,
    required this.backdropGradient,
    required this.glowColor,
  });

  final AppThemeId id;
  final Color background;
  final Color backgroundElevated;
  final Color surface;
  final Color primary;
  final Color primaryLight;
  final Color primaryDim;
  final Color onPrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentOrb;
  final List<Color> backdropGradient;
  final Color glowColor;

  @override
  AppThemePalette copyWith({
    AppThemeId? id,
    Color? background,
    Color? backgroundElevated,
    Color? surface,
    Color? primary,
    Color? primaryLight,
    Color? primaryDim,
    Color? onPrimary,
    Color? textPrimary,
    Color? textSecondary,
    Color? accentOrb,
    List<Color>? backdropGradient,
    Color? glowColor,
  }) {
    return AppThemePalette(
      id: id ?? this.id,
      background: background ?? this.background,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDim: primaryDim ?? this.primaryDim,
      onPrimary: onPrimary ?? this.onPrimary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accentOrb: accentOrb ?? this.accentOrb,
      backdropGradient: backdropGradient ?? this.backdropGradient,
      glowColor: glowColor ?? this.glowColor,
    );
  }

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    if (other is! AppThemePalette) return this;
    return AppThemePalette(
      id: t < 0.5 ? id : other.id,
      background: Color.lerp(background, other.background, t)!,
      backgroundElevated:
          Color.lerp(backgroundElevated, other.backgroundElevated, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accentOrb: Color.lerp(accentOrb, other.accentOrb, t)!,
      backdropGradient: backdropGradient,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
    );
  }
}
