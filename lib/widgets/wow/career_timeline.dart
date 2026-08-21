import 'package:flutter/material.dart';

import '../../models/wow/career_what_if_result.dart';
import '../../services/experience_structure_parser.dart';
import '../../theme/theme_context.dart';

class CareerTimeline extends StatelessWidget {
  const CareerTimeline({
    super.key,
    required this.experienceText,
    this.forecast,
  });

  final String experienceText;
  final CareerWhatIfResult? forecast;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final roles = ExperienceStructureParser().parse(experienceText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (roles.isNotEmpty) ...[
          Text(
            'Past',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...roles.take(6).map(
                (r) => _TimelineTile(
                  title: r.title,
                  subtitle: '${r.company}${r.period.isNotEmpty ? ' · ${r.period}' : ''}',
                  color: palette.primaryDim,
                  isPast: true,
                ),
              ),
          const SizedBox(height: 16),
        ],
        if (forecast != null && forecast!.milestones.isNotEmpty) ...[
          Text(
            'Forecast',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...forecast!.milestones.map(
            (m) => _TimelineTile(
              title: m.title,
              subtitle: '+${m.yearOffset}y — ${m.description}',
              color: palette.primary,
              isPast: false,
            ),
          ),
        ],
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isPast,
  });

  final String title;
  final String subtitle;
  final Color color;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: isPast
                      ? null
                      : Border.all(color: color, width: 2),
                ),
              ),
              Container(width: 2, height: 40, color: color.withValues(alpha: 0.3)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.palette.textSecondary,
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
