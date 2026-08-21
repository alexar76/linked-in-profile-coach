import 'dart:convert';

import '../constants/linkedin_section_order.dart';
import '../models/ats_match_result.dart';
import '../models/dashboard_analytics.dart';
import '../models/linkedin_analytics.dart';
import '../models/profile_evaluation.dart';
import '../models/profile_snapshot.dart';
import '../models/recommendation_item.dart';

class DashboardAnalyticsInput {
  const DashboardAnalyticsInput({
    required this.snapshots,
    required this.evaluations,
    required this.linkedInRecords,
    required this.importCount,
    required this.lastImportAt,
    required this.recommendations,
    required this.filledSections,
    required this.totalSections,
    required this.targetRole,
    required this.ats,
  });

  final List<ProfileSnapshot> snapshots;
  final List<ProfileEvaluation> evaluations;
  final List<LinkedInAnalyticsRecord> linkedInRecords;
  final int importCount;
  final DateTime? lastImportAt;
  final List<RecommendationItem> recommendations;
  final int filledSections;
  final int totalSections;
  final String targetRole;
  final AtsMatchResult ats;
}

class DashboardAnalyticsService {
  DashboardAnalytics build(DashboardAnalyticsInput input) {
    final completenessTrend = _completenessFromSnapshots(input.snapshots);
    if (completenessTrend.isEmpty && input.totalSections > 0) {
      completenessTrend.add(
        TrendPoint(
          date: DateTime.now(),
          value: input.filledSections / input.totalSections * 100,
        ),
      );
    }

    final scoreTrend = input.evaluations
        .map(
          (e) => TrendPoint(
            date: e.evaluatedAt,
            value: e.currentOverall.toDouble(),
          ),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final nowPct = input.totalSections == 0
        ? 0
        : (input.filledSections / input.totalSections * 100).round();

    final linkedInLatest = input.linkedInRecords.isNotEmpty
        ? input.linkedInRecords.first.bundle.series
        : <String, List<AnalyticsDataPoint>>{};

    final urgent = input.recommendations
        .where(
          (r) =>
              r.priority == RecommendationPriority.high && !r.isDone,
        )
        .length;

    return DashboardAnalytics(
      completenessPercent: nowPct,
      completenessTrend: completenessTrend,
      completenessDelta: _delta(completenessTrend),
      scoreTrend: scoreTrend,
      scoreDelta: _delta(scoreTrend),
      urgentTips: urgent,
      totalTips: input.recommendations.length,
      filledSections: input.filledSections,
      totalSections: input.totalSections,
      targetRole: input.targetRole,
      linkedInSeries: linkedInLatest,
      linkedInHistory: input.linkedInRecords,
      importCount: input.importCount,
      lastImportAt: input.lastImportAt,
      atsPercent: input.ats.scorePercent,
      hasAtsTarget: input.ats.hasTarget,
    );
  }

  List<TrendPoint> _completenessFromSnapshots(List<ProfileSnapshot> snaps) {
    final points = <TrendPoint>[];
    for (final s in snaps) {
      try {
        final map =
            jsonDecode(s.sectionsJson) as Map<String, dynamic>;
        var filled = 0;
        for (final key in linkedInSectionOrder) {
          final v = map[key];
          if (v is String && v.trim().isNotEmpty) filled++;
        }
        final total = linkedInSectionOrder.length;
        points.add(
          TrendPoint(
            date: s.capturedAt,
            value: total == 0 ? 0 : filled / total * 100,
          ),
        );
      } catch (_) {}
    }
    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  MetricDelta _delta(List<TrendPoint> trend) {
    if (trend.isEmpty) {
      return const MetricDelta(current: 0, previous: null);
    }
    final current = trend.last.value;
    final previous = trend.length > 1 ? trend[trend.length - 2].value : null;
    return MetricDelta(current: current, previous: previous);
  }
}
