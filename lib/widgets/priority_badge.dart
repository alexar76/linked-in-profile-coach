import 'package:flutter/material.dart';

import '../models/recommendation_item.dart';
import '../utils/l10n_ext.dart';

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final RecommendationPriority priority;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (priority) {
      RecommendationPriority.high => (l10n.priorityHigh, Colors.red.shade700),
      RecommendationPriority.medium =>
        (l10n.priorityMedium, Colors.orange.shade800),
      RecommendationPriority.low => (l10n.priorityLow, Colors.blue.shade700),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category});

  final RecommendationCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (category) {
      RecommendationCategory.fill => l10n.categoryFill,
      RecommendationCategory.promote => l10n.categoryPromote,
      RecommendationCategory.align => l10n.categoryAlign,
    };

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
