import 'dart:convert';

/// One metric sample (e.g. profile views on a date).
class AnalyticsDataPoint {
  const AnalyticsDataPoint({required this.date, required this.value});

  final DateTime date;
  final double value;

  Map<String, dynamic> toJson() => {
        'd': date.toIso8601String(),
        'v': value,
      };

  factory AnalyticsDataPoint.fromJson(Map<String, dynamic> json) {
    return AnalyticsDataPoint(
      date: DateTime.parse(json['d'] as String),
      value: (json['v'] as num).toDouble(),
    );
  }
}

/// Parsed LinkedIn export analytics (views, search, etc.).
class LinkedInAnalyticsBundle {
  const LinkedInAnalyticsBundle({
    this.series = const {},
    this.recordedAt,
  });

  final Map<String, List<AnalyticsDataPoint>> series;
  final DateTime? recordedAt;

  bool get isEmpty => series.values.every((s) => s.isEmpty);

  double? latest(String key) {
    final points = series[key];
    if (points == null || points.isEmpty) return null;
    return points.last.value;
  }

  double? total(String key) {
    final points = series[key];
    if (points == null || points.isEmpty) return null;
    return points.fold<double>(0, (a, p) => a + p.value);
  }

  String toJsonString() => jsonEncode({
        'recorded_at': recordedAt?.toIso8601String(),
        'series': series.map(
          (k, v) => MapEntry(k, v.map((p) => p.toJson()).toList()),
        ),
      });

  factory LinkedInAnalyticsBundle.fromJsonString(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final seriesRaw = map['series'] as Map<String, dynamic>? ?? {};
    final series = <String, List<AnalyticsDataPoint>>{};
    for (final e in seriesRaw.entries) {
      final list = e.value as List<dynamic>;
      series[e.key] = list
          .map((x) => AnalyticsDataPoint.fromJson(x as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    return LinkedInAnalyticsBundle(
      series: series,
      recordedAt: map['recorded_at'] != null
          ? DateTime.tryParse(map['recorded_at'] as String)
          : null,
    );
  }
}

class LinkedInAnalyticsRecord {
  const LinkedInAnalyticsRecord({
    this.id,
    required this.recordedAt,
    required this.bundle,
    required this.source,
  });

  final int? id;
  final DateTime recordedAt;
  final LinkedInAnalyticsBundle bundle;
  final String source;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'recorded_at': recordedAt.millisecondsSinceEpoch,
        'metrics_json': bundle.toJsonString(),
        'source': source,
      };

  factory LinkedInAnalyticsRecord.fromMap(Map<String, dynamic> map) {
    return LinkedInAnalyticsRecord(
      id: map['id'] as int?,
      recordedAt:
          DateTime.fromMillisecondsSinceEpoch(map['recorded_at'] as int),
      bundle: LinkedInAnalyticsBundle.fromJsonString(
        map['metrics_json'] as String,
      ),
      source: map['source'] as String,
    );
  }
}
