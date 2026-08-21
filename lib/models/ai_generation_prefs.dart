/// How AI should position the profile when generating copy.
enum ProfileAiFocus {
  jobSearch,
  networking,
  thoughtLeadership,
  freelance,
}

/// User preferences for AI profile generation (stored in app_settings).
class AiGenerationPrefs {
  const AiGenerationPrefs({
    this.creativity = 0.7,
    this.variantCount = 1,
    this.focus = ProfileAiFocus.jobSearch,
    this.skipGenerationDialog = false,
  });

  /// 0.0–1.0; maps to LLM temperature (see [temperature]).
  final double creativity;

  /// Number of alternative drafts per section (1–3).
  final int variantCount;

  final ProfileAiFocus focus;

  /// When true, skip the pre-generation options dialog.
  final bool skipGenerationDialog;

  /// LLM temperature derived from [creativity] (0.2–1.0).
  double get temperature => 0.2 + creativity.clamp(0.0, 1.0) * 0.8;

  AiGenerationPrefs copyWith({
    double? creativity,
    int? variantCount,
    ProfileAiFocus? focus,
    bool? skipGenerationDialog,
  }) {
    return AiGenerationPrefs(
      creativity: creativity ?? this.creativity,
      variantCount: variantCount ?? this.variantCount,
      focus: focus ?? this.focus,
      skipGenerationDialog: skipGenerationDialog ?? this.skipGenerationDialog,
    );
  }

  Map<String, String> toSettingsMap() => {
        'ai_creativity': creativity.toStringAsFixed(2),
        'ai_variant_count': variantCount.clamp(1, 3).toString(),
        'ai_profile_focus': focus.name,
        'ai_skip_generation_dialog': skipGenerationDialog ? '1' : '0',
      };

  factory AiGenerationPrefs.fromSettingsMap(Map<String, String?> map) {
    final creativity = double.tryParse(map['ai_creativity'] ?? '') ?? 0.7;
    final variants = int.tryParse(map['ai_variant_count'] ?? '') ?? 1;
    final focusName = map['ai_profile_focus'] ?? ProfileAiFocus.jobSearch.name;
    return AiGenerationPrefs(
      creativity: creativity.clamp(0.0, 1.0),
      variantCount: variants.clamp(1, 3),
      focus: ProfileAiFocus.values.firstWhere(
        (f) => f.name == focusName,
        orElse: () => ProfileAiFocus.jobSearch,
      ),
      skipGenerationDialog: map['ai_skip_generation_dialog'] == '1',
    );
  }
}
