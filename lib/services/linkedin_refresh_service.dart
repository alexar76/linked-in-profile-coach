import 'dart:convert';
import 'dart:io';

import 'linkedin_data_export_parser.dart';
import 'linkedin_public_profile_service.dart';

enum RefreshSource { lastExportFile, watchFolder, profileUrl, none }

class LinkedInRefreshPayload {
  const LinkedInRefreshPayload({
    required this.source,
    required this.sections,
    this.sourceLabel = '',
  });

  final RefreshSource source;
  final Map<String, String> sections;
  final String sourceLabel;

  bool get hasData => sections.isNotEmpty;
}

class LinkedInRefreshService {
  LinkedInRefreshService({
    LinkedInDataExportParser? exportParser,
    LinkedInPublicProfileService? publicProfile,
  })  : _exportParser = exportParser ?? LinkedInDataExportParser(),
        _publicProfile = publicProfile ?? LinkedInPublicProfileService();

  final LinkedInDataExportParser _exportParser;
  final LinkedInPublicProfileService _publicProfile;

  Future<LinkedInRefreshPayload> fetch({
    required String? lastExportPath,
    required String? watchFolderPath,
    required String profileUrl,
  }) async {
    final fromWatch = await _tryFolder(watchFolderPath);
    if (fromWatch.hasData) return fromWatch;

    final fromLast = await _tryFile(lastExportPath);
    if (fromLast.hasData) return fromLast;

    if (profileUrl.trim().isNotEmpty) {
      try {
        final sections = await _publicProfile.fetchSections(profileUrl);
        if (sections.isNotEmpty) {
          return LinkedInRefreshPayload(
            source: RefreshSource.profileUrl,
            sections: sections,
            sourceLabel: profileUrl,
          );
        }
      } catch (_) {}
    }

    return const LinkedInRefreshPayload(
      source: RefreshSource.none,
      sections: {},
    );
  }

  Future<LinkedInRefreshPayload> _tryFile(String? path) async {
    if (path == null || path.isEmpty) {
      return const LinkedInRefreshPayload(
        source: RefreshSource.none,
        sections: {},
      );
    }
    final file = File(path);
    if (!await file.exists()) {
      return const LinkedInRefreshPayload(
        source: RefreshSource.none,
        sections: {},
      );
    }
    final bytes = await file.readAsBytes();
    final lower = path.toLowerCase();
    final sections = lower.endsWith('.zip')
        ? _exportParser.parseZipBytes(bytes)
        : _exportParser.parseJsonExport(
            _decodeJson(bytes),
          );
    return LinkedInRefreshPayload(
      source: RefreshSource.lastExportFile,
      sections: sections,
      sourceLabel: path,
    );
  }

  Future<LinkedInRefreshPayload> _tryFolder(String? folderPath) async {
    if (folderPath == null || folderPath.isEmpty) {
      return const LinkedInRefreshPayload(
        source: RefreshSource.none,
        sections: {},
      );
    }
    final dir = Directory(folderPath);
    if (!await dir.exists()) {
      return const LinkedInRefreshPayload(
        source: RefreshSource.none,
        sections: {},
      );
    }

    File? newest;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      final name = entity.path.toLowerCase();
      if (!name.endsWith('.zip') && !name.endsWith('.json')) continue;
      if (newest == null ||
          entity.statSync().modified.isAfter(newest.statSync().modified)) {
        newest = entity;
      }
    }

    if (newest == null) {
      return const LinkedInRefreshPayload(
        source: RefreshSource.none,
        sections: {},
      );
    }

    final payload = await _tryFile(newest.path);
    if (!payload.hasData) return payload;
    return LinkedInRefreshPayload(
      source: RefreshSource.watchFolder,
      sections: payload.sections,
      sourceLabel: newest.path,
    );
  }

  Map<String, dynamic> _decodeJson(List<int> bytes) {
    return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  }
}
