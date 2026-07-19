class AtsMatchResult {
  const AtsMatchResult({
    required this.scorePercent,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.targetRole,
  });

  final int scorePercent;
  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final String targetRole;

  bool get hasTarget => targetRole.trim().isNotEmpty;
}
