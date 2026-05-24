import '../../models/ai_generation_prefs.dart';
import '../../models/ai_settings.dart';
import '../../models/profile_language.dart';
import '../../models/profile_section.dart';
import '../../models/wow/headline_ab_result.dart';
import '../../utils/llm_json_parse.dart';
import '../llm/llm_service.dart';
import '../profile_ai_llm_service.dart';

class HeadlineAbLlmService {
  HeadlineAbLlmService({
    LlmService? llm,
    ProfileAiLlmService? profileAi,
  })  : _llm = llm ?? LlmService(),
        _profileAi = profileAi ?? ProfileAiLlmService();

  final LlmService _llm;
  final ProfileAiLlmService _profileAi;

  static const _variantCount = 5;

  Future<HeadlineAbResult> generateAndRank({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
    bool includeAbout = true,
    double temperature = 0.75,
  }) async {
    if (!settings.canCallLlm) {
      return _fallback(sections, targetRole);
    }

    try {
      final lang = _langName(profileLanguage);
      final headline = sections
          .firstWhere((s) => s.key == 'headline', orElse: () => sections.first)
          .content;
      final about = sections
          .firstWhere((s) => s.key == 'about', orElse: () => sections.first)
          .content;

      // Step 1: generate 5 headline candidates
      final genResult = await _profileAi.generateForSections(
        settings: settings,
        sections: sections,
        sectionKeys: {'headline'},
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
        prefs: AiGenerationPrefs(
          creativity: temperature.clamp(0.0, 1.0),
          variantCount: 3,
          focus: ProfileAiFocus.jobSearch,
        ),
      );

      final candidates = <String>{headline};
      candidates.addAll(genResult.variantsBySection?['headline'] ?? []);
      if (genResult.sections['headline'] != null) {
        candidates.add(genResult.sections['headline']!);
      }

      // Step 2: ask LLM for 5 distinct headlines + scores
      final system = '''
You are a LinkedIn headline A/B testing expert.
Write in $lang. Return ONLY valid JSON:
{
  "headline_variants": [
    {
      "text": "headline under 220 chars",
      "ats": 0-100,
      "readability": 0-100,
      "hook": 0-100,
      "uniqueness": 0-100,
      "overall": 0-100
    }
  ],
  "about_variants": []
}
Provide exactly $_variantCount headline_variants, meaningfully different.
Score: ATS keyword fit, readability, hook power, uniqueness vs clichés.
overall = weighted average you justify internally.
''';

      final user = '''
Role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}
Current headline: ${headline.isEmpty ? "(empty)" : headline}
Current about (excerpt): ${about.length > 400 ? about.substring(0, 400) : about}

Seed ideas from generation:
${candidates.where((c) => c.trim().isNotEmpty).take(5).join('\n---\n')}

${includeAbout ? 'Also add 2 about_variants with same score fields if about is weak.' : 'about_variants: []'}
''';

      final raw = await _llm.complete(
        settings: settings,
        system: system,
        user: user,
        temperature: temperature,
      );
      return HeadlineAbResult.fromJson(
        parseLlmJsonObject(raw),
        usedLlm: true,
      );
    } catch (e) {
      final fb = _fallback(sections, targetRole);
      return HeadlineAbResult(
        headlineVariants: fb.headlineVariants,
        aboutVariants: fb.aboutVariants,
        usedLlm: false,
        errorDetail: e.toString(),
      );
    }
  }

  HeadlineAbResult _fallback(List<ProfileSection> sections, String role) {
    final h = sections
        .firstWhere((s) => s.key == 'headline', orElse: () => sections.first)
        .content
        .trim();
    final base = h.isNotEmpty
        ? h
        : (role.isNotEmpty ? '$role | Results-driven professional' : 'Professional');
    final variants = [
      HeadlineVariantScore(
        text: base,
        ats: 70,
        readability: 75,
        hook: 60,
        uniqueness: 55,
        overall: 65,
      ),
      HeadlineVariantScore(
        text: role.isNotEmpty ? '$role — measurable impact & leadership' : base,
        ats: 72,
        readability: 70,
        hook: 68,
        uniqueness: 58,
        overall: 67,
      ),
    ];
    return HeadlineAbResult(headlineVariants: variants, usedLlm: false);
  }

  String _langName(ProfileLanguage l) => switch (l) {
        ProfileLanguage.ru => 'Russian',
        ProfileLanguage.es => 'Spanish',
        _ => 'English',
      };
}
