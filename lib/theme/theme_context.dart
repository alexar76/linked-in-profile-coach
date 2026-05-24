import 'package:flutter/material.dart';

import 'app_theme_id.dart';
import 'app_theme_palette.dart';
import 'app_themes.dart';

export 'app_theme_id.dart';
export 'app_theme_palette.dart';
export 'app_themes.dart';

extension ThemeContext on BuildContext {
  AppThemePalette get palette =>
      Theme.of(this).extension<AppThemePalette>() ??
      AppThemes.palette(AppThemeId.darkGold);

  AppThemeId get themeId => palette.id;
}

/// Legacy alias — prefer [palette].
class PremiumColors {
  static Color primary(BuildContext c) => c.palette.primary;
  static Color gold(BuildContext c) => c.palette.primary;
}
