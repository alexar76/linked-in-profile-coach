import '../../models/ai_settings.dart';
import '../../models/ats_match_result.dart';
import '../../models/profile_language.dart';
import '../../models/profile_section.dart';
import '../../models/wow/job_fit_result.dart';
import '../../utils/llm_json_parse.dart';
import '../ats_keyword_service.dart';
import '../llm/llm_service.dart';

class JobFitLlmService {
  JobFitLlmService({
    LlmService? llm,
    AtsKeywordService? ats,
  })  : _llm = llm ?? LlmService(),
        _ats = ats ?? AtsKeywordService();

  final LlmService _llm;
  final AtsKeywordService _ats;

  Future<JobFitResult> analyze({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String jobDescription,
    required String targetRole,
    required String targetIndustry,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
    double temperature = 0.4,
  }) async {
    final atsBaseline = _ats.analyze(
      sections: sections,
      targetRole: _extractRoleFromJob(jobDescription, targetRole),
      targetIndustry: targetIndustry,
    );

    if (!settings.canCallLlm) {
      return _fromAts(atsBaseline, jobDescription);
    }

    try {
      final lang = _langName(profileLanguage);
      final profile = sections
          .where((s) =>
              ['headline', 'about', 'experience', 'skills', 'education']
                  .contains(s.key))
          .map((s) =>
              '### ${s.key}\n${s.content.isEmpty ? "(empty)" : s.content}')
          .join('\n\n');

      final system = '''
You are an ATS and hiring manager analyst. Compare a LinkedIn profile to a job posting.
Write ALL text in $lang. Return ONLY valid JSON:
{
  "job_title": "extracted title",
  "match_percent": 0-100,
  "matched_keywords": ["..."],
  "missing_keywords": ["..."],
  "summary": "2-3 sentences",
  "gaps": [
    {"section_key": "skills|experience|about|headline", "issue": "...", "suggestion": "..."}
  ],
  "section_edits": {
    "headline": "tailored headline text or omit key",
    "about": "optional tailored about excerpt",
    "skills": "comma-separated skills line"
  }
}
Be specific and actionable. section_edits only for keys you can improve.
''';

      final user = '''
Job posting:
${jobDescription.length > 6000 ? jobDescription.substring(0, 6000) : jobDescription}

Candidate profile:
$profile

ATS baseline score: ${atsBaseline.scorePercent}%
Missing keywords hint: ${atsBaseline.missingKeywords.take(12).join(', ')}
''';

      final raw = await _llm.complete(
        settings: settings,
        system: system,
        user: user,
        temperature: temperature,
      );
      return JobFitResult.fromJson(
        parseLlmJsonObject(raw),
        usedLlm: true,
      );
    } catch (e) {
      final fb = _fromAts(atsBaseline, jobDescription);
      return JobFitResult(
        matchPercent: fb.matchPercent,
        matchedKeywords: fb.matchedKeywords,
        missingKeywords: fb.missingKeywords,
        gaps: fb.gaps,
        sectionEdits: fb.sectionEdits,
        jobTitle: fb.jobTitle,
        summary: fb.summary,
        usedLlm: false,
        errorDetail: e.toString(),
      );
    }
  }

  JobFitResult _fromAts(AtsMatchResult ats, String jobText) {
    final gaps = ats.missingKeywords.take(6).map((kw) {
      return JobFitGap(
        sectionKey: 'skills',
        issue: 'Missing keyword: $kw',
        suggestion: 'Add "$kw" to Skills or weave into Experience bullets.',
      );
    }).toList();

    return JobFitResult(
      matchPercent: ats.scorePercent,
      matchedKeywords: ats.matchedKeywords,
      missingKeywords: ats.missingKeywords,
      gaps: gaps,
      sectionEdits: {},
      jobTitle: _extractRoleFromJob(jobText, ats.targetRole),
      summary:
          'Keyword match ${ats.scorePercent}% for ${ats.targetRole.isEmpty ? "this role" : ats.targetRole}.',
      usedLlm: false,
    );
  }

  String _extractRoleFromJob(String job, String fallback) {
    final lines = job.split('\n').where((l) => l.trim().isNotEmpty);
    if (lines.isEmpty) return fallback;
    final first = lines.first.trim();
    if (first.length < 80) return first;
    return fallback;
  }

  String _langName(ProfileLanguage l) => switch (l) {
        ProfileLanguage.ru => 'Russian',
        ProfileLanguage.es => 'Spanish',
        _ => 'English',
      };
}
