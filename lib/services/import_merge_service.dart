import '../models/profile_section.dart';
import '../models/section_import_diff.dart';

class ImportMergeService {
  List<SectionImportDiff> computeDiffs({
    required List<ProfileSection> currentSections,
    required Map<String, String> incoming,
  }) {
    final byKey = {for (final s in currentSections) s.key: s};
    final diffs = <SectionImportDiff>[];

    for (final entry in incoming.entries) {
      final section = byKey[entry.key];
      if (section == null) continue;
      final inc = entry.value.trim();
      if (inc.isEmpty) continue;

      final cur = section.content.trim();
      final status = cur.isEmpty
          ? SectionImportStatus.newSection
          : (cur == inc
              ? SectionImportStatus.unchanged
              : SectionImportStatus.changed);

      diffs.add(
        SectionImportDiff(
          sectionKey: entry.key,
          title: section.title,
          current: cur,
          incoming: inc,
          status: status,
        ),
      );
    }

    diffs.sort((a, b) {
      int rank(SectionImportStatus s) => switch (s) {
            SectionImportStatus.changed => 0,
            SectionImportStatus.newSection => 1,
            SectionImportStatus.unchanged => 2,
            SectionImportStatus.incomingOnly => 3,
          };
      final c = rank(a.status).compareTo(rank(b.status));
      if (c != 0) return c;
      return a.title.compareTo(b.title);
    });
    return diffs;
  }

  Map<String, String> selectedIncoming(
    Map<String, String> incoming,
    Set<String> keys,
  ) =>
      Map.fromEntries(
        incoming.entries.where((e) => keys.contains(e.key)),
      );
}
