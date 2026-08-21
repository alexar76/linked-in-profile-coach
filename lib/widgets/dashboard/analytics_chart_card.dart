import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/dashboard_analytics.dart';
import '../../models/linkedin_analytics.dart';
import '../../theme/theme_context.dart';
import 'trend_chart.dart';

class AnalyticsChartCard extends StatelessWidget {
  const AnalyticsChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.accent,
    this.valueLabel,
  });

  final String title;
  final String subtitle;
  final List<TrendPoint> points;
  final Color accent;
  final String? valueLabel;

  @override
  Widget build(BuildContext context) {
    final latest = points.isNotEmpty ? points.last.value : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.palette.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (latest != null)
                Text(
                  valueLabel ?? latest.round().toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TrendChart(
            points: points,
            lineColor: accent,
            height: 100,
          ),
        ],
      ),
    );
  }
}

class LinkedInMetricCard extends StatelessWidget {
  const LinkedInMetricCard({
    super.key,
    required this.metricKey,
    required this.label,
    required this.points,
    required this.accent,
  });

  final String metricKey;
  final String label;
  final List<AnalyticsDataPoint> points;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final trend = points
        .map((p) => TrendPoint(date: p.date, value: p.value))
        .toList();
    final total = points.fold<double>(0, (a, p) => a + p.value);

    return AnalyticsChartCard(
      title: label,
      subtitle: points.isEmpty
          ? '—'
          : '${DateFormat.yMMMd().format(points.first.date)}'
              '${points.length > 1 ? ' → ${DateFormat.yMMMd().format(points.last.date)}' : ''}',
      points: trend,
      accent: accent,
      valueLabel: total.round().toString(),
    );
  }
}
