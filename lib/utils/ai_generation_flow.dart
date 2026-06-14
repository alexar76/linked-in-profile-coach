import 'package:flutter/material.dart';

import '../models/ai_generation_prefs.dart';
import '../repositories/app_repository.dart';
import '../widgets/ai_generation_options_dialog.dart';

/// Returns prefs to use for generation (from dialog or saved defaults).
Future<AiGenerationPrefs> resolveAiGenerationPrefs(
  BuildContext context,
  AppRepository repo,
) async {
  var prefs = await repo.getAiGenerationPrefs();
  if (prefs.skipGenerationDialog) {
    return prefs;
  }

  if (!context.mounted) return prefs;

  final result = await showDialog<AiGenerationPrefs>(
    context: context,
    builder: (_) => AiGenerationOptionsDialog(initial: prefs),
  );

  if (result == null) {
    throw const AiGenerationCancelled();
  }

  prefs = result;
  await repo.saveAiGenerationPrefs(prefs);
  return prefs;
}

/// User closed the generation options dialog without confirming.
class AiGenerationCancelled implements Exception {
  const AiGenerationCancelled();
}
