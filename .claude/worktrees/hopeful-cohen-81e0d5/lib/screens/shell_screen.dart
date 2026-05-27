import 'package:flutter/material.dart';

import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/ai_messages.dart';
import '../utils/evaluator_messages.dart';
import '../utils/l10n_ext.dart';
import 'admin_screen.dart';
import 'ai_profile_screen.dart';
import 'compare_screen.dart';
import 'dashboard_screen.dart';
import 'linkedin_source_screen.dart';
import 'recommendations_screen.dart';
import 'scoring_screen.dart';
import 'wizard/analysis_wizard_screen.dart';
import '../widgets/app_navigation_rail.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    AppRepository? repo,
    this.onThemeChanged,
    this.onLocaleChanged,
  }) : _repo = repo;

  final AppRepository? _repo;
  final ValueChanged<AppThemeId>? onThemeChanged;
  final ValueChanged<Locale>? onLocaleChanged;

  AppRepository get repo => _repo ?? AppRepository();

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  late final AppRepository _repo = widget.repo;
  final _linkedinKey = GlobalKey<LinkedInSourceScreenState>();
  final _aiKey = GlobalKey<AiProfileScreenState>();
  final _compareKey = GlobalKey<CompareScreenState>();
  final _scoringKey = GlobalKey<ScoringScreenState>();
  final _recommendationsKey = GlobalKey<RecommendationsScreenState>();
  final _dashboardKey = GlobalKey<DashboardScreenState>();
  bool _busy = false;
  String? _busyLabel;
  // Previous score for delta-toast
  int? _lastScore;

  void _setBusy(bool busy, {String? label}) {
    setState(() {
      _busy = busy;
      _busyLabel = busy ? label : null;
    });
  }

  Future<void> _runAnalysis() async {
    _setBusy(true, label: 'Analyzing profile…');
    try {
      await _repo.runAnalysis();
      await _recommendationsKey.currentState?.load();
      await _dashboardKey.currentState?.load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.snackAnalysisDone)),
      );
      setState(() => _index = 5);
    } finally {
      if (mounted) _setBusy(false);
    }
  }

  Future<void> _onAppLanguageChanged(Locale locale) async {
    widget.onLocaleChanged?.call(locale);
    await _recommendationsKey.currentState?.load();
    await _scoringKey.currentState?.load();
    await _dashboardKey.currentState?.load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.snackLanguageChanged),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _runEvaluation() async {
    // Snapshot the previous score before we overwrite it.
    final prevScore = _lastScore;
    _setBusy(true, label: 'Evaluating sections…');
    try {
      final result = await _repo.runEvaluation();
      await _scoringKey.currentState?.load();
      if (!mounted) return;

      final newScore = result.evaluation.currentOverall;
      _lastScore = newScore;

      // Build a delta badge if the score changed.
      final delta =
          (prevScore != null && prevScore != newScore) ? newScore - prevScore : null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: _EvalSnackContent(
            message: evaluationMessage(context.l10n, result),
            delta: delta,
          ),
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() => _index = 4);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorGeneric(e.toString()))),
      );
    } finally {
      if (mounted) _setBusy(false);
    }
  }

  Future<void> _generateAi() async {
    _setBusy(true, label: 'Generating AI profile…');
    try {
      final result = await _repo.generateAiProfile();
      await _aiKey.currentState?.load();
      await _compareKey.currentState?.load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(aiGenerationMessage(context.l10n, result)),
          duration: const Duration(seconds: 4),
        ),
      );
      setState(() => _index = 2);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorGeneric(e.toString()))),
      );
    } finally {
      if (mounted) _setBusy(false);
    }
  }

  void _openAnalysisWizard() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => AnalysisWizardScreen(repo: _repo),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (Icons.dashboard_outlined, l10n.navOverview),
      (Icons.cloud_download_outlined, l10n.navLinkedIn),
      (Icons.auto_awesome, l10n.navAiProfile),
      (Icons.compare_arrows, l10n.navCompare),
      (Icons.grade_outlined, l10n.navScoring),
      (Icons.lightbulb_outline, l10n.navTips),
      (Icons.settings_outlined, l10n.navAdmin),
    ];

    final screens = [
      DashboardScreen(
        key: _dashboardKey,
        repo: _repo,
        onNavigate: (i) => setState(() => _index = i),
        onOpenWizard: _openAnalysisWizard,
      ),
      LinkedInSourceScreen(
        key: _linkedinKey,
        repo: _repo,
      ),
      AiProfileScreen(key: _aiKey, repo: _repo),
      CompareScreen(key: _compareKey, repo: _repo),
      ScoringScreen(key: _scoringKey, repo: _repo),
      RecommendationsScreen(
        key: _recommendationsKey,
        repo: _repo,
      ),
      AdminScreen(
        repo: _repo,
        onImported: () => _linkedinKey.currentState?.load(),
        onThemeChanged: widget.onThemeChanged,
        onLocaleChanged: _onAppLanguageChanged,
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: _index,
            brandTitle: l10n.appTitle,
            destinations: destinations,
            onSelected: (i) {
              setState(() => _index = i);
              if (i == 0) {
                _dashboardKey.currentState?.load();
              } else if (i == 3) {
                _compareKey.currentState?.load();
              } else if (i == 4) {
                _scoringKey.currentState?.load();
              } else if (i == 5) {
                _recommendationsKey.currentState?.load();
              } else if (i == 1) {
                _linkedinKey.currentState?.load();
              } else if (i == 2) {
                _aiKey.currentState?.load();
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  busy: _busy,
                  busyLabel: _busyLabel,
                  title: l10n.appTitle,
                  onAnalyze: _runAnalysis,
                  onEvaluate: _runEvaluation,
                  onGenerateAi: _generateAi,
                  onWizard: _openAnalysisWizard,
                ),
                Expanded(
                  child: _AnimatedScreenStack(
                    index: _index,
                    screens: screens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps all screens mounted (GlobalKeys intact) while fading between them.
class _AnimatedScreenStack extends StatefulWidget {
  const _AnimatedScreenStack({
    required this.index,
    required this.screens,
  });

  final int index;
  final List<Widget> screens;

  @override
  State<_AnimatedScreenStack> createState() => _AnimatedScreenStackState();
}

class _AnimatedScreenStackState extends State<_AnimatedScreenStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late int _visibleIndex;

  @override
  void initState() {
    super.initState();
    _visibleIndex = widget.index;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(_AnimatedScreenStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _ctrl.forward(from: 0).then((_) {
        if (mounted) setState(() => _visibleIndex = widget.index);
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.screens.length; i++)
          Offstage(
            offstage: i != _visibleIndex,
            child: TickerMode(
              enabled: i == _visibleIndex,
              child: widget.screens[i],
            ),
          ),
        // Fade overlay: opaque white/surface flash that fades out on switch
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final opacity = (1.0 - _ctrl.value).clamp(0.0, 1.0);
            if (opacity == 0.0) return const SizedBox.shrink();
            return IgnorePointer(
              child: Container(
                color: context.palette.background.withValues(alpha: opacity),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Snackbar content that shows the evaluation message plus an optional
/// score-delta badge (e.g. "+12 pts").
class _EvalSnackContent extends StatelessWidget {
  const _EvalSnackContent({required this.message, this.delta});

  final String message;
  final int? delta;

  @override
  Widget build(BuildContext context) {
    if (delta == null) return Text(message);

    final isPositive = delta! > 0;
    final sign = isPositive ? '+' : '';
    final color = isPositive ? const Color(0xFF4ADE80) : Colors.redAccent.shade100;

    return Row(
      children: [
        Expanded(child: Text(message)),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            '$sign${delta!} pts',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.busy,
    required this.title,
    required this.onAnalyze,
    required this.onEvaluate,
    required this.onGenerateAi,
    required this.onWizard,
    this.busyLabel,
  });

  final bool busy;
  final String? busyLabel;
  final String title;
  final VoidCallback onAnalyze;
  final VoidCallback onEvaluate;
  final VoidCallback onGenerateAi;
  final VoidCallback onWizard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        color: context.palette.backgroundElevated,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final actions = _buildActions(context, l10n, constraints.maxWidth);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.appTagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                    ),
              ),
              const SizedBox(height: 12),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context, dynamic l10n, double width) {
    final useIcons = width < 720;

    final buttons = <Widget>[
      if (useIcons)
        _ActionIcon(
          tooltip: l10n.btnOpenWizard,
          icon: Icons.route_outlined,
          onPressed: busy ? null : onWizard,
        )
      else
        OutlinedButton.icon(
          onPressed: busy ? null : onWizard,
          icon: const Icon(Icons.route_outlined, size: 18),
          label: Text(l10n.btnOpenWizard),
          style: _compactButtonStyle(context),
        ),
      if (useIcons)
        _ActionIcon(
          tooltip: l10n.btnAnalyze,
          icon: Icons.analytics_outlined,
          onPressed: busy ? null : onAnalyze,
        )
      else
        OutlinedButton.icon(
          onPressed: busy ? null : onAnalyze,
          icon: const Icon(Icons.analytics_outlined, size: 18),
          label: Text(l10n.btnAnalyze),
          style: _compactButtonStyle(context),
        ),
      if (useIcons)
        _ActionIcon(
          tooltip: l10n.btnScore,
          icon: Icons.grade_outlined,
          onPressed: busy ? null : onEvaluate,
        )
      else
        OutlinedButton.icon(
          onPressed: busy ? null : onEvaluate,
          icon: const Icon(Icons.grade_outlined, size: 18),
          label: Text(l10n.btnScore),
          style: _compactButtonStyle(context),
        ),
      if (useIcons)
        _ActionIcon(
          tooltip: l10n.btnGenerateAi,
          icon: Icons.auto_awesome,
          onPressed: busy ? null : onGenerateAi,
          filled: true,
        )
      else
        FilledButton.icon(
          onPressed: busy ? null : onGenerateAi,
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: Text(l10n.btnGenerateAi),
          style: _compactButtonStyle(context, filled: true),
        ),
    ];

    return Row(
      children: [
        if (busy) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          if (busyLabel != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                busyLabel!,
                key: ValueKey(busyLabel),
                style: TextStyle(
                  fontSize: 12,
                  color: context.palette.textSecondary,
                ),
              ),
            ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: buttons,
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _compactButtonStyle(BuildContext context, {bool filled = false}) {
    final base = filled
        ? FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        : OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
    return base;
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    final button = filled
        ? FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size(44, 44),
              padding: EdgeInsets.zero,
            ),
            child: Icon(icon, size: 20),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(44, 44),
              padding: EdgeInsets.zero,
            ),
            child: Icon(icon, size: 20, color: p.textPrimary),
          );

    return Tooltip(message: tooltip, child: button);
  }
}
