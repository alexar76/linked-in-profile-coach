import 'package:flutter/material.dart';

import '../repositories/app_repository.dart';
import '../widgets/import_merge_dialog.dart';
import 'import_messages.dart';
import 'l10n_ext.dart';

/// Shows merge dialog when needed and applies import.
Future<ImportResult> runImportWithMerge(
  BuildContext context,
  AppRepository repo,
  ImportResult result,
) async {
  final l10n = context.l10n;
  final pending = result.pending;

  if (!result.success) {
    return result;
  }

  if (result.message == 'up_to_date') {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.importUpToDate)),
    );
    return result;
  }

  if (pending == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(importResultMessage(l10n, result))),
    );
    return result;
  }

  final keys = await ImportMergeDialog.show(
    context,
    diffs: pending.diffs,
    sourceLabel: pending.sourceLabel,
  );
  if (keys == null || !context.mounted) {
    return const ImportResult(
      success: false,
      sectionsFound: 0,
      message: 'cancelled',
    );
  }

  final applied = await repo.applyPendingImport(pending, keys);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(importResultMessage(l10n, applied))),
    );
  }
  return applied;
}
