class HeadlineVariantScore {
  const HeadlineVariantScore({
    required this.text,
    required this.ats,
    required this.readability,
    required this.hook,
    required this.uniqueness,
    required this.overall,
  });

  final String text;
  final int ats;
  final int readability;
  final int hook;
  final int uniqueness;
  final int overall;

  factory HeadlineVariantScore.fromJson(Map<String, dynamic> json) {
    final ats = (json['ats'] as num?)?.round() ?? 0;
    final readability = (json['readability'] as num?)?.round() ?? 0;
    final hook = (json['hook'] as num?)?.round() ?? 0;
    final uniqueness = (json['uniqueness'] as num?)?.round() ?? 0;
    final overall = (json['overall'] as num?)?.round() ??
        ((ats + readability + hook + uniqueness) / 4).round();
    return HeadlineVariantScore(
      text: json['text']?.toString() ?? '',
      ats: ats,
      readability: readability,
      hook: hook,
      uniqueness: uniqueness,
      overall: overall,
    );
  }
}

class HeadlineAbResult {
  const HeadlineAbResult({
    required this.headlineVariants,
    this.aboutVariants = const [],
    required this.usedLlm,
    this.errorDetail,
  });

  final List<HeadlineVariantScore> headlineVariants;
  final List<HeadlineVariantScore> aboutVariants;
  final bool usedLlm;
  final String? errorDetail;

  factory HeadlineAbResult.fromJson(
    Map<String, dynamic> json, {
    required bool usedLlm,
    String? errorDetail,
  }) {
    List<HeadlineVariantScore> parseList(String key) {
      final raw = json[key] as List<dynamic>? ?? [];
      return raw
          .map((v) =>
              HeadlineVariantScore.fromJson(v as Map<String, dynamic>))
          .where((v) => v.text.isNotEmpty)
          .toList()
        ..sort((a, b) => b.overall.compareTo(a.overall));
    }

    final headlines = parseList('headline_variants');
    return HeadlineAbResult(
      headlineVariants:
          headlines.isNotEmpty ? headlines : parseList('variants'),
      aboutVariants: parseList('about_variants'),
      usedLlm: usedLlm,
      errorDetail: errorDetail,
    );
  }
}
