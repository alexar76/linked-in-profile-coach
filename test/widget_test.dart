import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';
import 'package:linkedin_profile_coach/theme/app_theme_id.dart';
import 'package:linkedin_profile_coach/theme/app_themes.dart';
import 'package:linkedin_profile_coach/widgets/theme/theme_picker.dart';
import 'package:linkedin_profile_coach/widgets/wizard/wizard_shell.dart';

void main() {
  testWidgets('ThemePicker compact renders without Material errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.themeData(AppThemeId.darkGold),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: ThemePicker(
            selected: AppThemeId.darkGold,
            onSelected: (_) {},
            compact: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ThemePicker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WizardShell with ThemePicker body builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.themeData(AppThemeId.pinkRose),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: WizardShell(
          title: 'Welcome',
          subtitle: 'Subtitle',
          stepIndex: 0,
          stepCount: 8,
          showBack: false,
          onBack: null,
          onNext: () {},
          body: ThemePicker(
            selected: AppThemeId.pinkRose,
            onSelected: (_) {},
            compact: true,
          ),
        ),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pump();

    expect(find.byType(WizardShell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
