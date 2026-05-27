import 'dart:convert';

import '../models/ai_settings.dart';
import '../models/profile_language.dart';
import '../models/profile_section.dart';
import 'llm/llm_service.dart';
import 'profile_ai_generator.dart';

class ProfileAiLlmService {
  ProfileAiLlmService({
    LlmService? llm,
    ProfileAiGenerator? fallback,
  })  : _llm = llm ?? LlmService(),
        _fallback = fallback ?? ProfileAiGenerator();

  final LlmService _llm;
  final ProfileAiGenerator _fallback;

  Future<ProfileAiGenerationResult> generate({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
  }) async {
    if (!settings.canCallLlm) {
      return ProfileAiGenerationResult(
        sections: _fallback.generate(
          sections: sections,
          targetRole: targetRole,
          targetIndustry: targetIndustry,
          displayName: displayName,
          resumeText: resumeText,
          profileLanguage: profileLanguage,
        ),
        usedLlm: false,
        messageKind: AiGenerationMessage.localFallbackDisabled,
      );
    }

    try {
      final parsed = await _generateViaLlm(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
      );
      return ProfileAiGenerationResult(
        sections: parsed,
        usedLlm: true,
        messageKind: AiGenerationMessage.generatedViaProvider,
        providerLabel: settings.provider.name,
      );
    } catch (e) {
      return ProfileAiGenerationResult(
        sections: _fallback.generate(
          sections: sections,
          targetRole: targetRole,
          targetIndustry: targetIndustry,
          displayName: displayName,
          resumeText: resumeText,
          profileLanguage: profileLanguage,
        ),
        usedLlm: false,
        messageKind: AiGenerationMessage.llmErrorFallback,
        errorDetail: e.toString(),
      );
    }
  }

  Future<Map<String, String>> _generateViaLlm({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    required ProfileLanguage profileLanguage,
    Set<String>? onlyKeys,
  }) async {
    final targetSections = onlyKeys == null
        ? sections
        : sections.where((s) => onlyKeys.contains(s.key)).toList();

    final profileContext = sections
        .map((s) => '### ${s.key} (${s.title})\n${s.content.isEmpty ? "(empty)" : s.content}')
        .join('\n\n');

    final keysLine = targetSections.map((s) => s.key).join(', ');

    final langName = switch (profileLanguage) {
      ProfileLanguage.ru => 'Russian',
      ProfileLanguage.es => 'Spanish',
      ProfileLanguage.en => 'English',
    };

    final system = '''
You are a LinkedIn and personal branding expert. Improve the candidate profile for recruiters and search.
Write ALL section texts in $langName only. Do not mix languages.
Be specific: metrics, action verbs, keywords for the target role.
Return ONLY valid JSON without markdown wrappers, with keys for every section listed in the user message (use exact key names).
''';

    final user = '''
Target role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}
Name: ${displayName.isEmpty ? 'not specified' : displayName}

Current LinkedIn profile:
$profileContext

${resumeText != null && resumeText.isNotEmpty ? 'Resume excerpt:\n${resumeText.length > 3000 ? resumeText.substring(0, 3000) : resumeText}' : ''}

Generate improved text ONLY for these section keys: $keysLine
skills — comma-separated. For empty sections, propose a concise draft when relevant.
''';

    String? activity;
    for (final s in sections) {
      if (s.key == 'activity' && s.content.trim().isNotEmpty) {
        activity = s.content.trim();
        break;
      }
    }

    final toneBlock = activity != null && activity.isNotEmpty
        ? '\nMatch the writing tone of these recent posts/activity excerpts:\n$activity\n'
        : '';

    final raw = await _llm.complete(
      settings: settings,
      system: system,
      user: '$user$toneBlock',
    );
    return _parseJsonSections(raw, sections, onlyKeys: onlyKeys);
  }

  Future<ProfileAiGenerationResult> generateForSections({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required Set<String> sectionKeys,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
  }) async {
    final subset = sections.where((s) => sectionKeys.contains(s.key)).toList();
    if (subset.isEmpty) {
      return generate(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
      );
    }

    if (!settings.canCallLlm) {
      final all = _fallback.generate(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
      );
      return ProfileAiGenerationResult(
        sections: Map.fromEntries(
          sectionKeys.map((k) => MapEntry(k, all[k] ?? '')),
        ),
        usedLlm: false,
        messageKind: AiGenerationMessage.localFallbackDisabled,
      );
    }

    try {
      final parsed = await _generateViaLlm(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
        onlyKeys: sectionKeys,
      );
      final filtered = Map.fromEntries(
        parsed.entries.where((e) => sectionKeys.contains(e.key)),
      );
      return ProfileAiGenerationResult(
        sections: filtered,
        usedLlm: true,
        messageKind: AiGenerationMessage.generatedViaProvider,
        providerLabel: settings.provider.name,
      );
    } catch (e) {
      final all = _fallback.generate(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
      );
      return ProfileAiGenerationResult(
        sections: Map.fromEntries(
          sectionKeys.map((k) => MapEntry(k, all[k] ?? '')),
        ),
        usedLlm: false,
        messageKind: AiGenerationMessage.llmErrorFallback,
        errorDetail: e.toString(),
      );
    }
  }

  Map<String, String> _parseJsonSections(
    String raw,
    List<ProfileSection> sections, {
    Set<String>? onlyKeys,
  }) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      text = text.replaceFirst(RegExp(r'\s*```$'), '');
    }

    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FormatException('JSON не найден в ответе');
    }

    final json = jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;
    final keys = onlyKeys ?? sections.map((s) => s.key).toSet();
    final result = <String, String>{};

    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        result[key] = value.trim();
      }
    }

    final minExpected = onlyKeys != null && onlyKeys.length < 3
        ? 1
        : 3;
    if (result.length < minExpected) {
      throw FormatException('Мало разделов в ответе: ${result.length}');
    }

    for (final section in sections) {
      result.putIfAbsent(
        section.key,
        () => section.content.isNotEmpty ? section.content : section.hint,
      );
    }

    return result;
  }
}

enum AiGenerationMessage {
  localFallbackDisabled,
  generatedViaProvider,
  llmErrorFallback,
}

class ProfileAiGenerationResult {
  const ProfileAiGenerationResult({
    required this.sections,
    required this.usedLlm,
    required this.messageKind,
    this.providerLabel,
    this.errorDetail,
  });

  final Map<String, String> sections;
  final bool usedLlm;
  final AiGenerationMessage messageKind;
  final String? providerLabel;
  final String? errorDetail;
}
