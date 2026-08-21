enum RecruiterVerdict { interview, maybe, pass }

enum SectionHeat { strong, neutral, weak }

class RecruiterQuestion {
  const RecruiterQuestion({required this.question, required this.concern});

  final String question;
  final String concern;
}

class RecruiterSimulatorResult {
  const RecruiterSimulatorResult({
    required this.verdict,
    required this.verdictSummary,
    required this.questions,
    required this.sectionHeatmap,
    required this.overallScore,
    required this.usedLlm,
    this.role,
    this.industry,
    this.errorDetail,
  });

  final RecruiterVerdict verdict;
  final String verdictSummary;
  final List<RecruiterQuestion> questions;
  final Map<String, SectionHeat> sectionHeatmap;
  final int overallScore;
  final bool usedLlm;
  final String? role;
  final String? industry;
  final String? errorDetail;

  factory RecruiterSimulatorResult.fromJson(
    Map<String, dynamic> json, {
    required bool usedLlm,
    String? role,
    String? industry,
    String? errorDetail,
  }) {
    final verdictStr = (json['verdict'] as String? ?? 'maybe').toLowerCase();
    final verdict = switch (verdictStr) {
      'interview' || 'yes' || 'hire' => RecruiterVerdict.interview,
      'pass' || 'no' || 'reject' => RecruiterVerdict.pass,
      _ => RecruiterVerdict.maybe,
    };

    final questionsRaw = json['questions'] as List<dynamic>? ?? [];
    final questions = questionsRaw
        .map((q) {
          final m = q as Map<String, dynamic>;
          return RecruiterQuestion(
            question: m['question']?.toString() ?? '',
            concern: m['concern']?.toString() ?? '',
          );
        })
        .where((q) => q.question.isNotEmpty)
        .toList();

    final heatRaw = json['section_heatmap'] as Map<String, dynamic>? ?? {};
    final heatmap = <String, SectionHeat>{};
    for (final e in heatRaw.entries) {
      final v = e.value.toString().toLowerCase();
      heatmap[e.key] = switch (v) {
        'strong' || 'good' || 'sold' => SectionHeat.strong,
        'weak' || 'bad' || 'failed' => SectionHeat.weak,
        _ => SectionHeat.neutral,
      };
    }

    return RecruiterSimulatorResult(
      verdict: verdict,
      verdictSummary: json['verdict_summary']?.toString() ?? '',
      questions: questions,
      sectionHeatmap: heatmap,
      overallScore: (json['overall_score'] as num?)?.round() ?? 50,
      usedLlm: usedLlm,
      role: role,
      industry: industry,
      errorDetail: errorDetail,
    );
  }
}
