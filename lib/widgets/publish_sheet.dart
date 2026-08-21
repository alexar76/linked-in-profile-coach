import 'package:flutter/material.dart';

import '../constants/linkedin_publish.dart';
import '../models/profile_section.dart';
import '../models/section_publish_info.dart';
import '../services/linkedin_publish_service.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';

class PublishSheet extends StatelessWidget {
  const PublishSheet({
    super.key,
    required this.sections,
    required this.publishService,
    required this.onSynced,
  });

  final List<ProfileSection> sections;
  final LinkedInPublishService publishService;
  final Future<void> Function(String sectionKey) onSynced;

  List<ProfileSection> get _changed =>
      sections.where((s) => s.hasDiff).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final changed = _changed;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.publishSheetTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber.shade900),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.linkedInApiNote,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.publishChangedCount(changed.length),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final info = publishInfoFor(section.key);
                    return _PublishTile(
                      section: section,
                      info: info,
                      publishService: publishService,
                      onSynced: onSynced,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PublishTile extends StatelessWidget {
  const _PublishTile({
    required this.section,
    required this.info,
    required this.publishService,
    required this.onSynced,
  });

  final ProfileSection section;
  final SectionPublishInfo info;
  final LinkedInPublishService publishService;
  final Future<void> Function(String sectionKey) onSynced;

  PublishCapabilityKind _capabilityKind() => switch (info.capability) {
        PublishCapability.copyToClipboard => PublishCapabilityKind.copy,
        PublishCapability.openInBrowser => PublishCapabilityKind.browser,
        PublishCapability.manualOnly => PublishCapabilityKind.manual,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasAi = section.hasAiContent;
    final changed = section.hasDiff;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (changed)
                  Chip(
                    label: Text(l10n.publishHasChanges),
                    backgroundColor: Colors.orange.shade50,
                    visualDensity: VisualDensity.compact,
                  ),
                if (section.manualSyncedAt != null)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              publishManualNote(l10n, section.key),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: hasAi
                      ? () async {
                          await publishService.copySectionText(
                            section,
                            useAi: true,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.publishCopiedSection(section.title),
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.copy, size: 18),
                  label: Text(l10n.publishCopyAi),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await publishService.openEditPage(section.key);
                    if (context.mounted && !ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.publishBrowserFailed)),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_browser, size: 18),
                  label: Text(l10n.publishOpenLinkedIn),
                ),
                TextButton.icon(
                  onPressed: () => onSynced(section.key),
                  icon: const Icon(Icons.done_outline, size: 18),
                  label: Text(l10n.publishMarkDone),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              publishCapabilityLabel(l10n, _capabilityKind()),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
