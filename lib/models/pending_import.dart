import 'linkedin_import_record.dart';
import 'section_import_diff.dart';

class PendingImport {
  const PendingImport({
    required this.incoming,
    required this.diffs,
    required this.source,
    required this.sourceLabel,
    this.profileUrl,
  });

  final Map<String, String> incoming;
  final List<SectionImportDiff> diffs;
  final ImportSource source;
  final String sourceLabel;
  final String? profileUrl;

  bool get hasActionableChanges => diffs.any((d) => d.hasChange);
}
