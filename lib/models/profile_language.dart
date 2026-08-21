import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

enum ProfileLanguage {
  en,
  ru,
  es;

  String get code => name;

  static ProfileLanguage fromCode(String? code) {
    return ProfileLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => ProfileLanguage.en,
    );
  }

  String label(AppLocalizations l10n) => switch (this) {
        ProfileLanguage.en => l10n.langEnglish,
        ProfileLanguage.ru => l10n.langRussian,
        ProfileLanguage.es => l10n.langSpanish,
      };
}
