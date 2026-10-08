import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/services/resume_import_service.dart';

void main() {
  final importer = ResumeImportService();

  test('supports docx only', () {
    expect(importer.isSupportedFilename('resume.docx'), isTrue);
    expect(importer.isSupportedFilename('resume.DOCX'), isTrue);
    expect(importer.isSupportedFilename('upload.doc'), isFalse);
    expect(importer.isLegacyDoc('upload.doc'), isTrue);
  });

  test('rejects legacy .doc', () async {
    expect(
      () => importer.importFile(
        filename: 'upload.doc',
        bytes: Uint8List.fromList([0, 1, 2]),
      ),
      throwsA(
        predicate<ResumeImportException>(
          (e) => e.kind == ResumeImportErrorKind.legacyDocFormat,
        ),
      ),
    );
  });
}
