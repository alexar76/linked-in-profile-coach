import '../../models/ai_settings.dart';
import '../../models/profile_language.dart';
import '../../models/profile_section.dart';
import '../../models/wow/career_what_if_result.dart';
import '../../utils/llm_json_parse.dart';
import '../experience_structure_parser.dart';
import '../llm/llm_service.dart';

class CareerWhatIfLlmService {
  CareerWhatIfLlmService({LlmService? llm}) : _llm = llm ?? LlmService();

  final LlmService _llm;
  final _experienceParser = ExperienceStructureParser();

  Future<CareerWhatIfResult> forecast({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
    int extraSeniorYears = 0,
    String? extraCourse,
    double temperature = 0.65,
  }) async {
    if (!settings.canCallLlm) {
      return _fallback(
        sections: sections,
        targetRole: targetRole,
        extraSeniorYears: extraSeniorYears,
        extraCourse: extraCourse,
      );
    }

    try {
      final lang = _langName(profileLanguage);
      final experience = sections
          .firstWhere((s) => s.key == 'experience', orElse: () => sections.first)
          .content;
      final roles = _experienceParser.parse(experience);
      final timeline = roles
          .take(8)
          .map((r) => '${r.title} @ ${r.company} (${r.period})')
          .join('\n');

      final skills = sections
          .firstWhere((s) => s.key == 'skills', orElse: () => sections.first)
          .content;

      final system = '''
You are a career strategist. Project realistic next steps based on current trajectory.
Write ALL output in $lang. Return ONLY valid JSON:
{
  "milestones": [
    {"year_offset": 1, "title": "role or milestone", "description": "1-2 sentences"},
    {"year_offset": 3, "title": "...", "description": "..."},
    {"year_offset": 5, "title": "...", "description": "..."}
  ],
  "skills_to_add": ["skill1", "skill2"],
  "narrative": "3-4 sentence overview of the path"
}
year_offset is years from now (1, 3, 5). Be realistic for $targetRole in $targetIndustry.
''';

      final whatIf = StringBuffer();
      if (extraSeniorYears > 0) {
        whatIf.writeln('Scenario adjustment: +$extraSeniorYears years senior experience.');
      }
      if (extraCourse != null && extraCourse.trim().isNotEmpty) {
        whatIf.writeln('Scenario adjustment: completes course/training in $extraCourse.');
      }

      final user = '''
Target role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}
$whatIf
Experience timeline:
$timeline

Skills: ${skills.isEmpty ? "(none listed)" : skills}
${resumeText != null && resumeText.isNotEmpty ? '\nResume excerpt:\n${resumeText.length > 2000 ? resumeText.substring(0, 2000) : resumeText}' : ''}

Forecast 1/3/5 year milestones and skills to add.
''';

      final raw = await _llm.complete(
        settings: settings,
        system: system,
        user: user,
        temperature: temperature,
      );
      return CareerWhatIfResult.fromJson(
        parseLlmJsonObject(raw),
        usedLlm: true,
        extraSeniorYears: extraSeniorYears,
        extraCourse: extraCourse,
      );
    } catch (e) {
      final fb = _fallback(
        sections: sections,
        targetRole: targetRole,
        extraSeniorYears: extraSeniorYears,
        extraCourse: extraCourse,
      );
      return CareerWhatIfResult(
        milestones: fb.milestones,
        skillsToAdd: fb.skillsToAdd,
        narrative: fb.narrative,
        extraSeniorYears: extraSeniorYears,
        extraCourse: extraCourse,
        usedLlm: false,
        errorDetail: e.toString(),
      );
    }
  }

  CareerWhatIfResult _fallback({
    required List<ProfileSection> sections,
    required String targetRole,
    int extraSeniorYears = 0,
    String? extraCourse,
  }) {
    final exp = sections
        .firstWhere((s) => s.key == 'experience', orElse: () => sections.first)
        .content;
    final roles = _experienceParser.parse(exp);
    final currentTitle = roles.isNotEmpty ? roles.first.title : 'Professional';

    final roleLabel = targetRole.isEmpty ? currentTitle : targetRole;
    return CareerWhatIfResult(
      milestones: [
        CareerMilestone(
          yearOffset: 1,
          title: extraCourse != null ? 'Applied $extraCourse' : 'Scope expansion',
          description:
              'Deepen impact as $roleLabel${extraSeniorYears > 0 ? " with +$extraSeniorYears yr seniority" : ""}.',
        ),
        CareerMilestone(
          yearOffset: 3,
          title: 'Senior $roleLabel',
          description: 'Lead larger initiatives; mentor others.',
        ),
        CareerMilestone(
          yearOffset: 5,
          title: 'Staff / Principal track',
          description: 'Strategic ownership; cross-functional influence.',
        ),
      ],
      skillsToAdd: ['Leadership', 'Stakeholder management', 'Domain depth'],
      narrative:
          'Based on your experience block, a realistic path moves from $currentTitle toward $roleLabel over 5 years.',
      extraSeniorYears: extraSeniorYears,
      extraCourse: extraCourse,
      usedLlm: false,
    );
  }

  String _langName(ProfileLanguage l) => switch (l) {
        ProfileLanguage.ru => 'Russian',
        ProfileLanguage.es => 'Spanish',
        _ => 'English',
      };
}
