import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import 'repositories/app_repository.dart';
import 'screens/shell_screen.dart';
import 'screens/wizard/setup_wizard_screen.dart';
import 'theme/app_theme_id.dart';
import 'theme/app_themes.dart';
import 'theme/premium_theme.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  final _repo = AppRepository();
  Locale _locale = const Locale('en');
  AppThemeId _themeId = AppThemeId.darkGold;
  bool _ready = false;
  bool _onboardingDone = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _repo.reconcileLanguageAndInsights();
    final code = await _repo.getLocaleLanguageCode();
    final theme = await _repo.getThemeId();
    final done = await _repo.isOnboardingComplete();
    if (!mounted) return;
    setState(() {
      _locale = Locale(code);
      _themeId = theme;
      _onboardingDone = done;
      _ready = true;
    });
  }

  void _onThemeChanged(AppThemeId id) {
    setState(() => _themeId = id);
    _repo.saveThemeId(id);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        key: ValueKey('loading_${_locale.languageCode}_${_themeId.name}'),
        debugShowCheckedModeBanner: false,
        theme: AppThemes.themeData(_themeId),
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          backgroundColor: Colors.transparent,
          body: PremiumBackdrop(
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return MaterialApp(
      key: ValueKey('app_${_locale.languageCode}_${_themeId.name}'),
      title: 'Profile Coach',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.themeData(_themeId),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _onboardingDone
          ? ShellScreen(
              repo: _repo,
              onThemeChanged: _onThemeChanged,
              onLocaleChanged: (locale) => setState(() => _locale = locale),
            )
          : SetupWizardScreen(
              repo: _repo,
              onLocaleChanged: (locale) => setState(() => _locale = locale),
              onThemeChanged: _onThemeChanged,
              initialThemeId: _themeId,
            ),
    );
  }
}
