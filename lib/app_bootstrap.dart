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
  String? _initError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _repo.reconcileLanguageAndInsights();
      final code = await _repo.getLocaleLanguageCode();
      final theme = await _repo.getThemeId();
      final done = await _repo.isOnboardingComplete();
      if (!mounted) return;
      setState(() {
        _locale = Locale(code);
        _themeId = theme;
        _onboardingDone = done;
        _initError = null;
        _ready = true;
      });
    } catch (e, st) {
      debugPrint('AppBootstrap init failed: $e\n$st');
      if (!mounted) return;
      setState(() {
        _initError = e.toString();
        _ready = true;
      });
    }
  }

  void _onThemeChanged(AppThemeId id) {
    setState(() => _themeId = id);
    _repo.saveThemeId(id);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _initError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.themeData(_themeId),
        home: Scaffold(
          body: PremiumBackdrop(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to start',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _initError!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _ready = false;
                          _initError = null;
                        });
                        _init();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

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

    return AnimatedTheme(
      data: AppThemes.themeData(_themeId),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      child: MaterialApp(
        key: ValueKey('app_${_locale.languageCode}'),
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
      ),
    );
  }
}
