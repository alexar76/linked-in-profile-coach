import 'dart:convert';

import 'recommendation_item.dart';

class SectionScore {
  const SectionScore({
    required this.score,
    this.feedback = '',
  });

  final int score;
  final String feedback;

  Map<String, dynamic> toJson() => {
        'score': score,
        if (feedback.isNotEmpty) 'feedback': feedback,
      };

  factory SectionScore.fromJson(Map<String, dynamic> json) {
    return SectionScore(
      score: (json['score'] as num?)?.round().clamp(0, 100) ?? 0,
      feedback: json['feedback'] as String? ?? '',
    );
  }
}

class ProfileEvaluation {
  const ProfileEvaluation({
    this.id,
    required this.evaluatedAt,
    required this.currentOverall,
    required this.aiOverall,
    required this.summary,
    required this.currentBySection,
    required this.aiBySection,
    required this.recommendations,
    required this.usedLlm,
    this.providerLabel,
    this.errorDetail,
  });

  final int? id;
  final DateTime evaluatedAt;
  final int currentOverall;
  final int aiOverall;
  final String summary;
  final Map<String, SectionScore> currentBySection;
  final Map<String, SectionScore> aiBySection;
  final List<RecommendationItem> recommendations;
  final bool usedLlm;
  final String? providerLabel;
  final String? errorDetail;

  int? get delta => aiOverall > 0 ? aiOverall - currentOverall : null;

  bool get hasAiScores => aiOverall > 0;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'evaluated_at': evaluatedAt.millisecondsSinceEpoch,
        'current_overall': currentOverall,
        'ai_overall': aiOverall,
        'summary': summary,
        'current_scores_json': jsonEncode(
          currentBySection.map((k, v) => MapEntry(k, v.toJson())),
        ),
        'ai_scores_json': jsonEncode(
          aiBySection.map((k, v) => MapEntry(k, v.toJson())),
        ),
        'used_llm': usedLlm ? 1 : 0,
        'provider_label': providerLabel,
        'error_detail': errorDetail,
      };

  factory ProfileEvaluation.fromMap(Map<String, dynamic> map) {
    return ProfileEvaluation(
      id: map['id'] as int?,
      evaluatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['evaluated_at'] as int,
      ),
      currentOverall: map['current_overall'] as int? ?? 0,
      aiOverall: map['ai_overall'] as int? ?? 0,
      summary: map['summary'] as String? ?? '',
      currentBySection: _parseScores(map['current_scores_json'] as String?),
      aiBySection: _parseScores(map['ai_scores_json'] as String?),
      recommendations: const [],
      usedLlm: (map['used_llm'] as int? ?? 0) == 1,
      providerLabel: map['provider_label'] as String?,
      errorDetail: map['error_detail'] as String?,
    );
  }

  static Map<String, SectionScore> _parseScores(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(
          k,
          SectionScore.fromJson(v as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }
}

class ProfileEvaluationResult {
  const ProfileEvaluationResult({
    required this.evaluation,
    required this.messageKind,
  });

  final ProfileEvaluation evaluation;
  final EvaluationMessageKind messageKind;
}

enum EvaluationMessageKind {
  evaluatedViaProvider,
  localFallback,
  llmErrorFallback,
}
