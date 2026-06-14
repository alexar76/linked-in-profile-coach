class JobFitGap {
  const JobFitGap({
    required this.sectionKey,
    required this.issue,
    required this.suggestion,
  });

  final String sectionKey;
  final String issue;
  final String suggestion;

  factory JobFitGap.fromJson(Map<String, dynamic> json) => JobFitGap(
        sectionKey: json['section_key']?.toString() ?? 'general',
        issue: json['issue']?.toString() ?? '',
        suggestion: json['suggestion']?.toString() ?? '',
      );
}

class JobFitResult {
  const JobFitResult({
    required this.matchPercent,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.gaps,
    required this.sectionEdits,
    required this.jobTitle,
    required this.usedLlm,
    this.summary,
    this.errorDetail,
  });

  final int matchPercent;
  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final List<JobFitGap> gaps;
  final Map<String, String> sectionEdits;
  final String jobTitle;
  final String? summary;
  final bool usedLlm;
  final String? errorDetail;

  factory JobFitResult.fromJson(
    Map<String, dynamic> json, {
    required bool usedLlm,
    String? errorDetail,
  }) {
    final editsRaw = json['section_edits'] as Map<String, dynamic>? ?? {};
    final edits = <String, String>{};
    for (final e in editsRaw.entries) {
      final v = e.value?.toString().trim() ?? '';
      if (v.isNotEmpty) edits[e.key] = v;
    }

    final gapsRaw = json['gaps'] as List<dynamic>? ?? [];
    return JobFitResult(
      matchPercent: (json['match_percent'] as num?)?.round() ?? 0,
      matchedKeywords: (json['matched_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      missingKeywords: (json['missing_keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      gaps: gapsRaw
          .map((g) => JobFitGap.fromJson(g as Map<String, dynamic>))
          .toList(),
      sectionEdits: edits,
      jobTitle: json['job_title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      usedLlm: usedLlm,
      errorDetail: errorDetail,
    );
  }
}
