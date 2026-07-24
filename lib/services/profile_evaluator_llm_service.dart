import 'dart:convert';

import '../models/ai_settings.dart';
import '../models/profile_evaluation.dart';
import '../models/profile_language.dart';
import '../models/profile_section.dart';
import '../models/recommendation_item.dart';
import 'llm/llm_service.dart';
import 'profile_evaluator_fallback.dart';

/// Independent recruiter-style evaluator — separate prompts from content generation.
class ProfileEvaluatorLlmService {
  ProfileEvaluatorLlmService({
    LlmService? llm,
    ProfileEvaluatorFallback? fallback,
  })  : _llm = llm ?? LlmService(),
        _fallback = fallback ?? ProfileEvaluatorFallback();

  final LlmService _llm;
  final ProfileEvaluatorFallback _fallback;

  Future<ProfileEvaluationResult> evaluate({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
  }) async {
    if (!settings.canCallLlm) {
      return ProfileEvaluationResult(
        evaluation: _fallback.evaluate(
          sections: sections,
          targetRole: targetRole,
          targetIndustry: targetIndustry,
          resumeText: resumeText,
        ),
        messageKind: EvaluationMessageKind.localFallback,
      );
    }

    try {
      final evaluation = await _evaluateViaLlm(
        settings: settings,
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        displayName: displayName,
        resumeText: resumeText,
        profileLanguage: profileLanguage,
      );
      return ProfileEvaluationResult(
        evaluation: evaluation,
        messageKind: EvaluationMessageKind.evaluatedViaProvider,
      );
    } catch (e) {
      final evaluation = _fallback.evaluate(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        resumeText: resumeText,
      );
      return ProfileEvaluationResult(
        evaluation: ProfileEvaluation(
          id: evaluation.id,
          evaluatedAt: evaluation.evaluatedAt,
          currentOverall: evaluation.currentOverall,
          aiOverall: evaluation.aiOverall,
          summary: evaluation.summary,
          currentBySection: evaluation.currentBySection,
          aiBySection: evaluation.aiBySection,
          recommendations: evaluation.recommendations,
          usedLlm: false,
          errorDetail: e.toString(),
        ),
        messageKind: EvaluationMessageKind.llmErrorFallback,
      );
    }
  }

  Future<ProfileEvaluation> _evaluateViaLlm({
    required AiSettings settings,
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    required ProfileLanguage profileLanguage,
  }) async {
    final langName = switch (profileLanguage) {
      ProfileLanguage.ru => 'Russian',
      ProfileLanguage.es => 'Spanish',
      ProfileLanguage.en => 'English',
    };

    final currentProfile = sections
        .map(
          (s) =>
              '### ${s.key}\n${s.content.isEmpty ? "(empty)" : s.content}',
        )
        .join('\n\n');

    final aiProfile = sections
        .where((s) => s.hasAiContent)
        .map((s) => '### ${s.key}\n${s.aiContent}')
        .join('\n\n');

    final system = '''
You are an independent senior recruiter and LinkedIn profile auditor.
You do NOT write marketing copy — you only evaluate and recommend.
Be strict, specific, and evidence-based. Score from 0 to 100 (integers).

Rubric per section: completeness, clarity, keyword fit for target role,
credibility (metrics, outcomes), structure, recruiter scan-ability.

Write ALL text fields (summary, feedback, recommendation titles/bodies) in $langName only.
Never mix languages in one response. If profile language is $langName, every recommendation title and body must be $langName.

Return ONLY valid JSON (no markdown fences) with this exact shape:
{
  "current_overall": 0-100,
  "ai_overall": 0-100 or 0 if no AI version exists,
  "summary": "2-4 sentences comparing current vs AI when available",
  "current_sections": {
    "headline": {"score": 0-100, "feedback": "one sentence"},
    "about": {"score": 0-100, "feedback": "..."},
    ...all section keys...
  },
  "ai_sections": {
    "headline": {"score": 0-100, "feedback": "..."},
    ...only sections that have AI text...
  },
  "recommendations": [
    {
      "section_key": "headline|about|...|general",
      "title": "short title",
      "body": "actionable advice",
      "priority": "high|medium|low",
      "category": "fill|promote|align"
    }
  ]
}

Section keys: headline, about, experience, education, skills, certifications,
projects, featured, volunteer, recommendations_received.
Use section_key "general" for cross-cutting tips.
Provide 3-8 recommendations, ordered by impact.
''';

    final user = '''
Target role: ${targetRole.isEmpty ? 'not specified' : targetRole}
Industry: ${targetIndustry.isEmpty ? 'not specified' : targetIndustry}
Candidate: ${displayName.isEmpty ? 'not specified' : displayName}

=== CURRENT LINKEDIN PROFILE (imported) ===
$currentProfile

=== AI-PROPOSED VERSION ===
${aiProfile.isEmpty ? '(not generated yet — set ai_overall to 0 and ai_sections to {})' : aiProfile}

${resumeText != null && resumeText.isNotEmpty ? 'Resume excerpt:\n${resumeText.length > 2500 ? resumeText.substring(0, 2500) : resumeText}' : ''}

Score the CURRENT profile in current_sections/current_overall.
Score the AI version in ai_sections/ai_overall when present.
Highlight the gap and best next actions in recommendations.
''';

    final raw = await _llm.complete(settings: settings, system: system, user: user);
    return _parseEvaluation(raw, sections, settings.provider.name);
  }

