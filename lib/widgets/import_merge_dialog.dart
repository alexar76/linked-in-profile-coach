import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/section_import_diff.dart';
import '../utils/l10n_ext.dart';

class ImportMergeDialog extends StatefulWidget {
  const ImportMergeDialog({
    super.key,
    required this.diffs,
    required this.sourceLabel,
  });

  final List<SectionImportDiff> diffs;
  final String sourceLabel;

  static Future<Set<String>?> show(
    BuildContext context, {
    required List<SectionImportDiff> diffs,
    required String sourceLabel,
  }) {
    return showDialog<Set<String>>(
      context: context,
      builder: (_) => ImportMergeDialog(
        diffs: diffs,
        sourceLabel: sourceLabel,
      ),
    );
  }

  @override
  State<ImportMergeDialog> createState() => _ImportMergeDialogState();
}

class _ImportMergeDialogState extends State<ImportMergeDialog> {
  late final Map<String, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final d in widget.diffs)
        d.sectionKey: d.selectedByDefault,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final changed = widget.diffs.where((d) => d.hasChange).length;

    return AlertDialog(
      title: Text(l10n.importMergeTitle),
      content: SizedBox(
        width: 640,
        height: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.importMergeSubtitle(widget.sourceLabel, changed),
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (final d in widget.diffs) {
                        if (d.hasChange) _selected[d.sectionKey] = true;
                      }
                    });
                  },
                  child: Text(l10n.importMergeSelectChanged),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (final key in _selected.keys) {
                        _selected[key] = true;
                      }
                    });
                  },
                  child: Text(l10n.importMergeSelectAll),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (final key in _selected.keys) {
                        _selected[key] = false;
                      }
                    });
                  },
                  child: Text(l10n.importMergeSelectNone),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.diffs.length,
                itemBuilder: (context, index) {
                  final d = widget.diffs[index];
                  return CheckboxListTile(
                    value: _selected[d.sectionKey] ?? false,
                    onChanged: d.status == SectionImportStatus.unchanged
                        ? null
                        : (v) => setState(
                              () => _selected[d.sectionKey] = v ?? false,
                            ),
                    title: Text(d.title),
                    subtitle: Text(
                      _statusLabel(l10n, d),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondary: IconButton(
                      tooltip: l10n.importMergePreview,
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () => _showPreview(context, d),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.btnCancel),
        ),
        FilledButton(
          onPressed: () {
            final keys = _selected.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toSet();
            Navigator.pop(context, keys);
          },
          child: Text(l10n.importMergeApply),
        ),
      ],
    );
  }

  String _statusLabel(AppLocalizations l10n, SectionImportDiff d) {
    return switch (d.status) {
      SectionImportStatus.newSection => l10n.importMergeStatusNew,
      SectionImportStatus.changed => l10n.importMergeStatusChanged,
      SectionImportStatus.unchanged => l10n.importMergeStatusUnchanged,
      SectionImportStatus.incomingOnly => l10n.importMergeStatusNew,
    };
  }

  void _showPreview(BuildContext context, SectionImportDiff d) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(d.title),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.importMergeCurrent,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  d.current.isEmpty ? '—' : d.current,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.importMergeIncoming,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  d.incoming,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.btnClose),
          ),
        ],
      ),
    );
  }
}
