import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/profile_evaluation.dart';
import 'section_l10n.dart';

String evaluationMessage(
  AppLocalizations l10n,
  ProfileEvaluationResult result,
) {
  switch (result.messageKind) {
    case EvaluationMessageKind.evaluatedViaProvider:
      final label = aiProviderLabel(l10n, result.evaluation.providerLabel ?? '');
      return l10n.scoreEvalViaProvider(label);
    case EvaluationMessageKind.localFallback:
      return l10n.scoreEvalLocalFallback;
    case EvaluationMessageKind.llmErrorFallback:
      return l10n.scoreEvalLlmErrorFallback(
        result.evaluation.errorDetail ?? '',
      );
  }
}
