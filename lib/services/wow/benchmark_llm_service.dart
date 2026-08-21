import '../../models/ai_settings.dart';
import '../../models/profile_language.dart';
import '../../models/profile_section.dart';
import '../../models/wow/benchmark_result.dart';
import '../../utils/llm_json_parse.dart';
import '../experience_structure_parser.dart';
import '../llm/llm_service.dart';

class BenchmarkLlmService {
  BenchmarkLlmService({LlmService? llm}) : _llm = llm ?? LlmService();

  final LlmService _llm;
  final _experienceParser = ExperienceStructureParser();

  Future<BenchmarkResult> compareToMedian({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
    double temperature = 0.3,
  }) async {
    final you = _computeYouMetrics(sections);

    if (!settings.canCallLlm) {
      return _fallback(you, targetRole);
    }

    try {
      final lang = _langName(profileLanguage);
      final system = '''
You are a labor-market data analyst for LinkedIn profiles.
Provide realistic MEDIAN benchmarks for seniority level implied by the role.
Write summary in $lang. Return ONLY valid JSON:
{
  "role": "normalized role label",
  "summary": "2-3 sentences comparing candidate to median",
  "dimensions": [
    {"key": "projects", "label": "Projects listed", "you": 0, "median": 4.2, "unit": "count", "max_value": 10},
    {"key": "skills", "label": "Top-tier skills", "you": 0, "median": 7, "unit": "count", "max_value": 15},
    {"key": "headline_len", "label": "Headline length", "you": 0, "median": 78, "unit": "chars", "max_value": 120},
    {"key": "about_len", "label": "About length", "you": 0, "median": 1200, "unit": "chars", "max_value": 2600},
    {"key": "experience_roles", "label": "Roles in Experience", "you": 0, "median": 4, "unit": "count", "max_value": 8},
    {"key": "certifications", "label": "Certifications", "you": 0, "median": 2, "unit": "count", "max_value": 6}
  ]
}
Use the candidate "you" values provided — do not invent candidate stats.
''';

      final user = '''
Target role: ${targetRole.isEmpty ? 'Senior professional' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'general' : targetIndustry}

Candidate metrics (you):
${you.entries.map((e) => '- ${e.key}: ${e.value}').join('\n')}

Set medians for this role level. Keep "you" values exactly as given in dimensions.
''';

      final raw = await _llm.complete(
        settings: settings,
        system: system,
        user: user,
        temperature: temperature,
      );
      final json = parseLlmJsonObject(raw);
      // Merge computed "you" into response
      final dims = (json['dimensions'] as List<dynamic>? ?? [])
          .map((d) {
            final m = Map<String, dynamic>.from(d as Map);
            final key = m['key']?.toString() ?? '';
            if (you.containsKey(key)) m['you'] = you[key];
            return BenchmarkDimension.fromJson(m);
          })
          .toList();
      return BenchmarkResult(
        dimensions: dims.isNotEmpty ? dims : _dimsFromYou(you, targetRole),
        role: targetRole,
        summary: json['summary']?.toString() ?? '',
        usedLlm: true,
      );
    } catch (e) {
      final fb = _fallback(you, targetRole);
      return BenchmarkResult(
        dimensions: fb.dimensions,
        role: fb.role,
        summary: fb.summary,
        usedLlm: false,
        errorDetail: e.toString(),
      );
    }
  }

  Map<String, double> _computeYouMetrics(List<ProfileSection> sections) {
    String text(String key) => sections
        .firstWhere((s) => s.key == key, orElse: () => sections.first)
        .content;

    final projects = text('projects').trim().isEmpty
        ? 0
        : text('projects').split('\n').where((l) => l.trim().isNotEmpty).length;
    final skills = text('skills').split(RegExp(r'[,;\n]')).where((s) => s.trim().length > 2).length;
    final certs = text('certifications').trim().isEmpty
        ? 0
        : text('certifications').split('\n').where((l) => l.trim().isNotEmpty).length;
    final roles = _experienceParser.parse(text('experience')).length;

    return {
      'projects': projects.toDouble(),
      'skills': skills.toDouble(),
      'headline_len': text('headline').trim().length.toDouble(),
      'about_len': text('about').trim().length.toDouble(),
      'experience_roles': roles.toDouble(),
      'certifications': certs.toDouble(),
    };
  }

  BenchmarkResult _fallback(Map<String, double> you, String role) {
    return BenchmarkResult(
      dimensions: _dimsFromYou(you, role),
      role: role.isEmpty ? 'Professional' : role,
      summary:
          'Compared to typical ${role.isEmpty ? "profiles" : role} medians (local benchmarks).',
      usedLlm: false,
    );
  }

  List<BenchmarkDimension> _dimsFromYou(Map<String, double> you, String role) {
    const medians = {
      'projects': 3.0,
      'skills': 8.0,
      'headline_len': 85.0,
      'about_len': 1100.0,
      'experience_roles': 4.0,
      'certifications': 2.0,
    };
    const labels = {
      'projects': 'Projects',
      'skills': 'Skills',
      'headline_len': 'Headline length',
      'about_len': 'About length',
      'experience_roles': 'Experience roles',
      'certifications': 'Certifications',
    };
    const maxVal = {
      'projects': 10.0,
      'skills': 15.0,
      'headline_len': 120.0,
      'about_len': 2600.0,
      'experience_roles': 8.0,
      'certifications': 6.0,
    };
    return you.entries
        .map(
          (e) => BenchmarkDimension(
            key: e.key,
            label: labels[e.key] ?? e.key,
            you: e.value,
            median: medians[e.key] ?? 5,
            maxValue: maxVal[e.key] ?? 10,
          ),
        )
        .toList();
  }

  String _langName(ProfileLanguage l) => switch (l) {
        ProfileLanguage.ru => 'Russian',
        ProfileLanguage.es => 'Spanish',
        _ => 'English',
      };
}
