import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../repositories/app_repository.dart';

String importResultMessage(AppLocalizations l10n, ImportResult result) {
  if (result.message == 'up_to_date') {
    return l10n.importUpToDate;
  }
  if (result.message == 'cancelled') {
    return l10n.importMergeCancelled;
  }
  if (!result.success) {
    if (result.sectionsFound == 0 && result.message.isEmpty) {
      return l10n.importFromUrlFailed;
    }
    return result.message.isNotEmpty
        ? result.message
        : l10n.importParseFailed;
  }
  return l10n.importSectionsImported(result.sectionsFound);
}
