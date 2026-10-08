class CareerMilestone {
  const CareerMilestone({
    required this.yearOffset,
    required this.title,
    required this.description,
  });

  final int yearOffset;
  final String title;
  final String description;

  factory CareerMilestone.fromJson(Map<String, dynamic> json) =>
      CareerMilestone(
        yearOffset: (json['year_offset'] as num?)?.round() ?? 1,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
      );
}

class CareerWhatIfResult {
  const CareerWhatIfResult({
    required this.milestones,
    required this.skillsToAdd,
    required this.narrative,
    required this.usedLlm,
    this.extraSeniorYears = 0,
    this.extraCourse,
    this.errorDetail,
  });

  final List<CareerMilestone> milestones;
  final List<String> skillsToAdd;
  final String narrative;
  final int extraSeniorYears;
  final String? extraCourse;
  final bool usedLlm;
  final String? errorDetail;

  factory CareerWhatIfResult.fromJson(
    Map<String, dynamic> json, {
    required bool usedLlm,
    int extraSeniorYears = 0,
    String? extraCourse,
    String? errorDetail,
  }) {
    final ms = (json['milestones'] as List<dynamic>? ?? [])
        .map((m) => CareerMilestone.fromJson(m as Map<String, dynamic>))
        .toList();
    return CareerWhatIfResult(
      milestones: ms,
      skillsToAdd: (json['skills_to_add'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      narrative: json['narrative']?.toString() ?? '',
      extraSeniorYears: extraSeniorYears,
      extraCourse: extraCourse,
      usedLlm: usedLlm,
      errorDetail: errorDetail,
    );
  }
}
