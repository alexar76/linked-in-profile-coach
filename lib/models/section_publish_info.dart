enum PublishCapability {
  copyToClipboard,
  openInBrowser,
  manualOnly,
}

class SectionPublishInfo {
  const SectionPublishInfo({
    required this.sectionKey,
    required this.capability,
    required this.editUrl,
    required this.manualNote,
  });

  final String sectionKey;
  final PublishCapability capability;
  final String editUrl;
  final String manualNote;

  bool get canAutoViaApi => false;
}
