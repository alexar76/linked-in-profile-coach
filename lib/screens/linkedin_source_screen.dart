import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/linkedin_import_record.dart';
import '../models/profile_section.dart';
import '../repositories/app_repository.dart';
import '../utils/import_flow.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import '../widgets/linkedin_profile_preview.dart';
import 'section_edit_screen.dart';
import 'snapshots_screen.dart';

/// Import actions for the LinkedIn tab — wraps on narrow widths to avoid overflow.
class _ImportToolbar extends StatelessWidget {
  const _ImportToolbar({
    required this.title,
    required this.subtitle,
    required this.profileUrlEmpty,
    required this.onImportFromUrl,
    required this.onImportJson,
    required this.onImportClipboard,
    required this.onImportDataExport,
    required this.onRefreshLinkedIn,
    required this.onSnapshots,
    required this.l10n,
  });

  final String title;
  final String subtitle;
  final bool profileUrlEmpty;
  final VoidCallback onImportFromUrl;
  final VoidCallback onImportJson;
  final VoidCallback onImportClipboard;
  final VoidCallback onImportDataExport;
  final VoidCallback onRefreshLinkedIn;
  final VoidCallback onSnapshots;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;

        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        );

        final buttons = <Widget>[
          if (compact)
            IconButton.filled(
              tooltip: l10n.refreshLinkedInTooltip,
              onPressed: onRefreshLinkedIn,
              icon: const Icon(Icons.sync),
            )
          else
            FilledButton.icon(
              onPressed: onRefreshLinkedIn,
              icon: const Icon(Icons.sync),
              label: Text(l10n.refreshLinkedIn),
            ),
          if (compact)
            IconButton.outlined(
              tooltip: l10n.snapshotsTitle,
              onPressed: onSnapshots,
              icon: const Icon(Icons.history),
            )
          else
            OutlinedButton.icon(
              onPressed: onSnapshots,
              icon: const Icon(Icons.history),
              label: Text(l10n.snapshotsTitle),
            ),
          if (compact)
            IconButton.outlined(
              tooltip: l10n.importLinkedInExportTooltip,
              onPressed: onImportDataExport,
              icon: const Icon(Icons.archive_outlined),
            )
          else
            OutlinedButton.icon(
              onPressed: onImportDataExport,
              icon: const Icon(Icons.archive_outlined),
              label: Text(l10n.importLinkedInExport),
            ),
          if (compact)
            IconButton.outlined(
              tooltip: l10n.importFromProfileUrl,
              onPressed: profileUrlEmpty ? null : onImportFromUrl,
              icon: const Icon(Icons.link),
            )
          else
            OutlinedButton.icon(
              onPressed: profileUrlEmpty ? null : onImportFromUrl,
              icon: const Icon(Icons.link),
              label: Text(l10n.importFromProfileUrl),
            ),
          if (compact)
            IconButton.outlined(
              tooltip: l10n.importJson,
              onPressed: onImportJson,
              icon: const Icon(Icons.upload_file),
            )
          else
            OutlinedButton.icon(
              onPressed: onImportJson,
              icon: const Icon(Icons.upload_file),
              label: Text(l10n.importJson),
            ),
          if (compact)
            IconButton.filled(
              tooltip: l10n.importLinkedIn,
              onPressed: onImportClipboard,
              icon: const Icon(Icons.download),
            )
          else
            FilledButton.icon(
              onPressed: onImportClipboard,
              icon: const Icon(Icons.download),
              label: Text(l10n.importLinkedIn),
            ),
        ];

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleBlock,
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: buttons,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleBlock),
            const SizedBox(width: 12),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: buttons,
              ),
            ),
          ],
        );
      },
    );
  }
}

class LinkedInSourceScreen extends StatefulWidget {
  const LinkedInSourceScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<LinkedInSourceScreen> createState() => LinkedInSourceScreenState();
}

