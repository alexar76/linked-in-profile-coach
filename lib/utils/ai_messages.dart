import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../services/profile_ai_llm_service.dart';
import 'section_l10n.dart';

String aiGenerationMessage(AppLocalizations l10n, ProfileAiGenerationResult result) {
  switch (result.messageKind) {
    case AiGenerationMessage.localFallbackDisabled:
      return l10n.aiGenLocalFallback;
    case AiGenerationMessage.generatedViaProvider:
      final label = aiProviderLabel(l10n, result.providerLabel ?? 'deepseek');
      return l10n.aiGenViaProvider(label);
    case AiGenerationMessage.llmErrorFallback:
      return l10n.aiGenLlmErrorFallback(result.errorDetail ?? '');
  }
}
