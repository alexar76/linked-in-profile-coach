import '../models/profile_evaluation.dart';
import '../models/profile_section.dart';
import '../models/recommendation_item.dart';

/// Rule-based scorer when LLM is unavailable — separate from [ProfileAnalyzer].
class ProfileEvaluatorFallback {
  ProfileEvaluation evaluate({
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String? resumeText,
  }) {
    final currentBySection = <String, SectionScore>{};
    final aiBySection = <String, SectionScore>{};
    final recommendations = <RecommendationItem>[];

    for (final section in sections) {
      currentBySection[section.key] = _scoreText(
        section.content,
        section.key,
        targetRole: targetRole,
      );
      if (section.hasAiContent) {
        aiBySection[section.key] = _scoreText(
          section.aiContent,
          section.key,
          targetRole: targetRole,
          isAi: true,
        );
      }
    }

    final currentOverall = _average(currentBySection.values.map((s) => s.score));
    final aiOverall = aiBySection.isEmpty
        ? 0
        : _average(aiBySection.values.map((s) => s.score));

    if (currentOverall < 50) {
      recommendations.add(
        _rec(
          'headline',
          'Strengthen core sections',
          'Fill headline, about, and experience first — they drive most recruiter impressions.',
          RecommendationPriority.high,
          RecommendationCategory.fill,
        ),
      );
    }

    if (aiOverall > currentOverall + 5) {
      recommendations.add(
        _rec(
          'about',
          'AI draft is stronger',
          'The AI version scores higher overall. Review Compare and adopt the best paragraphs.',
          RecommendationPriority.medium,
          RecommendationCategory.promote,
        ),
      );
    }

    if (resumeText != null && resumeText.trim().length > 200) {
      final skills = sections.where((s) => s.key == 'skills').firstOrNull;
      if (skills != null && skills.content.trim().isEmpty) {
        recommendations.add(
          _rec(
            'skills',
            'Sync skills from resume',
            'Your resume has detail but skills are empty — align keywords for search.',
            RecommendationPriority.high,
            RecommendationCategory.align,
          ),
        );
      }
    }

    final summary = aiOverall > 0
        ? 'Heuristic review: current $currentOverall/100, AI draft $aiOverall/100. '
            'Connect an LLM for recruiter-grade scoring.'
        : 'Heuristic review: current profile $currentOverall/100. '
            'Generate an AI version, then score again.';

    return ProfileEvaluation(
      evaluatedAt: DateTime.now(),
      currentOverall: currentOverall,
      aiOverall: aiOverall,
      summary: summary,
      currentBySection: currentBySection,
      aiBySection: aiBySection,
      recommendations: recommendations,
      usedLlm: false,
    );
  }

  SectionScore _scoreText(
    String text,
    String sectionKey, {
    required String targetRole,
    bool isAi = false,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return SectionScore(
        score: 0,
        feedback: isAi ? 'AI section empty' : 'Section not filled',
      );
    }

    var score = 35;
    final len = trimmed.length;

    switch (sectionKey) {
      case 'headline':
        if (len >= 50 && len <= 180) score += 25;
        if (len < 40) score += 5;
        if (_hasNumbers(trimmed)) score += 10;
        break;
      case 'about':
        if (len >= 400) { score += 30; }
        else if (len >= 150) { score += 15; }
        if (trimmed.contains('\n')) score += 5;
        break;
      case 'experience':
        if (len >= 300) score += 25;
        if (_hasNumbers(trimmed)) score += 15;
        if (trimmed.toLowerCase().contains('led ') ||
            trimmed.toLowerCase().contains('built ')) {
          score += 5;
        }
        break;
      case 'skills':
        final count = trimmed.split(RegExp(r'[,;\n]')).where((s) => s.trim().length > 1).length;
        score += (count * 4).clamp(0, 35);
        break;
      default:
        if (len >= 80) { score += 20; }
        else if (len >= 30) { score += 10; }
    }

    if (targetRole.isNotEmpty) {
      final roleToken = targetRole.split(' ').first.toLowerCase();
      if (roleToken.length > 3 && trimmed.toLowerCase().contains(roleToken)) {
        score += 10;
      }
    }

    score = score.clamp(0, 100);
    return SectionScore(
      score: score,
      feedback: _feedbackFor(score, sectionKey, isAi),
    );
  }

  String _feedbackFor(int score, String sectionKey, bool isAi) {
    final prefix = isAi ? 'AI' : 'Current';
    if (score >= 80) return '$prefix: strong for $sectionKey';
    if (score >= 55) return '$prefix: acceptable — room to improve';
    return '$prefix: needs work';
  }

  bool _hasNumbers(String text) => RegExp(r'\d').hasMatch(text);

  int _average(Iterable<int> values) {
    final list = values.toList();
    if (list.isEmpty) return 0;
    return (list.reduce((a, b) => a + b) / list.length).round();
  }

  RecommendationItem _rec(
    String sectionKey,
    String title,
    String body,
    RecommendationPriority priority,
    RecommendationCategory category,
  ) {
    return RecommendationItem(
      sectionKey: sectionKey,
      title: title,
      body: body,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
    );
  }
}
