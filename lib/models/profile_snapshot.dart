class ProfileSnapshot {
  const ProfileSnapshot({
    this.id,
    required this.capturedAt,
    required this.sectionsJson,
    required this.source,
    this.note,
  });

  final int? id;
  final DateTime capturedAt;
  final String sectionsJson;
  final String source;
  final String? note;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'captured_at': capturedAt.millisecondsSinceEpoch,
        'sections_json': sectionsJson,
        'source': source,
        'note': note,
      };

  factory ProfileSnapshot.fromMap(Map<String, dynamic> map) {
    return ProfileSnapshot(
      id: map['id'] as int?,
      capturedAt:
          DateTime.fromMillisecondsSinceEpoch(map['captured_at'] as int),
      sectionsJson: map['sections_json'] as String,
      source: map['source'] as String,
      note: map['note'] as String?,
    );
  }
}
