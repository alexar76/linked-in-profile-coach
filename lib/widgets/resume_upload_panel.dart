import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../repositories/app_repository.dart';
import '../services/resume_import_service.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';

class ResumeUploadPanel extends StatefulWidget {
  const ResumeUploadPanel({
    super.key,
    required this.repo,
    this.compact = false,
    this.onUploaded,
  });

  final AppRepository repo;
  final bool compact;
  final VoidCallback? onUploaded;

  @override
  State<ResumeUploadPanel> createState() => _ResumeUploadPanelState();
}

class _ResumeUploadPanelState extends State<ResumeUploadPanel> {
  final _importer = ResumeImportService();
  String? _resumeName;
  DateTime? _resumeUploaded;
  bool _uploading = false;
  bool _dragHover = false;

  bool get _desktopDrop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final resume = await widget.repo.getResume();
    if (!mounted) return;
    setState(() {
      _resumeName = resume?.filename;
      _resumeUploaded = resume?.uploadedAt;
    });
  }

  String _messageForError(ResumeImportException e) {
    final l10n = context.l10n;
    return switch (e.kind) {
      ResumeImportErrorKind.legacyDocFormat => l10n.resumeErrorLegacyDoc,
      ResumeImportErrorKind.unsupportedExtension =>
        l10n.resumeErrorUnsupportedExt(e.detail ?? ''),
      ResumeImportErrorKind.emptyDocument => l10n.resumeErrorEmptyDocx,
      ResumeImportErrorKind.invalidDocx => l10n.resumeErrorInvalidDocx,
    };
  }

  Future<void> _importResume({
    required String filename,
    String? sourcePath,
    List<int>? bytes,
  }) async {
    if (_uploading) return;
    final l10n = context.l10n;

    setState(() => _uploading = true);
    try {
      final imported = await _importer.importFile(
        filename: filename,
        sourcePath: sourcePath,
        bytes: bytes != null ? Uint8List.fromList(bytes) : null,
      );

      final appDir = await getApplicationSupportDirectory();
      final resumesDir = Directory(p.join(appDir.path, 'resumes'));
      if (!await resumesDir.exists()) {
        await resumesDir.create(recursive: true);
      }
      final destPath = p.join(resumesDir.path, imported.filename);

      if (sourcePath != null &&
          sourcePath.isNotEmpty &&
          sourcePath != destPath) {
        await File(sourcePath).copy(destPath);
      } else if (bytes != null) {
        await File(destPath).writeAsBytes(bytes, flush: true);
      }

      await widget.repo.saveResume(
        filename: imported.filename,
        filePath: destPath,
        extractedText: imported.text,
      );

      await _load();
      widget.onUploaded?.call();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminResumeUploaded(imported.filename))),
      );
    } on ResumeImportException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_messageForError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ResumeImportService.supportedExtensions,
      allowMultiple: false,
      withData: true,
      lockParentWindow: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final name = file.name;
    if (name.isEmpty) return;

    await _importResume(
      filename: name,
      sourcePath: file.path,
      bytes: file.bytes,
    );
  }

  Future<void> _onDropDone(DropDoneDetails details) async {
    if (details.files.isEmpty) return;
    final xfile = details.files.first;
    final name = xfile.name;
    if (name.isEmpty) return;

    final path = xfile.path;
    if (path.isNotEmpty) {
      await _importResume(filename: name, sourcePath: path);
      return;
    }

    final data = await xfile.readAsBytes();
    await _importResume(filename: name, bytes: data);
  }

  Widget _buildContent(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.all(widget.compact ? 16 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _dragHover
              ? palette.primary
              : palette.textSecondary.withValues(alpha: 0.25),
          width: _dragHover ? 2 : 1,
        ),
        color: _dragHover
            ? palette.primary.withValues(alpha: 0.06)
            : palette.backgroundElevated.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_resumeName != null) ...[
            Icon(Icons.description_outlined,
                size: 48, color: palette.primary),
            const SizedBox(height: 12),
            Text(
              _resumeName!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_resumeUploaded != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.adminResumeLoaded(dateFmt.format(_resumeUploaded!)),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
          ] else if (!widget.compact) ...[
            Icon(Icons.upload_file_outlined,
                size: 56, color: palette.textSecondary),
            const SizedBox(height: 16),
            Text(
              l10n.setupResumeSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          if (_desktopDrop)
            Text(
              l10n.resumeDragDropHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
            ),
          if (_desktopDrop) const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _uploading ? null : _pickResume,
            icon: _uploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.folder_open_outlined),
            label: Text(
              _resumeName == null ? l10n.btnUploadResume : l10n.btnReplaceResume,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);

    if (!_desktopDrop) {
      return child;
    }

    return DropTarget(
      onDragEntered: (_) => setState(() => _dragHover = true),
      onDragExited: (_) => setState(() => _dragHover = false),
      onDragDone: (details) {
        setState(() => _dragHover = false);
        _onDropDone(details);
      },
      child: child,
    );
  }
}
