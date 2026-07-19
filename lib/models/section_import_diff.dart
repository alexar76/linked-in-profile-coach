enum SectionImportStatus { newSection, changed, unchanged, incomingOnly }

class SectionImportDiff {
  const SectionImportDiff({
    required this.sectionKey,
    required this.title,
    required this.current,
    required this.incoming,
    required this.status,
  });

  final String sectionKey;
  final String title;
  final String current;
  final String incoming;
  final SectionImportStatus status;

  bool get hasChange => status == SectionImportStatus.changed ||
      status == SectionImportStatus.newSection;

  bool get selectedByDefault => hasChange;
}