class LinkedInSourceScreenState extends State<LinkedInSourceScreen>
    with WidgetsBindingObserver {
  List<ProfileSection> _sections = [];
  String _displayName = '';
  String _profileUrl = '';
  LinkedInImportRecord? _lastImport;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkWatchFolder();
    }
  }

  Future<void> load() async {
    final sections = await widget.repo.getSections();
    final name = await widget.repo.getDisplayName();
    final url = await widget.repo.getProfileUrl();
    final lastImport = await widget.repo.getLastImport();
    if (!mounted) return;
    setState(() {
      _sections = sections;
      _displayName = name;
      _profileUrl = url;
      _lastImport = lastImport;
      _loading = false;
    });
    await _checkWatchFolder();
  }

  Future<void> _checkWatchFolder() async {
    final pending = await widget.repo.checkWatchFolder();
    if (pending == null || !mounted) return;
    await runImportWithMerge(
      context,
      widget.repo,
      ImportResult(
        success: true,
        sectionsFound: pending.diffs.where((d) => d.hasChange).length,
        message: '',
        pending: pending,
      ),
    );
    await load();
  }

  Future<void> _handleImportResult(ImportResult result) async {
    await runImportWithMerge(context, widget.repo, result);
    if (mounted) await load();
  }

  Future<void> _refreshLinkedIn() async {
    final pending = await widget.repo.refreshFromLinkedIn();
    if (!mounted) return;
    if (pending == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.refreshLinkedInNothing)),
      );
      return;
    }
    await _handleImportResult(
      ImportResult(
        success: true,
        sectionsFound: pending.diffs.where((d) => d.hasChange).length,
        message: '',
        pending: pending,
      ),
    );
  }

  Future<void> _openSnapshots() async {
    final restored = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SnapshotsScreen(repo: widget.repo),
      ),
    );
    if (restored == true) await load();
  }

  Future<void> _showImportDialog() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.importDialogTitle),
        content: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.importDialogBody),
              const SizedBox(height: 8),
              Text(
                l10n.importFormatExample,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: l10n.importDialogPlaceholder,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _importPaste(controller.text);
            },
            child: Text(l10n.btnImport),
          ),
        ],
      ),
    );
  }

  Future<void> _importPaste(String text) async {
    final result = await widget.repo.importBulkPaste(
      text,
      profileUrl: _profileUrl,
    );
    if (!mounted) return;
    await _handleImportResult(result);
  }

  Future<void> _importFromUrl() async {
    final result = await widget.repo.importFromProfileUrl(_profileUrl);
    if (!mounted) return;
    await _handleImportResult(result);
  }

  Future<void> _importDataExport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    final bytes = await File(path).readAsBytes();
    final isZip = path.toLowerCase().endsWith('.zip');
    final importResult = await widget.repo.importLinkedInDataExport(
      bytes,
      isZip: isZip,
      profileUrl: _profileUrl,
      filePath: path,
    );
    if (!mounted) return;
    await _handleImportResult(importResult);
  }

  Future<void> _importJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return;

    final json = jsonDecode(
      await File(result.files.single.path!).readAsString(),
    ) as Map<String, dynamic>;
    final importResult = await widget.repo.importJson(
      json,
      profileUrl: _profileUrl,
    );
    if (!mounted) return;
    await _handleImportResult(importResult);
  }

  Future<void> _editSection(ProfileSection section) async {
    final fieldLabel = context.l10n.linkedinSectionEditLabel;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SectionEditScreen(
          section: section,
          fieldLabel: fieldLabel,
          onSave: (s) => widget.repo.saveSection(
            s.copyWith(updatedAt: DateTime.now()),
          ),
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
    final filled = sections.where((s) => s.hasLinkedInContent).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: _ImportToolbar(
            title: l10n.linkedinSourceTitle,
            subtitle: l10n.linkedinSectionsMeta(filled, sections.length),
            profileUrlEmpty: _profileUrl.isEmpty,
            onImportFromUrl: _importFromUrl,
            onImportJson: _importJson,
            onImportClipboard: _showImportDialog,
            onImportDataExport: _importDataExport,
            onRefreshLinkedIn: _refreshLinkedIn,
            onSnapshots: _openSnapshots,
            l10n: l10n,
          ),
        ),
        Expanded(
          child: LinkedInProfilePreview(
            sections: sections,
            displayName: _displayName,
            profileUrl: _profileUrl,
            mode: ProfilePreviewMode.linkedin,
            lastImport: _lastImport,
            onSectionTap: _editSection,
          ),
        ),
      ],
    );
  }
}
