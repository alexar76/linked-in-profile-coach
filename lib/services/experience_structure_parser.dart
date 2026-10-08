class ExperienceRole {
  const ExperienceRole({
    required this.title,
    required this.company,
    this.period = '',
    this.body = '',
  });

  final String title;
  final String company;
  final String period;
  final String body;
}

/// Splits LinkedIn-style experience blobs into role cards.
class ExperienceStructureParser {
  List<ExperienceRole> parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return [];

    final blocks = trimmed.split(RegExp(r'\n---\n|\n\n(?=\S)'));
    final roles = <ExperienceRole>[];

    for (final block in blocks) {
      final lines = block
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      if (lines.isEmpty) continue;

      String? company;
      String? title;
      String? period;
      final bodyLines = <String>[];

      for (final line in lines) {
        final companyMatch = RegExp(
          r'^(Company Name|Компания|Empresa)\s*:\s*(.+)$',
          caseSensitive: false,
        ).firstMatch(line);
        final titleMatch = RegExp(
          r'^(Title|Должность|Título)\s*:\s*(.+)$',
          caseSensitive: false,
        ).firstMatch(line);
        final startedMatch = RegExp(
          r'^(Started On|Finished On|Duration|Период|Periodo)\s*:\s*(.+)$',
          caseSensitive: false,
        ).firstMatch(line);

        if (companyMatch != null) {
          company = companyMatch.group(2)!.trim();
        } else if (titleMatch != null) {
          title = titleMatch.group(2)!.trim();
        } else if (startedMatch != null) {
          period = period == null
              ? startedMatch.group(2)!.trim()
              : '$period – ${startedMatch.group(2)!.trim()}';
        } else if (line.startsWith('•') ||
            line.startsWith('-') ||
            line.startsWith('*')) {
          bodyLines.add(line);
        } else if (company == null && title == null && line.contains(' at ')) {
          final parts = line.split(' at ');
          title = parts.first.trim();
          company = parts.sublist(1).join(' at ').trim();
        } else if (company == null && title == null && line.contains(' | ')) {
          final parts = line.split(' | ');
          title = parts.first.trim();
          if (parts.length > 1) company = parts[1].trim();
        } else if (company == null && title == null) {
          title = line;
        } else {
          bodyLines.add(line);
        }
      }

      roles.add(
        ExperienceRole(
          title: title ?? lines.first,
          company: company ?? '',
          period: period ?? '',
          body: bodyLines.join('\n'),
        ),
      );
    }

    return roles;
  }
}
