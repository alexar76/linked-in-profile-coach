import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../../models/profile_section.dart';
import '../../repositories/app_repository.dart';
import '../../services/linkedin_publish_service.dart';
import '../../theme/theme_context.dart';
import '../../utils/ai_generation_flow.dart';
import '../../utils/ai_messages.dart';
import '../../utils/l10n_ext.dart';
import '../../utils/section_l10n.dart';
import '../../widgets/import_paste_panel.dart';
import '../../widgets/profile_language_picker.dart';
import '../../widgets/publish_sheet.dart';
import '../../widgets/wizard/wizard_shell.dart';
import '../shell_screen.dart';

class AnalysisWizardScreen extends StatefulWidget {
  const AnalysisWizardScreen({
    super.key,
    required this.repo,
    this.fromSetup = false,
  });

  final AppRepository repo;
  final bool fromSetup;

  @override
  State<AnalysisWizardScreen> createState() => _AnalysisWizardScreenState();
}

class _AnalysisWizardScreenState extends State<AnalysisWizardScreen> {
  int _step = 0;
  static const _total = 6;
  bool _busy = false;
  String _status = '';
  final _publish = LinkedInPublishService();

  Future<void> _runStepAction() async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _status = '';
    });
    try {
      switch (_step) {
        case 1:
          final prefs = await resolveAiGenerationPrefs(context, widget.repo);
          final result = await widget.repo.generateAiProfile(prefs: prefs);
          _status = aiGenerationMessage(l10n, result);
        case 3:
          await widget.repo.runAnalysis();
          _status = l10n.snackAnalysisDone;
        default:
          break;
      }
    } on AiGenerationCancelled {
      _status = '';
    } catch (e) {
      _status = e.toString();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _next() async {
    if (_step == 1 || _step == 3) {
      await _runStepAction();
    }
    if (_step < _total - 1) {
      if (mounted) setState(() => _step++);
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    final existing = await widget.repo.getRecommendations();
    if (existing.isEmpty) {
      try {
        await widget.repo.runAnalysis();
      } catch (_) {
        // Shell will show empty state with hint to run analysis manually.
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => ShellScreen(repo: widget.repo),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WizardShell(
      stepIndex: _step,
      stepCount: _total,
      title: _step < _total - 1 ? l10n.analysisTitle : l10n.analysisCompleteTitle,
      subtitle: _subtitle(l10n),
      showBack: _step > 0,
      onBack: () => setState(() => _step--),
      onNext: _next,
      busy: _busy,
      nextLabel: _step == _total - 1 ? l10n.btnFinish : l10n.btnNext,
      body: _body(l10n),
    );
  }

  String _subtitle(dynamic l10n) {
    if (_step == _total - 1) return l10n.analysisCompleteSubtitle;
    return switch (_step) {
      0 => l10n.analysisStepImportDesc,
      1 => l10n.analysisStepAiDesc,
      2 => l10n.analysisStepReviewDesc,
      3 => l10n.analysisStepInsightsDesc,
      4 => l10n.analysisStepPublishDesc,
      _ => l10n.analysisCompleteSubtitle,
    };
  }

  Widget _body(dynamic l10n) {
    return FutureBuilder(
      future: widget.repo.getSections(),
      builder: (context, snapshot) {
        final sections = localizeSections(l10n, snapshot.data ?? []);
        final withDiff = sections.where((s) => s.hasDiff).length;
        final withAi = sections.where((s) => s.hasAiContent).length;
        final filled = sections.where((s) => s.hasLinkedInContent).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AnalysisStepCard(
              icon: _iconForStep(_step),
              label: _stepLabel(l10n),
            ),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_status, style: TextStyle(color: context.palette.primaryLight)),
            ],
            const SizedBox(height: 24),
            if (_step == 0)
              Expanded(
                child: SingleChildScrollView(
                  child: ImportPastePanel(repo: widget.repo),
                ),
              ),
            if (_step == 1) ...[
              ProfileLanguagePicker(repo: widget.repo),
              const SizedBox(height: 16),
              if (withAi > 0)
                Text(
                  l10n.compareAiSectionsCount(withAi),
                  style: TextStyle(color: context.palette.primaryLight),
                ),
            ],
            if (_step == 2 && sections.isNotEmpty)
              Expanded(
                child: _SectionReviewPanel(
                  sections: sections,
                  filled: filled,
                  total: sections.length,
                  diffs: withDiff,
                  l10n: l10n,
                ),
              ),
            if (_step == 4) ...[
              OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: context.palette.surface,
                    builder: (_) => PublishSheet(
                      sections: sections,
                      publishService: _publish,
                      onSynced: (key) => widget.repo.markSynced(key, true),
                    ),
                  );
                },
                icon: const Icon(Icons.publish),
                label: Text(l10n.updateLinkedIn),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.linkedInApiNote,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (_step != 0 && _step != 2) const Spacer(),
          ],
        );
      },
    );
  }

  IconData _iconForStep(int step) => switch (step) {
        0 => Icons.cloud_download_outlined,
        1 => Icons.auto_awesome,
        2 => Icons.compare_arrows,
        3 => Icons.insights_outlined,
        4 => Icons.publish_outlined,
        _ => Icons.celebration_outlined,
      };

  String _stepLabel(dynamic l10n) => switch (_step) {
        0 => l10n.analysisStepImport,
        1 => l10n.analysisStepAi,
        2 => l10n.analysisStepReview,
        3 => l10n.analysisStepInsights,
        4 => l10n.analysisStepPublish,
        _ => l10n.analysisCompleteTitle,
      };
}

class _AnalysisStepCard extends StatelessWidget {
  const _AnalysisStepCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.primary.withValues(alpha: 0.25)),
        gradient: LinearGradient(
          colors: [
            p.primary.withValues(alpha: 0.08),
            p.surface,
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 48, color: p.primary),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionReviewPanel extends StatelessWidget {
  const _SectionReviewPanel({
    required this.sections,
    required this.filled,
    required this.total,
    required this.diffs,
    required this.l10n,
  });

  final List<ProfileSection> sections;
  final int filled;
  final int total;
  final int diffs;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StatChip(label: l10n.statSections, value: '$filled/$total'),
            const SizedBox(width: 12),
            _StatChip(label: l10n.navCompare, value: '$diffs'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: sections.map((s) {
              final hasLi = s.hasLinkedInContent;
              final hasAi = s.hasAiContent;
              return ListTile(
                dense: true,
                leading: Icon(
                  hasLi ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: hasLi
                      ? context.palette.primary
                      : context.palette.textSecondary,
                  size: 20,
                ),
                title: Text(s.title, style: const TextStyle(fontSize: 14)),
                trailing: hasAi
                    ? Icon(Icons.auto_awesome, size: 18, color: context.palette.primaryLight)
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: p.backgroundElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: p.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
