import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/profile_section.dart';
import '../models/recommendation_item.dart';
import '../repositories/app_repository.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import '../widgets/priority_badge.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<RecommendationsScreen> createState() => RecommendationsScreenState();
}

class RecommendationsScreenState extends State<RecommendationsScreen> {
  List<RecommendationItem> _items = [];
  List<ProfileSection> _sections = [];
  String? _filterSection;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final items = await widget.repo.getRuleRecommendations();
    final sections = await widget.repo.getSections();
    if (!mounted) return;
    setState(() {
      _items = items;
      _sections = sections;
      _loading = false;
    });
  }

  String _sectionTitle(AppLocalizations l10n, String key) {
    if (key == 'general') return l10n.filterGeneralPromotion;
    final localized = localizeSections(l10n, _sections);
    return localized.where((s) => s.key == key).map((s) => s.title).firstOrNull ??
        key;
  }

  List<RecommendationItem> get _filtered {
    if (_filterSection == null) return _items;
    return _items.where((i) => i.sectionKey == _filterSection).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                l10n.recommendationsEmpty,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.recommendationsEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.recommendationsEmptyScoringHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    final localized = localizeSections(l10n, _sections);
    final grouped = <String, List<RecommendationItem>>{};
    for (final item in _filtered) {
      grouped.putIfAbsent(item.sectionKey, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Text(
                l10n.navTips,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              DropdownButton<String?>(
                value: _filterSection,
                hint: Text(l10n.filterAllSections),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.filterAllSections),
                  ),
                  DropdownMenuItem(
                    value: 'general',
                    child: Text(l10n.filterGeneralPromotion),
                  ),
                  ...localized.map(
                    (s) => DropdownMenuItem(
                      value: s.key,
                      child: Text(s.title),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _filterSection = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: load,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: Text(
                        _sectionTitle(l10n, entry.key),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...entry.value.map((item) => _RecommendationCard(
                          item: item,
                          onToggle: (done) async {
                            if (item.id != null) {
                              await widget.repo.setRecommendationDone(
                                item.id!,
                                done,
                              );
                              await load();
                            }
                          },
                        )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item, required this.onToggle});

  final RecommendationItem item;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isDone,
              onChanged: (v) => onToggle(v ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration:
                                item.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      PriorityBadge(priority: item.priority),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(item.body),
                  const SizedBox(height: 8),
                  CategoryChip(category: item.category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
