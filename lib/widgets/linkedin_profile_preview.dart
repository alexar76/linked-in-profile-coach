import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/linkedin_import_record.dart';
import '../models/profile_section.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';

enum ProfilePreviewMode { linkedin, ai }

class LinkedInProfilePreview extends StatelessWidget {
  const LinkedInProfilePreview({
    super.key,
    required this.sections,
    required this.displayName,
    required this.profileUrl,
    required this.mode,
    this.lastImport,
    this.onSectionTap,
  });

  final List<ProfileSection> sections;
  final String displayName;
  final String profileUrl;
  final ProfilePreviewMode mode;
  final LinkedInImportRecord? lastImport;
  final void Function(ProfileSection section)? onSectionTap;

  String _textFor(AppLocalizations l10n, ProfileSection s) =>
      mode == ProfilePreviewMode.ai
          ? (s.hasAiContent ? s.aiContent : l10n.previewNotGenerated)
          : (s.hasLinkedInContent ? s.content : l10n.previewNotImported);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final headline = sections.firstWhere((s) => s.key == 'headline');
    final headlineText = _textFor(l10n, headline);
    final initials = _initials(displayName);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _HeroHeader(
            displayName: displayName.isNotEmpty ? displayName : l10n.previewYourName,
            headline: headlineText,
            profileUrl: profileUrl,
            initials: initials,
            mode: mode,
            lastImport: lastImport,
            l10n: l10n,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final section = sections[index];
                if (section.key == 'headline') return const SizedBox.shrink();
                final text = _textFor(l10n, section);
                final filled = mode == ProfilePreviewMode.ai
                    ? section.hasAiContent
                    : section.hasLinkedInContent;

                return _SectionCard(
                  section: section,
                  text: text,
                  filled: filled,
                  mode: mode,
                  onTap: onSectionTap != null
                      ? () => onSectionTap!(section)
                      : null,
                  l10n: l10n,
                );
              },
              childCount: sections.length,
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.displayName,
    required this.headline,
    required this.profileUrl,
    required this.initials,
    required this.mode,
    this.lastImport,
    required this.l10n,
  });

  final AppLocalizations l10n;
  final String displayName;
  final String headline;
  final String profileUrl;
  final String initials;
  final ProfilePreviewMode mode;
  final LinkedInImportRecord? lastImport;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final badgeLabel = mode == ProfilePreviewMode.linkedin
        ? 'LinkedIn'
        : 'AI';
    final badgeIcon = mode == ProfilePreviewMode.linkedin
        ? Icons.cloud_download_outlined
        : Icons.auto_awesome;

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.accentOrb, p.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            color: p.surface,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: p.surface,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: p.primary.withValues(alpha: 0.15),
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: p.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Chip(
                                avatar: Icon(badgeIcon, size: 16),
                                label: Text(badgeLabel),
                                backgroundColor: p.primary.withValues(alpha: 0.12),
                              ),
                              if (lastImport != null &&
                                  mode == ProfilePreviewMode.linkedin)
                                Chip(
                                  label: Text(
                                    l10n.previewImportMeta(
                                      lastImport!.sectionsFound,
                                      DateFormat.yMMMd(
                                        Localizations.localeOf(context).toString(),
                                      ).format(lastImport!.importedAt),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  headline,
                  style: TextStyle(
                    fontSize: 15,
                    color: p.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (profileUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    profileUrl,
                    style: TextStyle(
                      fontSize: 12,
                      color: p.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.text,
    required this.filled,
    required this.mode,
    this.onTap,
    required this.l10n,
  });

  final AppLocalizations l10n;
  final ProfileSection section;
  final String text;
  final bool filled;
  final ProfilePreviewMode mode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor =
        filled ? palette.primary : palette.textSecondary.withValues(alpha: 0.7);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    filled ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 20,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (section.manualSyncedAt != null)
                    Tooltip(
                      message: l10n.previewSyncedTooltip,
                      child: Icon(
                        Icons.verified_outlined,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                    ),
                  if (mode == ProfilePreviewMode.ai && section.hasDiff)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.previewChangedLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                text,
                style: TextStyle(
                  height: 1.5,
                  color: filled
                      ? palette.textPrimary
                      : palette.textSecondary.withValues(alpha: 0.7),
                  fontStyle: filled ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
