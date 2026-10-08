import 'dart:convert';

import '../models/ai_generation_prefs.dart';
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
    AiGenerationPrefs prefs = const AiGenerationPrefs(),
  }) async {
    return _runGeneration(
      settings: settings,
      sections: sections,
      targetRole: targetRole,
      targetIndustry: targetIndustry,
      displayName: displayName,
      resumeText: resumeText,
      profileLanguage: profileLanguage,
      prefs: prefs,
      onlyKeys: null,
    );
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
    AiGenerationPrefs prefs = const AiGenerationPrefs(),
  }) async {
    if (sectionKeys.isEmpty) {
      return generate(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
        prefs: prefs,
      );
    }
    return _runGeneration(
      settings: settings,
      sections: sections,
      targetRole: targetRole,
      targetIndustry: targetIndustry,
      displayName: displayName,
      resumeText: resumeText,
      profileLanguage: profileLanguage,
      prefs: prefs,
      onlyKeys: sectionKeys,
    );
  }

  Future<ProfileAiGenerationResult> _runGeneration({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    required ProfileLanguage profileLanguage,
    required AiGenerationPrefs prefs,
    required Set<String>? onlyKeys,
  }) async {
    Map<String, String> fallbackMap() => _fallback.generate(
          sections: sections,
          targetRole: targetRole,
          targetIndustry: targetIndustry,
          displayName: displayName,
          resumeText: resumeText,
          profileLanguage: profileLanguage,
        );

    if (!settings.canCallLlm) {
      final all = fallbackMap();
      final filtered = _filterKeys(all, onlyKeys);
      return ProfileAiGenerationResult(
        sections: filtered,
        variantsBySection: _singleVariantMap(filtered),
        usedLlm: false,
        messageKind: AiGenerationMessage.localFallbackDisabled,
      );
    }

    try {
      final variants = await _generateVariantsViaLlm(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
        prefs: prefs,
        onlyKeys: onlyKeys,
      );
      final active = {
        for (final e in variants.entries) e.key: e.value.first,
      };
      return ProfileAiGenerationResult(
        sections: active,
        variantsBySection: variants,
        usedLlm: true,
        messageKind: AiGenerationMessage.generatedViaProvider,
        providerLabel: settings.provider.name,
      );
    } catch (e) {
      final all = fallbackMap();
      final filtered = _filterKeys(all, onlyKeys);
      return ProfileAiGenerationResult(
        sections: filtered,
        variantsBySection: _singleVariantMap(filtered),
        usedLlm: false,
        messageKind: AiGenerationMessage.llmErrorFallback,
        errorDetail: e.toString(),
      );
    }
  }

  Map<String, String> _filterKeys(
    Map<String, String> map,
    Set<String>? onlyKeys,
  ) {
    if (onlyKeys == null) return map;
    return Map.fromEntries(
      map.entries.where((e) => onlyKeys.contains(e.key)),
    );
  }

  Map<String, List<String>> _singleVariantMap(Map<String, String> map) =>
      map.map((k, v) => MapEntry(k, [v]));

  Future<Map<String, List<String>>> _generateVariantsViaLlm({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    required ProfileLanguage profileLanguage,
    required AiGenerationPrefs prefs,
    Set<String>? onlyKeys,
  }) async {
    final count = prefs.variantCount.clamp(1, 3);
    final perVariant = <Map<String, String>>[];

    for (var i = 0; i < count; i++) {
      final parsed = await _generateViaLlm(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
        prefs: prefs,
        onlyKeys: onlyKeys,
        variantIndex: i,
        variantCount: count,
      );
      perVariant.add(parsed);
    }

    final keys = onlyKeys ?? sections.map((s) => s.key).toSet();
    final merged = <String, List<String>>{};
    for (final key in keys) {
      final texts = <String>[];
      for (final variant in perVariant) {
        final text = variant[key];
        if (text != null &&
            text.trim().isNotEmpty &&
            !texts.contains(text.trim())) {
          texts.add(text.trim());
        }
      }
      if (texts.isNotEmpty) {
        merged[key] = texts;
      }
    }
    return merged;
  }

  Future<Map<String, String>> _generateViaLlm({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    required ProfileLanguage profileLanguage,
    required AiGenerationPrefs prefs,
    Set<String>? onlyKeys,
    int variantIndex = 0,
    int variantCount = 1,
  }) async {
    final targetSections = onlyKeys == null
        ? sections
        : sections.where((s) => onlyKeys.contains(s.key)).toList();

    final profileContext = sections
        .map((s) =>
            '### ${s.key} (${s.title})\n${s.content.isEmpty ? "(empty)" : s.content}')
        .join('\n\n');

    final keysLine = targetSections.map((s) => s.key).join(', ');

    final langName = switch (profileLanguage) {
      ProfileLanguage.ru => 'Russian',
      ProfileLanguage.es => 'Spanish',
      ProfileLanguage.en => 'English',
    };

    final focusLine = _focusInstruction(prefs.focus);

    final system = '''
You are a LinkedIn and personal branding expert. $focusLine
Write ALL section texts in $langName only. Do not mix languages.
Be specific: metrics, action verbs, keywords aligned with the goal.
Return ONLY valid JSON without markdown wrappers, with keys for every section listed in the user message (use exact key names).
''';

    final variantBlock = variantCount > 1
        ? '\nThis is alternative draft ${variantIndex + 1} of $variantCount. Make it meaningfully different in wording and emphasis from other drafts while keeping the same strategic goal.\n'
        : '';

    final user = '''
Target role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}
Name: ${displayName.isEmpty ? 'not specified' : displayName}
$variantBlock
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
      temperature: prefs.temperature,
    );
    return _parseJsonSections(raw, sections, onlyKeys: onlyKeys);
  }

  static String _focusInstruction(ProfileAiFocus focus) => switch (focus) {
        ProfileAiFocus.jobSearch =>
          'Optimize the profile for job search: recruiters, ATS keywords, and role fit.',
        ProfileAiFocus.networking =>
          'Optimize for professional networking: warm intros, collaboration, and community.',
        ProfileAiFocus.thoughtLeadership =>
          'Optimize for thought leadership: authority, insights, and audience growth.',
        ProfileAiFocus.freelance =>
          'Optimize for freelance/client work: services, outcomes, and trust signals.',
      };

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
      throw const FormatException('JSON not found in response');
    }

    final json =
        jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;
    final keys = onlyKeys ?? sections.map((s) => s.key).toSet();
    final result = <String, String>{};

    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        result[key] = value.trim();
      }
    }

    final minExpected =
        onlyKeys != null && onlyKeys.length < 3 ? 1 : 3;
    if (result.length < minExpected) {
      throw FormatException('Too few sections in response: ${result.length}');
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
    this.variantsBySection,
    this.providerLabel,
    this.errorDetail,
  });

  final Map<String, String> sections;
  final Map<String, List<String>>? variantsBySection;
  final bool usedLlm;
  final AiGenerationMessage messageKind;
  final String? providerLabel;
  final String? errorDetail;
}
