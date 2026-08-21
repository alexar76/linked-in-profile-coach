import 'linkedin_analytics.dart';

class TrendPoint {
  const TrendPoint({required this.date, required this.value, this.label = ''});

  final DateTime date;
  final double value;
  final String label;
}

class MetricDelta {
  const MetricDelta({
    required this.current,
    required this.previous,
  });

  final double current;
  final double? previous;

  double? get change =>
      previous != null && previous! > 0 ? current - previous! : null;

  int? get changePercent => change != null && previous! > 0
      ? ((change! / previous!) * 100).round()
      : null;
}

class DashboardAnalytics {
  const DashboardAnalytics({
    required this.completenessPercent,
    required this.completenessTrend,
    required this.completenessDelta,
    required this.scoreTrend,
    required this.scoreDelta,
    required this.urgentTips,
    required this.totalTips,
    required this.filledSections,
    required this.totalSections,
    required this.targetRole,
    required this.linkedInSeries,
    required this.linkedInHistory,
    required this.importCount,
    required this.lastImportAt,
    required this.atsPercent,
    required this.hasAtsTarget,
  });

  final int completenessPercent;
  final List<TrendPoint> completenessTrend;
  final MetricDelta completenessDelta;
  final List<TrendPoint> scoreTrend;
  final MetricDelta scoreDelta;
  final int urgentTips;
  final int totalTips;
  final int filledSections;
  final int totalSections;
  final String targetRole;
  final Map<String, List<AnalyticsDataPoint>> linkedInSeries;
  final List<LinkedInAnalyticsRecord> linkedInHistory;
  final int importCount;
  final DateTime? lastImportAt;
  final int atsPercent;
  final bool hasAtsTarget;

  bool get hasLinkedInStats =>
      linkedInSeries.values.any((s) => s.length > 1);

  bool get hasCompletenessTrend => completenessTrend.length > 1;

  bool get hasScoreTrend => scoreTrend.length > 1;
}
