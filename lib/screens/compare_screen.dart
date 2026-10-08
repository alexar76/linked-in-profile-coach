import 'package:flutter/material.dart';

import '../models/profile_section.dart';
import '../repositories/app_repository.dart';
import '../services/linkedin_publish_service.dart';
import '../services/text_diff.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import '../widgets/publish_sheet.dart';
import '../widgets/section_diff_panel.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<CompareScreen> createState() => CompareScreenState();
}

class CompareScreenState extends State<CompareScreen> {
  List<ProfileSection> _sections = [];
  String _selectedKey = 'headline';
  bool _loading = true;
  bool _sideBySide = true;
  bool _onlyWithAi = false;
  final _publish = LinkedInPublishService();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final sections = await widget.repo.getSections();
    if (!mounted) return;

    final withAi = sections.where((s) => s.hasAiContent).toList();
    var selectedKey = _selectedKey;
    final current = sections.where((s) => s.key == selectedKey).firstOrNull;
    if (current == null ||
        (!current.hasAiContent && withAi.isNotEmpty && _onlyWithAi)) {
      selectedKey = withAi.isNotEmpty
          ? withAi.first.key
          : sections.first.key;
    }

    setState(() {
      _sections = sections;
      _selectedKey = selectedKey;
      _loading = false;
    });
  }

  void _openPublishSheet() {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      builder: (_) => PublishSheet(
        sections: localizeSections(l10n, _sections),
        publishService: _publish,
        onSynced: (key) async {
          await widget.repo.markSynced(key, true);
          await load();
        },
      ),
    );
  }

  List<ProfileSection> _visibleSections(List<ProfileSection> localized) {
    if (!_onlyWithAi) return localized;
    return localized.where((s) => s.hasAiContent).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final localized = localizeSections(l10n, _sections);
    final withAiCount = localized.where((s) => s.hasAiContent).length;
    final visible = _visibleSections(localized);

    if (visible.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_outlined,
                  size: 56, color: p.primary.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                l10n.compareNoAiTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.compareNoAiHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final section = visible.firstWhere(
      (s) => s.key == _selectedKey,
      orElse: () => visible.first,
    );
    if (section.key != _selectedKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedKey = section.key);
      });
    }

    final linkedIn = section.content.trim().isEmpty
        ? l10n.compareEmptyLinkedIn
        : section.content;
    final ai = section.aiContent.trim().isEmpty
        ? l10n.compareEmptyAi
        : section.aiContent;
    final similarity = TextDiff.similarityPercent(
      section.content.trim().isEmpty ? '' : section.content,
      section.aiContent.trim().isEmpty ? '' : section.aiContent,
    );
    final withDiff = localized.where((s) => s.hasDiff).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.compareTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              _StatPill(
                icon: Icons.auto_awesome,
                label: l10n.compareAiSectionsCount(withAiCount),
                color: p.primary,
              ),
              if (withDiff > 0)
                _StatPill(
                  icon: Icons.difference_outlined,
                  label: l10n.compareSectionsWithDiff(withDiff),
                  color: Colors.orange.shade700,
                ),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.compareSideBySide),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.compareDiffMode),
                  ),
                ],
                selected: {_sideBySide},
                onSelectionChanged: (s) => setState(() => _sideBySide = s.first),
              ),
              FilledButton.icon(
                onPressed: _openPublishSheet,
                icon: const Icon(Icons.publish_outlined),
                label: Text(l10n.updateLinkedIn),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilterChip(
                selected: _onlyWithAi,
                onSelected: (v) => setState(() {
                  _onlyWithAi = v;
                  if (v) {
                    final first = localized.firstWhere(
                      (s) => s.hasAiContent,
                      orElse: () => localized.first,
                    );
                    _selectedKey = first.key;
                  }
                }),
                label: Text(l10n.compareOnlyWithAi),
                avatar: Icon(
                  Icons.filter_alt_outlined,
                  size: 18,
                  color: _onlyWithAi ? p.primary : p.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.compareSectionLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: section.key,
                      items: visible
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.key,
                              child: Row(
                                children: [
                                  if (s.hasAiContent)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.auto_awesome,
                                        size: 16,
                                        color: p.primary,
                                      ),
                                    ),
                                  if (s.hasDiff)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  Expanded(child: Text(s.title)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedKey = v!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _SimilarityRing(percent: similarity),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _sideBySide
                ? SideBySideCompare(
                    leftTitle: l10n.compareLinkedInColumn,
                    rightTitle: l10n.compareAiColumn,
                    leftText: linkedIn,
                    rightText: ai,
                  )
                : SectionDiffPanel(
                    oldText: linkedIn,
                    newText: ai,
                    similarityPercent: similarity,
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimilarityRing extends StatelessWidget {
  const _SimilarityRing({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: 6,
            backgroundColor: p.textSecondary.withValues(alpha: 0.15),
            color: p.primary,
          ),
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: p.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
