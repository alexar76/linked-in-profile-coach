import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/services/linkedin_data_export_parser.dart';
import 'package:linkedin_profile_coach/services/linkedin_import_parser.dart';
import 'package:archive/archive.dart';

void main() {
  group('LinkedInImportParser', () {
    final parser = LinkedInImportParser();

    test('parseBulkPaste reads new section headers', () {
      const text = '''
HEADLINE:
Senior Dev

LANGUAGES:
English — Native

HONORS:
Best Engineer 2024
''';
      final result = parser.parseBulkPaste(text);
      expect(result['headline'], 'Senior Dev');
      expect(result['languages'], contains('English'));
      expect(result['honors'], contains('Best Engineer'));
    });
  });

  group('LinkedInDataExportParser', () {
    final parser = LinkedInDataExportParser();

    test('parseZipBytes maps Profile and Positions CSVs', () {
      const profileCsv = 'First Name,Last Name,Headline,Summary,Industry\n'
          'Alex,Dev,Senior Flutter,Builder summary,Software\n';
      const positionsCsv = 'Company Name,Title,Description\n'
          'Acme,Engineer,Built apps\n';

      final archive = Archive()
        ..addFile(
          ArchiveFile.string('Profile.csv', profileCsv),
        )
        ..addFile(
          ArchiveFile.string('Positions.csv', positionsCsv),
        );

      final zipBytes = ZipEncoder().encode(archive);
      final result = parser.parseZipBytes(zipBytes);

      expect(result['headline'], contains('Senior Flutter'));
      expect(result['about'], contains('Builder summary'));
      expect(result['location_industry'], contains('Software'));
      expect(result['experience'], contains('Acme'));
    });
  });
}
