import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/dashboard_analytics.dart';
import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';
import '../widgets/dashboard/analytics_chart_card.dart';
import '../widgets/dashboard/dashboard_kpi.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.repo,
    required this.onNavigate,
    this.onOpenWizard,
  });

  final AppRepository repo;
  final void Function(int tabIndex) onNavigate;
  final VoidCallback? onOpenWizard;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardAnalytics? _analytics;
  int? _reminderDays;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final analytics = await widget.repo.getDashboardAnalytics();
    final reminderDays = await widget.repo.getImportReminderDays();
    if (!mounted) return;
    setState(() {
      _analytics = analytics;
      _reminderDays = reminderDays;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _analytics == null) {
      return _DashboardShimmer(palette: context.palette);
    }

    final a = _analytics!;
    final l10n = context.l10n;
    final palette = context.palette;

    return RefreshIndicator(
      onRefresh: load,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _HeroBanner(
                completeness: a.completenessPercent,
                targetRole: a.targetRole,
                lastImport: a.lastImportAt,
                palette: palette,
                l10n: l10n,
              ),
            ),
          ),
          if (_reminderDays != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: MaterialBanner(
                  content: Text(l10n.importReminderBody(_reminderDays!)),
                  leading: const Icon(Icons.schedule),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await widget.repo.snoozeImportReminder();
                        await load();
                      },
                      child: Text(l10n.importReminderSnooze),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigate(1),
                      child: Text(l10n.refreshLinkedIn),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.crossAxisExtent > 900;
                final kpiChildren = [
                  DashboardKpi(
                    label: l10n.statSections,
                    value: '${a.filledSections}/${a.totalSections}',
                    subtitle: '${a.completenessPercent}%',
                    icon: Icons.check_circle_outline,
                    accent: palette.primary,
                    delta: a.completenessDelta.changePercent,
                  ),
                  DashboardKpi(
                    label: l10n.statProfileScore,
                    value: a.scoreTrend.isNotEmpty
                        ? '${a.scoreTrend.last.value.round()}'
                        : '—',
                    subtitle: '/100',
                    icon: Icons.grade_outlined,
                    accent: palette.primaryLight,
                    delta: a.scoreDelta.changePercent,
                  ),
                  DashboardKpi(
                    label: l10n.statUrgent,
                    value: '${a.urgentTips}',
                    icon: Icons.priority_high,
                    accent: a.urgentTips > 0
                        ? Colors.redAccent
                        : palette.textSecondary,
                  ),
                  DashboardKpi(
                    label: l10n.dashboardImports,
                    value: '${a.importCount}',
                    subtitle: a.lastImportAt != null
                        ? DateFormat.MMMd().format(a.lastImportAt!)
                        : null,
                    icon: Icons.cloud_download_outlined,
                    accent: palette.primaryDim,
                  ),
                ];

                if (a.hasAtsTarget) {
                  kpiChildren.add(
                    DashboardKpi(
                      label: l10n.atsMatchTitle,
                      value: '${a.atsPercent}%',
                      icon: Icons.search,
                      accent: palette.primary,
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: kpiChildren
                                .map(
                                  (k) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: k,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: kpiChildren
                                .map(
                                  (k) => SizedBox(
                                    width: (constraints.crossAxisExtent - 48) / 2,
                                    child: k,
                                  ),
                                )
                                .toList(),
                          ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.dashboardDynamicsTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.dashboardDynamicsSubtitle,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AnalyticsChartCard(
                              title: l10n.dashboardCompletenessTrend,
                              subtitle: l10n.dashboardTrendHint,
                              points: a.completenessTrend,
                              accent: palette.primary,
                              valueLabel: '${a.completenessPercent}%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnalyticsChartCard(
                              title: l10n.dashboardScoreTrend,
                              subtitle: l10n.dashboardScoreTrendHint,
                              points: a.scoreTrend,
                              accent: palette.primaryLight,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      AnalyticsChartCard(
                        title: l10n.dashboardCompletenessTrend,
                        subtitle: l10n.dashboardTrendHint,
                        points: a.completenessTrend,
                        accent: palette.primary,
                        valueLabel: '${a.completenessPercent}%',
                      ),
                      const SizedBox(height: 16),
                      AnalyticsChartCard(
                        title: l10n.dashboardScoreTrend,
                        subtitle: l10n.dashboardScoreTrendHint,
                        points: a.scoreTrend,
                        accent: palette.primaryLight,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      l10n.dashboardLinkedInStatsTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (a.hasLinkedInStats) ...[
                      ..._linkedInCharts(context, a, palette, l10n),
                    ] else
                      _LinkedInStatsEmpty(
                        onImport: () => widget.onNavigate(1),
                        l10n: l10n,
                      ),
                    const SizedBox(height: 24),
                    _QuickActions(
                      onNavigate: widget.onNavigate,
                      onWizard: widget.onOpenWizard,
                      l10n: l10n,
                    ),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _linkedInCharts(
    BuildContext context,
    DashboardAnalytics a,
    AppThemePalette palette,
    AppLocalizations l10n,
  ) {
    final labels = {
      'profile_views': l10n.dashboardMetricProfileViews,
      'search_appearances': l10n.dashboardMetricSearch,
      'post_impressions': l10n.dashboardMetricPosts,
      'followers': l10n.dashboardMetricFollowers,
      'connections': l10n.dashboardMetricConnections,
    };
    final colors = [
      palette.primary,
      palette.primaryDim,
      palette.primaryLight,
    ];
    var i = 0;
    final widgets = <Widget>[];
    for (final entry in a.linkedInSeries.entries) {
      if (entry.value.length < 2) continue;
      final label = labels[entry.key] ?? entry.key;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: LinkedInMetricCard(
            metricKey: entry.key,
            label: label,
            points: entry.value,
            accent: colors[i % colors.length],
          ),
        ),
      );
      i++;
    }
    return widgets;
  }
}

/// Shimmer skeleton shown while dashboard data loads.
class _DashboardShimmer extends StatefulWidget {
  const _DashboardShimmer({required this.palette});

  final AppThemePalette palette;

  @override
  State<_DashboardShimmer> createState() => _DashboardShimmerState();
}

class _DashboardShimmerState extends State<_DashboardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final shimmerColor = widget.palette.textSecondary
            .withValues(alpha: 0.06 + 0.08 * _anim.value);
        final highlightColor = widget.palette.textSecondary
            .withValues(alpha: 0.14 + 0.08 * _anim.value);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero banner skeleton
              _ShimmerRect(
                height: 110,
                radius: 24,
                base: shimmerColor,
                highlight: highlightColor,
              ),
              const SizedBox(height: 24),
              // KPI row skeleton
              Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                      child: _ShimmerRect(
                        height: 100,
                        radius: 16,
                        base: shimmerColor,
                        highlight: highlightColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Chart row skeleton
              Row(
                children: [
                  Expanded(
                    child: _ShimmerRect(
                      height: 160,
                      radius: 20,
                      base: shimmerColor,
                      highlight: highlightColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ShimmerRect(
                      height: 160,
                      radius: 20,
                      base: shimmerColor,
                      highlight: highlightColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerRect extends StatelessWidget {
  const _ShimmerRect({
    required this.height,
    required this.radius,
    required this.base,
    required this.highlight,
  });

  final double height;
  final double radius;
  final Color base;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.completeness,
    required this.targetRole,
    required this.lastImport,
    required this.palette,
    required this.l10n,
  });

  final int completeness;
  final String targetRole;
  final DateTime? lastImport;
  final AppThemePalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final heroText = palette.onPrimary;
    final heroMuted = heroText.withValues(alpha: 0.88);
    final ringTrack = heroText.withValues(alpha: 0.22);
    final ringFill = palette.id.isDark ? palette.primaryLight : heroText;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.primary, palette.primaryDim],
        ),
        border: Border.all(color: palette.primaryDim.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboardTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: heroText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  targetRole.isNotEmpty
                      ? l10n.dashboardTargetRole(targetRole)
                      : l10n.dashboardSubtitle,
                  style: TextStyle(
                    color: heroMuted,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
                if (lastImport != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.dashboardLastImport(
                      DateFormat.yMMMd().add_Hm().format(lastImport!),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: heroMuted.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
          _AnimatedCompleteness(
            completeness: completeness,
            ringTrack: ringTrack,
            ringFill: ringFill,
            heroText: heroText,
          ),
        ],
      ),
    );
  }
}

class _AnimatedCompleteness extends StatefulWidget {
  const _AnimatedCompleteness({
    required this.completeness,
    required this.ringTrack,
    required this.ringFill,
    required this.heroText,
  });

  final int completeness;
  final Color ringTrack;
  final Color ringFill;
  final Color heroText;

  @override
  State<_AnimatedCompleteness> createState() => _AnimatedCompletenessState();
}

class _AnimatedCompletenessState extends State<_AnimatedCompleteness>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedCompleteness old) {
    super.didUpdateWidget(old);
    if (old.completeness != widget.completeness) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final progress = _anim.value;
        final displayValue = (widget.completeness * progress).round();
        return SizedBox(
          width: 88,
          height: 88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: CircularProgressIndicator(
                  value: (widget.completeness / 100) * progress,
                  strokeWidth: 8,
                  backgroundColor: widget.ringTrack,
                  color: widget.ringFill,
                ),
              ),
              Text(
                '$displayValue%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.heroText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinkedInStatsEmpty extends StatelessWidget {
  const _LinkedInStatsEmpty({required this.onImport, required this.l10n});

  final VoidCallback onImport;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.palette.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.palette.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.insights_outlined,
            size: 40,
            color: context.palette.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dashboardLinkedInStatsEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.palette.textSecondary),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onImport,
            icon: const Icon(Icons.archive_outlined),
            label: Text(l10n.importLinkedInExport),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onNavigate,
    required this.onWizard,
    required this.l10n,
  });

  final void Function(int) onNavigate;
  final VoidCallback? onWizard;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (onWizard != null)
          FilledButton.icon(
            onPressed: onWizard,
            icon: const Icon(Icons.route_outlined),
            label: Text(l10n.btnOpenWizard),
          ),
        OutlinedButton.icon(
          onPressed: () => onNavigate(1),
          icon: const Icon(Icons.sync),
          label: Text(l10n.refreshLinkedIn),
        ),
        OutlinedButton.icon(
          onPressed: () => onNavigate(6),
          icon: const Icon(Icons.lightbulb_outline),
          label: Text(l10n.navTips),
        ),
      ],
    );
  }
}
