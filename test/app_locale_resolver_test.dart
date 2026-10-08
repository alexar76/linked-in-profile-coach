import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/utils/app_locale_resolver.dart';

void main() {
  test('uses saved locale when set', () {
    expect(resolveAppLocaleCode('ru'), 'ru');
    expect(resolveAppLocaleCode('en'), 'en');
  });

  test('invalid saved locale falls back to English', () {
    expect(resolveAppLocaleCode('de'), 'en');
    expect(resolveAppLocaleCode('fr'), 'en');
  });

  test('null saved uses platform or English', () {
    final code = resolveAppLocaleCode(null);
    expect(supportedAppLanguageCodes.contains(code), isTrue);
  });
}
