import 'package:flutter/material.dart';

import '../models/profile_section.dart';
import '../repositories/app_repository.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import '../widgets/linkedin_profile_preview.dart';
import 'section_edit_screen.dart';

class AiProfileScreen extends StatefulWidget {
  const AiProfileScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<AiProfileScreen> createState() => AiProfileScreenState();
}

class AiProfileScreenState extends State<AiProfileScreen> {
  List<ProfileSection> _sections = [];
  String _displayName = '';
  String _profileUrl = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final sections = await widget.repo.getSections();
    final name = await widget.repo.getDisplayName();
    final url = await widget.repo.getProfileUrl();
    if (!mounted) return;
    setState(() {
      _sections = sections;
      _displayName = name;
      _profileUrl = url;
      _loading = false;
    });
  }

  Future<void> _editAiSection(ProfileSection section) async {
    final fieldLabel = context.l10n.aiSectionEditLabel;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SectionEditScreen(
          section: section,
          fieldLabel: fieldLabel,
          initialText: section.aiContent,
          editAiVariants: section.hasMultipleVariants,
          onSave: (edited) => widget.repo.saveSection(edited),
        ),
      ),
    );
    await load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = context.l10n;
    final sections = localizeSections(l10n, _sections);
    final generated = sections.where((s) => s.hasAiContent).length;
    final withDiff = sections.where((s) => s.hasDiff).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.aiProfileTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          avatar: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(l10n.aiProfileSectionsCount(generated)),
                          backgroundColor: Colors.purple.shade50,
                        ),
                        if (withDiff > 0) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(l10n.aiProfileDiffCount(withDiff)),
                            backgroundColor: Colors.orange.shade50,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      l10n.aiProfileSubtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: generated == 0
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 64, color: Colors.purple.shade200),
                      const SizedBox(height: 16),
                      Text(l10n.aiProfileEmptyTitle),
                      const SizedBox(height: 8),
                      Text(
                        l10n.aiProfileEmptyHint,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : LinkedInProfilePreview(
                  sections: sections,
                  displayName: _displayName,
                  profileUrl: _profileUrl,
                  mode: ProfilePreviewMode.ai,
                  onSectionTap: _editAiSection,
                ),
        ),
      ],
    );
  }
}
