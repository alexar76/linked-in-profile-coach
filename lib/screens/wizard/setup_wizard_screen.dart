import 'package:flutter/material.dart';

import '../../data/premium_templates.dart';
import '../../repositories/app_repository.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';
import '../../widgets/ai_settings_card.dart';
import '../../widgets/import_paste_panel.dart';
import '../../widgets/resume_upload_panel.dart';
import '../../widgets/theme/theme_picker.dart';
import '../../widgets/wizard/wizard_shell.dart';
import 'analysis_wizard_screen.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({
    super.key,
    required this.repo,
    this.onLocaleChanged,
    this.onThemeChanged,
    this.initialThemeId = AppThemeId.darkGold,
  });

  final AppRepository repo;
  final ValueChanged<Locale>? onLocaleChanged;
  final ValueChanged<AppThemeId>? onThemeChanged;
  final AppThemeId initialThemeId;

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  int _step = 0;
  static const _totalSteps = 8;

  Locale _locale = const Locale('en');
  late AppThemeId _themeId;
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _roleController = TextEditingController();
  final _industryController = TextEditingController();
  String? _templateId;

  @override
  void initState() {
    super.initState();
    _themeId = widget.initialThemeId;
    _load();
  }

  Future<void> _load() async {
    final code = await widget.repo.getLocaleLanguageCode();
    final theme = await widget.repo.getThemeId();
    _locale = Locale(code);
    _themeId = theme;
    _nameController.text = await widget.repo.getDisplayName();
    _urlController.text = await widget.repo.getProfileUrl();
    _roleController.text = await widget.repo.getTargetRole();
    _industryController.text = await widget.repo.getTargetIndustry();
    _templateId = await widget.repo.getPremiumTemplateId();
    if (mounted) setState(() {});
  }

  Future<void> _persistProfile() async {
    await widget.repo.saveDisplayName(_nameController.text.trim());
    await widget.repo.saveProfileUrl(_urlController.text.trim());
    await widget.repo.saveTargetRole(_roleController.text.trim());
    await widget.repo.saveTargetIndustry(_industryController.text.trim());
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    widget.repo.saveLocale(locale.languageCode);
    widget.onLocaleChanged?.call(locale);
  }

  void _setTheme(AppThemeId id) {
    setState(() => _themeId = id);
    widget.repo.saveThemeId(id);
    widget.onThemeChanged?.call(id);
  }

  void _next() async {
    if (_step == 1) await _persistProfile();
    if (_step == 2) await _persistProfile();
    if (_step == 3 && _templateId != null) {
      await widget.repo.savePremiumTemplateId(_templateId!);
      if (!mounted) return;
      final templates = premiumTemplates(context.l10n);
      final t = templates.firstWhere((e) => e.id == _templateId);
      if (_roleController.text.trim().isEmpty) {
        _roleController.text = t.roleSeed;
        await widget.repo.saveTargetRole(t.roleSeed);
      }
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    await _persistProfile();
    await widget.repo.setOnboardingComplete(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) => AnalysisWizardScreen(
          repo: widget.repo,
          fromSetup: true,
        ),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _roleController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WizardShell(
      stepIndex: _step,
      stepCount: _totalSteps,
      title: _title(l10n),
      subtitle: _subtitle(l10n),
      showBack: _step > 0,
      onBack: _step > 0 ? () => setState(() => _step--) : null,
      onNext: _next,
      nextLabel: _step == _totalSteps - 1 ? l10n.btnGetStarted : l10n.btnNext,
      body: _body(l10n),
    );
  }

  String _title(dynamic l10n) => switch (_step) {
        0 => l10n.setupWelcomeTitle,
        1 => l10n.setupProfileTitle,
        2 => l10n.setupGoalTitle,
        3 => l10n.setupTemplateTitle,
        4 => l10n.setupAiTitle,
        5 => l10n.setupResumeTitle,
        6 => l10n.setupImportTitle,
        _ => l10n.setupReadyTitle,
      };

  String _subtitle(dynamic l10n) => switch (_step) {
        0 => l10n.setupWelcomeSubtitle,
        1 => l10n.setupProfileSubtitle,
        2 => l10n.setupGoalSubtitle,
        3 => l10n.setupTemplateSubtitle,
        4 => l10n.setupAiSubtitle,
        5 => l10n.setupResumeSubtitle,
        6 => l10n.setupImportSubtitle,
        _ => l10n.setupReadySubtitle,
      };

  Widget _body(dynamic l10n) {
    return switch (_step) {
      0 => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LanguageStep(
                locale: _locale,
                onChanged: _setLocale,
                l10n: l10n,
              ),
              const SizedBox(height: 28),
              ThemePicker(
                selected: _themeId,
                onSelected: _setTheme,
                compact: true,
              ),
            ],
          ),
        ),
      1 => _FormStep(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.setupNameLabel,
                hintText: l10n.setupNameHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.setupUrlLabel,
                hintText: l10n.setupUrlHint,
              ),
            ),
          ],
        ),
      2 => _FormStep(
          children: [
            TextField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: l10n.setupRoleLabel,
                hintText: l10n.setupRoleHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _industryController,
              decoration: InputDecoration(
                labelText: l10n.setupIndustryLabel,
                hintText: l10n.setupIndustryHint,
              ),
            ),
          ],
        ),
      3 => _TemplateStep(
          templates: premiumTemplates(l10n),
          selectedId: _templateId,
          onSelect: (id) => setState(() => _templateId = id),
        ),
      4 => SingleChildScrollView(
          child: AiSettingsCard(repo: widget.repo),
        ),
      5 => SingleChildScrollView(
          child: ResumeUploadPanel(repo: widget.repo, compact: true),
        ),
      6 => SingleChildScrollView(
          child: ImportPastePanel(
            repo: widget.repo,
            profileUrl: _urlController.text.trim().isEmpty
                ? null
                : _urlController.text.trim(),
          ),
        ),
      _ => Center(
          child: Icon(
            Icons.auto_awesome,
            size: 80,
            color: context.palette.primary.withValues(alpha: 0.85),
          ),
        ),
    };
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({
    required this.locale,
    required this.onChanged,
    required this.l10n,
  });

  final Locale locale;
  final ValueChanged<Locale> onChanged;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.setupLanguageTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.setupLanguageSubtitle),
        const SizedBox(height: 24),
        _LangTile(
          label: l10n.langEnglish,
          code: 'en',
          selected: locale.languageCode == 'en',
          onTap: () => onChanged(const Locale('en')),
        ),
        _LangTile(
          label: l10n.langRussian,
          code: 'ru',
          selected: locale.languageCode == 'ru',
          onTap: () => onChanged(const Locale('ru')),
        ),
        _LangTile(
          label: l10n.langSpanish,
          code: 'es',
          selected: locale.languageCode == 'es',
          onTap: () => onChanged(const Locale('es')),
        ),
      ],
    );
  }
}

class _LangTile extends StatelessWidget {
  const _LangTile({
    required this.label,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TemplateSelectCard(
      title: label,
      description: code.toUpperCase(),
      selected: selected,
      onTap: onTap,
    );
  }
}

class _FormStep extends StatelessWidget {
  const _FormStep({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _TemplateStep extends StatelessWidget {
  const _TemplateStep({
    required this.templates,
    required this.selectedId,
    required this.onSelect,
  });

  final List<PremiumTemplate> templates;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: templates
          .map(
            (t) => TemplateSelectCard(
              title: t.title,
              description: t.description,
              selected: selectedId == t.id,
              onTap: () => onSelect(t.id),
            ),
          )
          .toList(),
    );
  }
}
