class ResumeDocument {
  const ResumeDocument({
    required this.id,
    required this.filename,
    required this.filePath,
    required this.extractedText,
    required this.uploadedAt,
  });

  final int id;
  final String filename;
  final String filePath;
  final String extractedText;
  final DateTime uploadedAt;

  factory ResumeDocument.fromMap(Map<String, dynamic> map) {
    return ResumeDocument(
      id: map['id'] as int,
      filename: map['filename'] as String,
      filePath: map['file_path'] as String,
      extractedText: map['extracted_text'] as String? ?? '',
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(map['uploaded_at'] as int),
    );
  }
}