  ProfileEvaluation _parseEvaluation(
    String raw,
    List<ProfileSection> sections,
    String providerLabel,
  ) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      text = text.replaceFirst(RegExp(r'\s*```$'), '');
    }

    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FormatException('JSON not found in evaluator response');
    }

    final json = jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;

    final keys = sections.map((s) => s.key).toSet();
    final currentBySection = _parseSectionScores(
      json['current_sections'] as Map<String, dynamic>?,
      keys,
    );
    final aiBySection = _parseSectionScores(
      json['ai_sections'] as Map<String, dynamic>?,
      keys,
    );

    final recommendations = <RecommendationItem>[];
    final recs = json['recommendations'];
    if (recs is List) {
      for (final item in recs) {
        if (item is! Map<String, dynamic>) continue;
        final rec = _parseRecommendation(item);
        if (rec != null) recommendations.add(rec);
      }
    }

    return ProfileEvaluation(
      evaluatedAt: DateTime.now(),
      currentOverall: _clampScore(json['current_overall']),
      aiOverall: _clampScore(json['ai_overall']),
      summary: (json['summary'] as String?)?.trim() ?? '',
      currentBySection: currentBySection,
      aiBySection: aiBySection,
      recommendations: recommendations,
      usedLlm: true,
      providerLabel: providerLabel,
    );
  }

  Map<String, SectionScore> _parseSectionScores(
    Map<String, dynamic>? map,
    Set<String> validKeys,
  ) {
    if (map == null) return {};
    final result = <String, SectionScore>{};
    for (final entry in map.entries) {
      if (!validKeys.contains(entry.key)) continue;
      if (entry.value is Map<String, dynamic>) {
        result[entry.key] =
            SectionScore.fromJson(entry.value as Map<String, dynamic>);
      }
    }
    return result;
  }

  RecommendationItem? _parseRecommendation(Map<String, dynamic> json) {
    final title = (json['title'] as String?)?.trim();
    final body = (json['body'] as String?)?.trim();
    if (title == null || title.isEmpty || body == null || body.isEmpty) {
      return null;
    }

    final sectionKey = (json['section_key'] as String?)?.trim() ?? 'general';
    final priorityName = (json['priority'] as String?)?.toLowerCase() ?? 'medium';
    final categoryName = (json['category'] as String?)?.toLowerCase() ?? 'promote';

    final priority = RecommendationPriority.values.firstWhere(
      (p) => p.name == priorityName,
      orElse: () => RecommendationPriority.medium,
    );
    final category = RecommendationCategory.values.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => RecommendationCategory.promote,
    );

    return RecommendationItem(
      sectionKey: sectionKey == 'general' ? 'headline' : sectionKey,
      title: title,
      body: body,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
    );
  }

  int _clampScore(dynamic value) {
    if (value is num) return value.round().clamp(0, 100);
    return 0;
  }
}
