enum ImportSource { manual, bulkPaste, jsonFile, profileUrl, linkedInDataExport }

class LinkedInImportRecord {
  const LinkedInImportRecord({
    this.id,
    required this.profileUrl,
    required this.source,
    required this.sectionsFound,
    required this.importedAt,
    this.note,
  });

  final int? id;
  final String profileUrl;
  final ImportSource source;
  final int sectionsFound;
  final DateTime importedAt;
  final String? note;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'profile_url': profileUrl,
        'source': source.name,
        'sections_found': sectionsFound,
        'imported_at': importedAt.millisecondsSinceEpoch,
        'note': note,
      };

  factory LinkedInImportRecord.fromMap(Map<String, dynamic> map) {
    return LinkedInImportRecord(
      id: map['id'] as int?,
      profileUrl: map['profile_url'] as String? ?? '',
      source: ImportSource.values.byName(map['source'] as String),
      sectionsFound: map['sections_found'] as int,
      importedAt:
          DateTime.fromMillisecondsSinceEpoch(map['imported_at'] as int),
      note: map['note'] as String?,
    );
  }
}
