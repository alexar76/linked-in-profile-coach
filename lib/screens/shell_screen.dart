import 'package:flutter/material.dart';

import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/ai_generation_flow.dart';
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
import 'marketplace_screen.dart';
import 'wizard/analysis_wizard_screen.dart';
import 'wow/wow_hub_screen.dart';
import '../theme/premium_theme.dart';
import '../utils/premium_transitions.dart';
import '../widgets/app_navigation_rail.dart';
import '../widgets/profile_switcher.dart';

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
  final _adminKey = GlobalKey<AdminScreenState>();
  int _profileEpoch = 0;
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
      setState(() => _index = 6);
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
      final prefs = await resolveAiGenerationPrefs(context, _repo);
      if (!mounted) return;
      setState(() => _busy = true);
      final result = await _repo.generateAiProfile(prefs: prefs);
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
    } on AiGenerationCancelled {
      return;
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
      premiumPageRoute(AnalysisWizardScreen(repo: _repo)),
    );
  }

  Future<void> _onProfileChanged() async {
    final profile = await _repo.getActiveProfile();
    _lastScore = null;
    setState(() => _profileEpoch++);
    await _linkedinKey.currentState?.load();
    await _aiKey.currentState?.load();
    await _compareKey.currentState?.load();
    await _scoringKey.currentState?.load();
    await _recommendationsKey.currentState?.load();
    await _dashboardKey.currentState?.load();
    await _adminKey.currentState?.reload();
    if (!mounted) return;
    if (profile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.snackProfileSwitched(profile.label)),
        ),
      );
    }
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
      (Icons.psychology_outlined, l10n.navCoach),
      (Icons.lightbulb_outline, l10n.navTips),
      (Icons.store_outlined, l10n.navMarketplace),
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
      WowHubScreen(key: ValueKey('wow-$_profileEpoch'), repo: _repo),
      RecommendationsScreen(
        key: _recommendationsKey,
        repo: _repo,
      ),
      MarketplaceScreen(
        key: ValueKey('marketplace-$_profileEpoch'),
        repo: _repo,
      ),
      AdminScreen(
        key: _adminKey,
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
            destinations: destinations,
            onSelected: (i) {
              setState(() => _index = i);
              if (i == 0) {
                _dashboardKey.currentState?.load();
              } else if (i == 3) {
                _compareKey.currentState?.load();
              } else if (i == 4) {
                _scoringKey.currentState?.load();
              } else if (i == 6) {
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
                  repo: _repo,
                  busy: _busy,
                  busyLabel: _busyLabel,
                  title: l10n.appTitle,
                  onAnalyze: _runAnalysis,
                  onEvaluate: _runEvaluation,
                  onGenerateAi: _generateAi,
                  onWizard: _openAnalysisWizard,
                  onProfileChanged: _onProfileChanged,
                ),
                Expanded(
                  child: PremiumBackdrop(
                    child: _AnimatedScreenStack(
                      index: _index,
                      screens: screens,
                    ),
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

/// Keeps all screens mounted (GlobalKeys intact) with cross-fade + slide on tab change.
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
  late int _previousIndex;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _visibleIndex = widget.index;
    _previousIndex = widget.index;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(_AnimatedScreenStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _previousIndex = _visibleIndex;
      _animating = true;
      _ctrl.forward(from: 0).then((_) {
        if (!mounted) return;
        setState(() {
          _visibleIndex = widget.index;
          _animating = false;
        });
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
    final slideDir = widget.index > _previousIndex ? 1.0 : -1.0;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_ctrl.value);

        return Stack(
          fit: StackFit.expand,
          children: [
            for (var i = 0; i < widget.screens.length; i++)
              _ScreenLayer(
                visible: !_animating
                    ? i == _visibleIndex
                    : i == _previousIndex || i == widget.index,
                active: i == (_animating ? widget.index : _visibleIndex),
                animating: _animating,
                progress: t,
                slideDir: slideDir,
                isOutgoing: _animating && i == _previousIndex,
                isIncoming: _animating && i == widget.index,
                child: widget.screens[i],
              ),
          ],
        );
      },
    );
  }
}

class _ScreenLayer extends StatelessWidget {
  const _ScreenLayer({
    required this.visible,
    required this.active,
    required this.animating,
    required this.progress,
    required this.slideDir,
    required this.isOutgoing,
    required this.isIncoming,
    required this.child,
  });

  final bool visible;
  final bool active;
  final bool animating;
  final double progress;
  final double slideDir;
  final bool isOutgoing;
  final bool isIncoming;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    double opacity = 1;
    double dx = 0;
    if (animating) {
      if (isOutgoing) {
        opacity = 1 - progress;
        dx = -slideDir * 24 * progress;
      } else if (isIncoming) {
        opacity = progress;
        dx = slideDir * 24 * (1 - progress);
      }
    }

    return IgnorePointer(
      ignoring: animating && isOutgoing,
      child: Opacity(
        opacity: opacity.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(dx, 0),
          child: TickerMode(enabled: active, child: child),
        ),
      ),
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
    required this.repo,
    required this.busy,
    required this.title,
    required this.onAnalyze,
    required this.onEvaluate,
    required this.onGenerateAi,
    required this.onWizard,
    required this.onProfileChanged,
    this.busyLabel,
  });

  final AppRepository repo;
  final bool busy;
  final String? busyLabel;
  final String title;
  final VoidCallback onAnalyze;
  final VoidCallback onEvaluate;
  final VoidCallback onGenerateAi;
  final VoidCallback onWizard;
  final VoidCallback onProfileChanged;

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ProfileSwitcher(
                    repo: repo,
                    onProfileChanged: onProfileChanged,
                  ),
                ],
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
