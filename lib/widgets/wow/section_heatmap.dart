import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../../models/wow/recruiter_simulator_result.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';
import '../../utils/section_l10n.dart';

class SectionHeatmap extends StatelessWidget {
  const SectionHeatmap({super.key, required this.heatmap});

  final Map<String, SectionHeat> heatmap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    if (heatmap.isEmpty) {
      return Text(l10n.wowHeatmapEmpty);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: heatmap.entries.map((e) {
        final (color, label) = switch (e.value) {
          SectionHeat.strong => (const Color(0xFF166534), l10n.wowHeatStrong),
          SectionHeat.weak => (const Color(0xFF9A3412), l10n.wowHeatWeak),
          _ => (palette.textSecondary, l10n.wowHeatNeutral),
        };
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 8),
              Text(
                '${_sectionLabel(l10n, e.key)} · $label',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _sectionLabel(AppLocalizations l10n, String key) =>
      sectionTitle(l10n, key);
}
