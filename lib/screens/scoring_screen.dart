import 'package:flutter/material.dart';

import '../models/profile_evaluation.dart';
import '../models/recommendation_item.dart';
import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import '../widgets/score_ring.dart';

class ScoringScreen extends StatefulWidget {
  const ScoringScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<ScoringScreen> createState() => ScoringScreenState();
}

class ScoringScreenState extends State<ScoringScreen> {
  ProfileEvaluation? _evaluation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => _loading = true);
    final evaluation = await widget.repo.getLatestEvaluation();
    if (!mounted) return;
    setState(() {
      _evaluation = evaluation;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;

    if (_loading) {
      return _ScoringShimmer(palette: p);
    }

    final evaluation = _evaluation;
    if (evaluation == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.grade_outlined,
                  size: 56, color: p.primary.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                l10n.scoreEmptyTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.scoreEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final delta = evaluation.delta;
    final recs = evaluation.recommendations;

    return RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.scoreTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.scoreSubtitle,
            style: TextStyle(color: p.textSecondary),
          ),
          if (evaluation.usedLlm && evaluation.providerLabel != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.scoreEvaluatorBadge(evaluation.providerLabel!),
              style: TextStyle(
                fontSize: 12,
                color: p.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScoreRing(
                score: evaluation.currentOverall,
                label: l10n.scoreCurrentProfile,
                size: 130,
              ),
              if (evaluation.hasAiScores)
                _AiScoreColumn(
                  evaluation: evaluation,
                  delta: delta,
                  l10n: l10n,
                )
              else
                ScoreRing(
                  score: 0,
                  label: l10n.scoreAiProfile,
                  size: 130,
                  subtitle: l10n.scoreAiNotGenerated,
                ),
            ],
          ),
          if (evaluation.summary.isNotEmpty) ...[
            const SizedBox(height: 28),
            _SummaryCard(text: evaluation.summary),
          ],
          const SizedBox(height: 28),
          Text(
            l10n.scoreSectionBreakdown,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ..._buildSectionRows(context, evaluation),
          if (recs.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              l10n.scoreRecommendationsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.scoreRecommendationsSubtitle,
              style: TextStyle(color: p.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...recs.map((r) => _RecommendationTile(item: r)),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSectionRows(
    BuildContext context,
    ProfileEvaluation evaluation,
  ) {
    final l10n = context.l10n;
    final keys = evaluation.currentBySection.keys.toList()..sort();
    final widgets = <Widget>[];

    for (final key in keys) {
      final current = evaluation.currentBySection[key];
      if (current == null) continue;
      final ai = evaluation.aiBySection[key];
      widgets.add(
        _SectionScoreRow(
          title: sectionMeta(l10n, key).title,
          currentScore: current.score,
          aiScore: ai?.score,
          currentFeedback: current.feedback,
          aiFeedback: ai?.feedback,
        ),
      );
    }

    return widgets;
  }
}

/// AI score ring with an animated delta badge when score improved.
class _AiScoreColumn extends StatefulWidget {
  const _AiScoreColumn({
    required this.evaluation,
    required this.delta,
    required this.l10n,
  });

  final ProfileEvaluation evaluation;
  final int? delta;
  final dynamic l10n;

  @override
  State<_AiScoreColumn> createState() => _AiScoreColumnState();
}

class _AiScoreColumnState extends State<_AiScoreColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    // Delay badge pop-in until ring finishes animating (~900ms).
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final delta = widget.delta;
    final evaluation = widget.evaluation;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        ScoreRing(
          score: evaluation.aiOverall,
          label: l10n.scoreAiProfile,
          size: 130,
          subtitle: delta != null && delta > 0
              ? l10n.scoreDeltaPositive(delta)
              : delta != null && delta < 0
                  ? l10n.scoreDeltaNegative(delta.abs())
                  : l10n.scoreDeltaNeutral,
        ),
        if (delta != null && delta > 0)
          Positioned(
            top: -10,
            right: -10,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) => Transform.scale(
                scale: _anim.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF166534),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF166534).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '+$delta pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer skeleton for the scoring screen loading state.
class _ScoringShimmer extends StatefulWidget {
  const _ScoringShimmer({required this.palette});

  final AppThemePalette palette;

  @override
  State<_ScoringShimmer> createState() => _ScoringShimmerState();
}

class _ScoringShimmerState extends State<_ScoringShimmer>
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
        final base = widget.palette.textSecondary
            .withValues(alpha: 0.06 + 0.08 * _anim.value);
        final hi = widget.palette.textSecondary
            .withValues(alpha: 0.14 + 0.08 * _anim.value);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SR(height: 28, radius: 6, base: base, hi: hi, width: 200),
              const SizedBox(height: 8),
              _SR(height: 16, radius: 4, base: base, hi: hi, width: 280),
              const SizedBox(height: 36),
              // Two rings placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SR(height: 130, radius: 65, base: base, hi: hi, width: 130),
                  _SR(height: 130, radius: 65, base: base, hi: hi, width: 130),
                ],
              ),
              const SizedBox(height: 32),
              _SR(height: 90, radius: 12, base: base, hi: hi),
              const SizedBox(height: 20),
              ...List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SR(height: 72, radius: 10, base: base, hi: hi),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SR extends StatelessWidget {
  const _SR({
    required this.height,
    required this.radius,
    required this.base,
    required this.hi,
    this.width,
  });

  final double height;
  final double radius;
  final Color base;
  final Color hi;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [base, hi, base],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.primary.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: TextStyle(color: p.textPrimary, height: 1.45)),
    );
  }
}

class _SectionScoreRow extends StatelessWidget {
  const _SectionScoreRow({
    required this.title,
    required this.currentScore,
    this.aiScore,
    this.currentFeedback,
    this.aiFeedback,
  });

  final String title;
  final int currentScore;
  final int? aiScore;
  final String? currentFeedback;
  final String? aiFeedback;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: p.backgroundElevated,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                _MiniScore(
                  label: l10n.scoreCurrentShort,
                  score: currentScore,
                ),
                if (aiScore != null) ...[
                  const SizedBox(width: 16),
                  _MiniScore(label: l10n.scoreAiShort, score: aiScore!),
                  if (aiScore! > currentScore) ...[
                    const SizedBox(width: 8),
                    _DeltaBadge(delta: aiScore! - currentScore),
                  ],
                ],
              ],
            ),
            if (currentFeedback != null && currentFeedback!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                currentFeedback!,
                style: TextStyle(fontSize: 12, color: p.textSecondary),
              ),
            ],
            if (aiFeedback != null && aiFeedback!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                aiFeedback!,
                style: TextStyle(fontSize: 12, color: p.primaryDim),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF166534).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '+$delta',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF166534),
        ),
      ),
    );
  }
}

class _MiniScore extends StatelessWidget {
  const _MiniScore({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(fontSize: 12, color: p.textSecondary)),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: p.primary,
          ),
        ),
      ],
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.item});

  final RecommendationItem item;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;

    final priorityColor = switch (item.priority) {
      RecommendationPriority.high => Colors.redAccent,
      RecommendationPriority.medium => const Color(0xFFE8B84A),
      RecommendationPriority.low => p.textSecondary,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: p.surface,
      child: ListTile(
        leading: Icon(Icons.psychology_outlined, color: p.primary, size: 22),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.body),
            const SizedBox(height: 6),
            Text(
              '${sectionMeta(l10n, item.sectionKey).title} · ${item.priority.name}',
              style: TextStyle(fontSize: 11, color: priorityColor),
            ),
          ],
        ),
      ),
    );
  }
}
