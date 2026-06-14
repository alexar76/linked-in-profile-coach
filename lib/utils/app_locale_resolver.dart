import 'dart:ui' as ui;

/// App UI languages from [AppLocalizations].
const supportedAppLanguageCodes = {'en', 'ru', 'es'};

/// Saved user choice → else OS locale (if supported) → else English.
String resolveAppLocaleCode(String? savedCode) {
  final saved = savedCode?.trim().toLowerCase();
  if (saved != null && saved.isNotEmpty) {
    return supportedAppLanguageCodes.contains(saved) ? saved : 'en';
  }
  final platform =
      ui.PlatformDispatcher.instance.locale.languageCode.toLowerCase();
  return supportedAppLanguageCodes.contains(platform) ? platform : 'en';
}
