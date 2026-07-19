import '../../models/ai_settings.dart';
import '../../models/profile_language.dart';
import '../../models/profile_section.dart';
import '../../models/wow/recruiter_simulator_result.dart';
import '../../utils/llm_json_parse.dart';
import '../llm/llm_service.dart';

class RecruiterSimulatorLlmService {
  RecruiterSimulatorLlmService({LlmService? llm}) : _llm = llm ?? LlmService();

  final LlmService _llm;

  Future<RecruiterSimulatorResult> simulate({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
    double temperature = 0.5,
  }) async {
    if (!settings.canCallLlm) {
      return _fallback(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
      );
    }

    try {
      final lang = _langName(profileLanguage);
      final profile = sections
          .map((s) =>
              '### ${s.key}\n${s.content.isEmpty ? "(empty)" : s.content}')
          .join('\n\n');

      final system = '''
You are a senior recruiter hiring for: $targetRole in $targetIndustry.
You are skeptical but fair. You do NOT write marketing copy.
Write ALL output in $lang only.
Return ONLY valid JSON (no markdown):
{
  "verdict": "interview|maybe|pass",
  "verdict_summary": "2-4 sentences: would you invite to interview and why",
  "overall_score": 0-100,
  "questions": [
    {"question": "tough question you'd ask", "concern": "what gap it probes"}
  ],
  "section_heatmap": {
    "headline": "strong|neutral|weak",
    "about": "strong|neutral|weak",
    "experience": "strong|neutral|weak",
    "skills": "strong|neutral|weak",
    "education": "strong|neutral|weak"
  }
}
Provide 5-7 questions. Heatmap must include headline, about, experience, skills, education.
''';

      final user = '''
Candidate: ${displayName.isEmpty ? 'Unknown' : displayName}
Target role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}

Profile:
$profile
${resumeText != null && resumeText.isNotEmpty ? '\nResume excerpt:\n${resumeText.length > 2500 ? resumeText.substring(0, 2500) : resumeText}' : ''}

Simulate your screening: questions, verdict, section heatmap.
''';

      final raw = await _llm.complete(
        settings: settings,
        system: system,
        user: user,
        temperature: temperature,
      );
      return RecruiterSimulatorResult.fromJson(
        parseLlmJsonObject(raw),
        usedLlm: true,
        role: targetRole,
        industry: targetIndustry,
      );
    } catch (e) {
      final fb = _fallback(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
      );
      return RecruiterSimulatorResult(
        verdict: fb.verdict,
        verdictSummary: fb.verdictSummary,
        questions: fb.questions,
        sectionHeatmap: fb.sectionHeatmap,
        overallScore: fb.overallScore,
        usedLlm: false,
        role: targetRole,
        industry: targetIndustry,
        errorDetail: e.toString(),
      );
    }
  }

  RecruiterSimulatorResult _fallback({
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
  }) {
    final heat = <String, SectionHeat>{};
    for (final s in sections) {
      if (!['headline', 'about', 'experience', 'skills', 'education']
          .contains(s.key)) {
        continue;
      }
      final len = s.content.trim().length;
      heat[s.key] = len > 120
          ? SectionHeat.strong
          : len > 30
              ? SectionHeat.neutral
              : SectionHeat.weak;
    }
    final weak = heat.values.where((h) => h == SectionHeat.weak).length;
    final score = (70 - weak * 12).clamp(20, 85);
    return RecruiterSimulatorResult(
      verdict: score >= 60 ? RecruiterVerdict.maybe : RecruiterVerdict.pass,
      verdictSummary:
          'Local screening for ${targetRole.isEmpty ? "your target role" : targetRole}: '
          '${weak == 0 ? "profile sections look complete." : "$weak key sections need more substance."}',
      questions: [
        RecruiterQuestion(
          question: targetRole.isNotEmpty
              ? 'Walk me through your impact in a $targetRole role.'
              : 'What measurable outcomes did you deliver in your last role?',
          concern: 'Evidence of results',
        ),
        const RecruiterQuestion(
          question: 'Why are you looking now, and what gap are you trying to close?',
          concern: 'Motivation and fit',
        ),
      ],
      sectionHeatmap: heat,
      overallScore: score,
      usedLlm: false,
      role: targetRole,
      industry: targetIndustry,
    );
  }

  String _langName(ProfileLanguage l) => switch (l) {
        ProfileLanguage.ru => 'Russian',
        ProfileLanguage.es => 'Spanish',
        _ => 'English',
      };
}
