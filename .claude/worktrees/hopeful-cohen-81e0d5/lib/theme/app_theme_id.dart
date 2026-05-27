enum AppThemeId {
  darkGold,
  darkOcean,
  darkPlum,
  lightIvory,
  lightCloud,
  lightSage,
  lightPearl,
  lightSand,
  lightMint,
  lightAmber,
  pinkRose,
  pinkBlush,
  pinkLilac,
}

extension AppThemeIdCodec on AppThemeId {
  String get storageKey => name;

  static AppThemeId fromString(String? value) {
    if (value == null || value.isEmpty) return AppThemeId.darkGold;
    return AppThemeId.values.firstWhere(
      (t) => t.name == value,
      orElse: () => AppThemeId.darkGold,
    );
  }

  bool get isDark => switch (this) {
        AppThemeId.lightIvory ||
        AppThemeId.lightCloud ||
        AppThemeId.lightSage ||
        AppThemeId.lightPearl ||
        AppThemeId.lightSand ||
        AppThemeId.lightMint ||
        AppThemeId.lightAmber ||
        AppThemeId.pinkRose ||
        AppThemeId.pinkBlush ||
        AppThemeId.pinkLilac =>
          false,
        _ => true,
      };

  bool get isPink => switch (this) {
        AppThemeId.pinkRose || AppThemeId.pinkBlush || AppThemeId.pinkLilac => true,
        _ => false,
      };
}
