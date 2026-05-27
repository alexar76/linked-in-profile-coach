import 'package:flutter/material.dart';

import '../repositories/app_repository.dart';
import '../utils/import_messages.dart';
import '../utils/l10n_ext.dart';

class ImportPastePanel extends StatefulWidget {
  const ImportPastePanel({
    super.key,
    required this.repo,
    this.profileUrl,
    this.onImported,
  });

  final AppRepository repo;
  final String? profileUrl;
  final VoidCallback? onImported;

  @override
  State<ImportPastePanel> createState() => _ImportPastePanelState();
}

class _ImportPastePanelState extends State<ImportPastePanel> {
  final _controller = TextEditingController();
  bool _importing = false;
  bool _importingUrl = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _importFromUrl() async {
    final l10n = context.l10n;
    setState(() => _importingUrl = true);
    try {
      final result = await widget.repo.importFromProfileUrl(widget.profileUrl);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(importResultMessage(l10n, result))),
      );
      if (result.success) {
        widget.onImported?.call();
      }
    } finally {
      if (mounted) setState(() => _importingUrl = false);
    }
  }

  Future<void> _import() async {
    final l10n = context.l10n;
    setState(() => _importing = true);
    try {
      final result = await widget.repo.importBulkPaste(
        _controller.text,
        profileUrl: widget.profileUrl,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(importResultMessage(l10n, result))),
      );
      if (result.success) {
        widget.onImported?.call();
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.profileUrl != null && widget.profileUrl!.isNotEmpty) ...[
          OutlinedButton.icon(
            onPressed: (_importing || _importingUrl) ? null : _importFromUrl,
            icon: _importingUrl
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link),
            label: Text(l10n.importFromProfileUrl),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.importFromUrlHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
        ],
        Text(l10n.setupImportPasteHint),
        const SizedBox(height: 12),
        Text(
          l10n.importFormatExample,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: TextField(
            controller: _controller,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: l10n.importDialogPlaceholder,
              alignLabelWithHint: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _importing ? null : _import,
          icon: _importing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cloud_download_outlined),
          label: Text(l10n.btnImport),
        ),
      ],
    );
  }
}
