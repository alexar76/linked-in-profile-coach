class BenchmarkDimension {
  const BenchmarkDimension({
    required this.key,
    required this.label,
    required this.you,
    required this.median,
    this.unit = '',
    this.maxValue = 100,
  });

  final String key;
  final String label;
  final double you;
  final double median;
  final String unit;
  final double maxValue;

  double get youNorm =>
      maxValue > 0 ? (you / maxValue).clamp(0.0, 1.0) : 0;

  double get medianNorm =>
      maxValue > 0 ? (median / maxValue).clamp(0.0, 1.0) : 0;

  factory BenchmarkDimension.fromJson(Map<String, dynamic> json) =>
      BenchmarkDimension(
        key: json['key']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
        you: (json['you'] as num?)?.toDouble() ?? 0,
        median: (json['median'] as num?)?.toDouble() ?? 0,
        unit: json['unit']?.toString() ?? '',
        maxValue: (json['max_value'] as num?)?.toDouble() ?? 100,
      );
}

class BenchmarkResult {
  const BenchmarkResult({
    required this.dimensions,
    required this.role,
    required this.summary,
    required this.usedLlm,
    this.errorDetail,
  });

  final List<BenchmarkDimension> dimensions;
  final String role;
  final String summary;
  final bool usedLlm;
  final String? errorDetail;

  factory BenchmarkResult.fromJson(
    Map<String, dynamic> json, {
    required bool usedLlm,
    String? role,
    String? errorDetail,
  }) {
    final dims = (json['dimensions'] as List<dynamic>? ?? [])
        .map((d) => BenchmarkDimension.fromJson(d as Map<String, dynamic>))
        .where((d) => d.key.isNotEmpty)
        .toList();
    return BenchmarkResult(
      dimensions: dims,
      role: role ?? json['role']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      usedLlm: usedLlm,
      errorDetail: errorDetail,
    );
  }
}
