import 'dart:convert';
import 'dart:io';

import '../database/database_helper.dart';
import '../models/ai_settings.dart';
import '../theme/app_theme_id.dart';
import '../models/profile_language.dart';
import '../utils/app_locale_resolver.dart';
import '../models/linkedin_import_record.dart';
import '../models/profile_section.dart';
import '../models/recommendation_item.dart';
import '../models/resume_document.dart';
import '../models/ats_match_result.dart';
import '../models/pending_import.dart';
import '../models/dashboard_analytics.dart';
import '../models/linkedin_analytics.dart';
import '../models/profile_snapshot.dart';
import '../services/ats_keyword_service.dart';
import '../services/dashboard_analytics_service.dart';
import '../services/linkedin_analytics_parser.dart';
import '../services/import_merge_service.dart';
import '../services/linkedin_data_export_parser.dart';
import '../services/linkedin_import_parser.dart';
import '../services/linkedin_public_profile_service.dart';
import '../services/linkedin_refresh_service.dart';
import '../services/llm/llm_service.dart';
import '../models/profile_evaluation.dart';
import '../services/profile_ai_llm_service.dart';
import '../services/profile_analyzer.dart';
import '../services/profile_evaluator_llm_service.dart';

class AppRepository {
  AppRepository({
    DatabaseHelper? database,
    ProfileAnalyzer? analyzer,
    ProfileAiLlmService? aiLlmService,
    ProfileEvaluatorLlmService? evaluatorLlmService,
    LlmService? llmService,
    LinkedInImportParser? importParser,
    LinkedInDataExportParser? dataExportParser,
    LinkedInPublicProfileService? publicProfileService,
    ImportMergeService? mergeService,
    LinkedInRefreshService? refreshService,
    AtsKeywordService? atsService,
    LinkedInAnalyticsParser? analyticsParser,
    DashboardAnalyticsService? dashboardAnalytics,
  })  : _db = database ?? DatabaseHelper.instance,
        _analyzer = analyzer ?? ProfileAnalyzer(),
        _aiLlm = aiLlmService ?? ProfileAiLlmService(),
        _evaluator = evaluatorLlmService ?? ProfileEvaluatorLlmService(),
        _llm = llmService ?? LlmService(),
        _importParser = importParser ?? LinkedInImportParser(),
        _dataExportParser = dataExportParser ?? LinkedInDataExportParser(),
        _publicProfile = publicProfileService ?? LinkedInPublicProfileService(),
        _merge = mergeService ?? ImportMergeService(),
        _refresh = refreshService ?? LinkedInRefreshService(),
        _ats = atsService ?? AtsKeywordService(),
        _analyticsParser = analyticsParser ?? LinkedInAnalyticsParser(),
        _dashboardAnalytics = dashboardAnalytics ?? DashboardAnalyticsService();

  final DatabaseHelper _db;
  final ProfileAnalyzer _analyzer;
  final ProfileAiLlmService _aiLlm;
  final ProfileEvaluatorLlmService _evaluator;
  final LlmService _llm;
  final LinkedInImportParser _importParser;
  final LinkedInDataExportParser _dataExportParser;
  final LinkedInPublicProfileService _publicProfile;
  final ImportMergeService _merge;
  final LinkedInRefreshService _refresh;
  final AtsKeywordService _ats;
  final LinkedInAnalyticsParser _analyticsParser;
  final DashboardAnalyticsService _dashboardAnalytics;

  static const _keyLastExportPath = 'last_export_path';
  static const _keyWatchFolder = 'watch_folder_path';
  static const _keyWatchProcessed = 'watch_folder_processed_mtime';
  static const _keyReminderSnooze = 'import_reminder_snooze_until';

  Future<List<ProfileSection>> getSections() => _db.getProfileSections();

  Future<void> saveSection(ProfileSection section) =>
      _db.saveProfileSection(section);

  Future<void> markSynced(String sectionKey, bool synced) =>
      _db.markSectionSynced(sectionKey, synced);

  Future<List<RecommendationItem>> getRecommendations() =>
      _db.getRecommendations();

  Future<List<RecommendationItem>> getRuleRecommendations() =>
      _db.getRuleRecommendations();

  Future<void> setRecommendationDone(int id, bool done) =>
      _db.setRecommendationDone(id, done);

  Future<ResumeDocument?> getResume() => _db.getActiveResume();

  Future<LinkedInImportRecord?> getLastImport() => _db.getLastImport();

  Future<String> getTargetRole() async =>
      await _db.getSetting('target_role') ?? '';

  Future<String> getTargetIndustry() async =>
      await _db.getSetting('target_industry') ?? '';

  Future<String> getDisplayName() async =>
      await _db.getSetting('display_name') ?? '';

  Future<String> getProfileUrl() async =>
      await _db.getSetting('profile_url') ?? '';

  Future<void> saveTargetRole(String value) =>
      _db.setSetting('target_role', value);

  Future<void> saveTargetIndustry(String value) =>
      _db.setSetting('target_industry', value);

  Future<void> saveDisplayName(String value) =>
      _db.setSetting('display_name', value);

  Future<void> saveProfileUrl(String value) =>
      _db.setSetting('profile_url', value);

  Future<AppThemeId> getThemeId() async {
    final key = await _db.getSetting('app_theme');
    return AppThemeIdCodec.fromString(key);
  }

  Future<void> saveThemeId(AppThemeId id) =>
      _db.setSetting('app_theme', id.storageKey);

  Future<String> getLocaleLanguageCode() async {
    final saved = await _db.getSetting('app_locale');
    return resolveAppLocaleCode(saved);
  }

  /// Single language for UI, insights, AI, and scoring.
  Future<ProfileLanguage> getProfileLanguage() async {
    return ProfileLanguage.fromCode(await getLocaleLanguageCode());
  }

  /// Saves UI locale and clears insights when the language changes.
  Future<bool> saveAppLanguage(String languageCode) async {
    final code = languageCode.trim().toLowerCase();
    final normalized =
        supportedAppLanguageCodes.contains(code) ? code : 'en';
    final previous = await getLocaleLanguageCode();
    await _db.setSetting('app_locale', normalized);
    await _db.setSetting('profile_language', normalized);
    if (previous != normalized) {
      await _db.clearRuleRecommendations();
      await _db.clearEvaluatorRecommendations();
      return true;
    }
    return false;
  }

  Future<void> saveLocale(String languageCode) async {
    await saveAppLanguage(languageCode);
  }

  Future<void> saveProfileLanguage(ProfileLanguage language) async {
    await saveAppLanguage(language.code);
  }

  /// Drops stale insights when an old [profile_language] disagreed with UI locale.
  Future<void> reconcileLanguageAndInsights() async {
    final uiCode = await getLocaleLanguageCode();
    final profileCode = await _db.getSetting('profile_language');
    if (profileCode == null ||
        profileCode.isEmpty ||
        profileCode == uiCode) {
      return;
    }
    await _db.setSetting('profile_language', uiCode);
    await _db.clearRuleRecommendations();
    await _db.clearEvaluatorRecommendations();
  }

  Future<bool> isOnboardingComplete() async =>
      (await _db.getSetting('onboarding_completed')) == '1';

  Future<void> setOnboardingComplete(bool value) =>
      _db.setSetting('onboarding_completed', value ? '1' : '0');

  Future<String?> getPremiumTemplateId() => _db.getSetting('premium_template_id');

  Future<void> savePremiumTemplateId(String id) =>
      _db.setSetting('premium_template_id', id);

  Future<AiSettings> getAiSettings() async {
    final keys = [
      'ai_provider',
      'ai_api_key',
      'ai_base_url',
      'ai_model',
      'ai_use_llm',
    ];
    final map = <String, String?>{};
    for (final k in keys) {
      map[k] = await _db.getSetting(k);
    }
    return AiSettings.fromSettingsMap(map);
  }

  Future<void> saveAiSettings(AiSettings settings) async {
    final m = settings.toSettingsMap();
    for (final e in m.entries) {
      await _db.setSetting(e.key, e.value);
    }
  }

  Future<String> testAiConnection(AiSettings settings) async {
    final reply = await _llm.testConnection(settings);
    return reply.length > 80 ? '${reply.substring(0, 80)}...' : reply;
  }

  Future<void> saveResume({
    required String filename,
    required String filePath,
    required String extractedText,
  }) =>
      _db.saveResume(
        filename: filename,
        filePath: filePath,
        extractedText: extractedText,
      );

  Future<String?> getLastExportPath() => _db.getSetting(_keyLastExportPath);

  Future<void> saveLastExportPath(String path) =>
      _db.setSetting(_keyLastExportPath, path);

  Future<String?> getWatchFolderPath() => _db.getSetting(_keyWatchFolder);

  Future<void> saveWatchFolderPath(String path) =>
      _db.setSetting(_keyWatchFolder, path);

  Future<DashboardAnalytics> getDashboardAnalytics() async {
    final sections = await getSections();
    final filled = sections.where((s) => s.content.trim().isNotEmpty).length;
    return _dashboardAnalytics.build(
      DashboardAnalyticsInput(
        snapshots: await getSnapshots(),
        evaluations: await _db.getEvaluationHistory(),
        linkedInRecords: await _db.getLinkedInAnalyticsHistory(),
        importCount: await _db.getImportCount(),
        lastImportAt: (await getLastImport())?.importedAt,
        recommendations: await getRecommendations(),
        filledSections: filled,
        totalSections: sections.length,
        targetRole: await getTargetRole(),
        ats: await getAtsMatch(),
      ),
    );
  }

  Future<void> _saveAnalyticsFromZip(List<int> bytes, String source) async {
    final bundle = _analyticsParser.parseFromZipBytes(bytes);
    if (bundle.isEmpty) return;
    await _db.saveLinkedInAnalytics(
      LinkedInAnalyticsRecord(
        recordedAt: DateTime.now(),
        bundle: bundle,
        source: source,
      ),
    );
  }

  Future<AtsMatchResult> getAtsMatch() async {
    final sections = await getSections();
    return _ats.analyze(
      sections: sections,
      targetRole: await getTargetRole(),
      targetIndustry: await getTargetIndustry(),
    );
  }

  Future<int?> getImportReminderDays() async {
    final snooze = await _db.getSetting(_keyReminderSnooze);
    if (snooze != null) {
      final until = int.tryParse(snooze);
      if (until != null && DateTime.now().millisecondsSinceEpoch < until) {
        return null;
      }
    }
    final last = await getLastImport();
    if (last == null) return null;
    final days = DateTime.now().difference(last.importedAt).inDays;
    if (days < 30) return null;
    return days;
  }

  Future<void> snoozeImportReminder() async {
    final until = DateTime.now().add(const Duration(days: 7));
    await _db.setSetting(
      _keyReminderSnooze,
      until.millisecondsSinceEpoch.toString(),
    );
  }

  Future<PendingImport?> prepareImport(
    Map<String, String> parsed, {
    required ImportSource source,
    required String sourceLabel,
    String? profileUrl,
  }) async {
    if (parsed.isEmpty) return null;

    final sections = await getSections();
    final diffs = _merge.computeDiffs(
      currentSections: sections,
      incoming: parsed,
    );
    if (!diffs.any((d) => d.hasChange)) {
      return null;
    }

    return PendingImport(
      incoming: parsed,
      diffs: diffs,
      source: source,
      sourceLabel: sourceLabel,
      profileUrl: profileUrl,
    );
  }

  Future<ImportResult> applyPendingImport(
    PendingImport pending,
    Set<String> keys, {
    bool regenerateAi = true,
  }) async {
    final toApply = _merge.selectedIncoming(pending.incoming, keys);
    if (toApply.isEmpty) {
      return const ImportResult(
        success: false,
        sectionsFound: 0,
        message: '',
      );
    }

    await _captureSnapshot(pending.source.name);

    await _db.importLinkedInSections(toApply);
    final url = pending.profileUrl ?? await getProfileUrl();
    await _db.logImport(
      LinkedInImportRecord(
        profileUrl: url,
        source: pending.source,
        sectionsFound: toApply.length,
        importedAt: DateTime.now(),
        note: toApply.keys.join(', '),
      ),
    );

    if (regenerateAi) {
      await generateAiForSections(toApply.keys.toList());
    }

    return ImportResult(
      success: true,
      sectionsFound: toApply.length,
      message: '',
      sectionKeys: toApply.keys.toList(),
    );
  }

  Future<PendingImport?> refreshFromLinkedIn() async {
    final payload = await _refresh.fetch(
      lastExportPath: await getLastExportPath(),
      watchFolderPath: await getWatchFolderPath(),
      profileUrl: await getProfileUrl(),
    );
    if (!payload.hasData) return null;

    if (payload.source == RefreshSource.lastExportFile ||
        payload.source == RefreshSource.watchFolder) {
      await saveLastExportPath(payload.sourceLabel);
      final path = payload.sourceLabel.toLowerCase();
      if (path.endsWith('.zip')) {
        try {
          final bytes = await File(payload.sourceLabel).readAsBytes();
          await _saveAnalyticsFromZip(bytes, 'refresh');
        } catch (_) {}
      }
    }

    return prepareImport(
      payload.sections,
      source: payload.source == RefreshSource.profileUrl
          ? ImportSource.profileUrl
          : ImportSource.linkedInDataExport,
      sourceLabel: payload.sourceLabel,
      profileUrl: await getProfileUrl(),
    );
  }

  Future<PendingImport?> checkWatchFolder() async {
    final folder = await getWatchFolderPath();
    if (folder == null || folder.isEmpty) return null;

    final payload = await _refresh.fetch(
      lastExportPath: null,
      watchFolderPath: folder,
      profileUrl: '',
    );
    if (!payload.hasData || payload.source != RefreshSource.watchFolder) {
      return null;
    }

    final mtime = File(payload.sourceLabel).statSync().modified;
    final processed = await _db.getSetting(_keyWatchProcessed);
    if (processed == mtime.millisecondsSinceEpoch.toString()) {
      return null;
    }
    await _db.setSetting(_keyWatchProcessed, mtime.millisecondsSinceEpoch.toString());

    return prepareImport(
      payload.sections,
      source: ImportSource.linkedInDataExport,
      sourceLabel: payload.sourceLabel,
    );
  }

  Future<ImportResult> importBulkPaste(String text, {String? profileUrl}) async {
    final parsed = _importParser.parseBulkPaste(text);
    final pending = await prepareImport(
      parsed,
      source: ImportSource.bulkPaste,
      sourceLabel: 'clipboard',
      profileUrl: profileUrl,
    );
    if (pending == null) {
      return ImportResult(
        success: parsed.isNotEmpty,
        sectionsFound: 0,
        message: parsed.isEmpty ? '' : 'up_to_date',
      );
    }
    return ImportResult(
      success: true,
      sectionsFound: pending.diffs.where((d) => d.hasChange).length,
      message: '',
      pending: pending,
    );
  }

  Future<ImportResult> importFromProfileUrl([String? url]) async {
    final profileUrl = url?.trim().isNotEmpty == true
        ? url!.trim()
        : await getProfileUrl();
    if (profileUrl.isEmpty) {
      return const ImportResult(
        success: false,
        sectionsFound: 0,
        message: '',
      );
    }

    try {
      final parsed = await _publicProfile.fetchSections(profileUrl);
      final pending = await prepareImport(
        parsed,
        source: ImportSource.profileUrl,
        sourceLabel: profileUrl,
        profileUrl: profileUrl,
      );
      if (pending == null) {
        return ImportResult(
          success: parsed.isNotEmpty,
          sectionsFound: 0,
          message: parsed.isEmpty ? '' : 'up_to_date',
        );
      }
      return ImportResult(
        success: true,
        sectionsFound: pending.diffs.where((d) => d.hasChange).length,
        message: '',
        pending: pending,
      );
    } catch (_) {
      return const ImportResult(
        success: false,
        sectionsFound: 0,
        message: '',
      );
    }
  }

  Future<ImportResult> importJson(
    Map<String, dynamic> json, {
    String? profileUrl,
  }) async {
    final parsed = _dataExportParser.parseAnyJson(json);
    final pending = await prepareImport(
      parsed,
      source: ImportSource.jsonFile,
      sourceLabel: 'json',
      profileUrl: profileUrl,
    );
    if (pending == null) {
      return ImportResult(
        success: parsed.isNotEmpty,
        sectionsFound: 0,
        message: parsed.isEmpty ? '' : 'up_to_date',
      );
    }
    return ImportResult(
      success: true,
      sectionsFound: pending.diffs.length,
      message: '',
      pending: pending,
    );
  }

  Future<ImportResult> importLinkedInDataExport(
    List<int> bytes, {
    required bool isZip,
    String? profileUrl,
    String? filePath,
  }) async {
    final parsed = isZip
        ? _dataExportParser.parseZipBytes(bytes)
        : _dataExportParser.parseJsonExport(
            jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>,
          );
    if (isZip) {
      await _saveAnalyticsFromZip(bytes, 'import_zip');
    }
    if (filePath != null && filePath.isNotEmpty) {
      await saveLastExportPath(filePath);
    }
    final pending = await prepareImport(
      parsed,
      source: ImportSource.linkedInDataExport,
      sourceLabel: filePath ?? 'linkedin-export',
      profileUrl: profileUrl,
    );
    if (pending == null) {
      return ImportResult(
        success: parsed.isNotEmpty,
        sectionsFound: 0,
        message: parsed.isEmpty ? '' : 'up_to_date',
      );
    }
    return ImportResult(
      success: true,
      sectionsFound: pending.diffs.where((d) => d.hasChange).length,
      message: '',
      pending: pending,
    );
  }

  Future<void> _captureSnapshot(String source) async {
    final content = await _db.snapshotCurrentContent();
    final hasAny = content.values.any((v) => v.trim().isNotEmpty);
    if (!hasAny) return;
    await _db.saveProfileSnapshot(
      ProfileSnapshot(
        capturedAt: DateTime.now(),
        sectionsJson: jsonEncode(content),
        source: source,
      ),
    );
  }

  Future<List<ProfileSnapshot>> getSnapshots() => _db.getProfileSnapshots();

  Future<void> restoreSnapshot(ProfileSnapshot snapshot) async {
    await _captureSnapshot('before_restore');
    await _db.restoreProfileSnapshot(snapshot);
  }

  Future<ProfileAiGenerationResult> generateAiForSections(
    List<String> sectionKeys,
  ) async {
    if (sectionKeys.isEmpty) {
      return generateAiProfile();
    }
    final sections = await getSections();
    final resume = await getResume();
    final settings = await getAiSettings();
    final result = await _aiLlm.generateForSections(
      settings: settings,
      sections: sections,
      sectionKeys: sectionKeys.toSet(),
      targetRole: await getTargetRole(),
      targetIndustry: await getTargetIndustry(),
      displayName: await getDisplayName(),
      resumeText: resume?.extractedText,
      profileLanguage: await getProfileLanguage(),
    );
    await _db.saveAiSections(result.sections);
    return result;
  }

  Future<ProfileAiGenerationResult> generateAiProfile() async {
    final sections = await getSections();
    final resume = await getResume();
    final settings = await getAiSettings();
    final result = await _aiLlm.generate(
      settings: settings,
      sections: sections,
      targetRole: await getTargetRole(),
      targetIndustry: await getTargetIndustry(),
      displayName: await getDisplayName(),
      resumeText: resume?.extractedText,
      profileLanguage: await getProfileLanguage(),
    );
    await _db.saveAiSections(result.sections);
    return result;
  }

  Future<List<RecommendationItem>> runAnalysis() async {
    final sections = await getSections();
    final resume = await getResume();
    final recommendations = _analyzer.analyze(
      sections: sections,
      resumeText: resume?.extractedText,
      targetRole: await getTargetRole(),
      targetIndustry: await getTargetIndustry(),
      language: await getProfileLanguage(),
    );
    await _db.clearRuleRecommendations();
    await _db.insertRecommendations(recommendations);
    return recommendations;
  }

  Future<ProfileEvaluation?> getLatestEvaluation() async {
    final stored = await _db.getLatestProfileEvaluation();
    if (stored == null) return null;
    final recs = await _db.getEvaluatorRecommendations();
    return ProfileEvaluation(
      id: stored.id,
      evaluatedAt: stored.evaluatedAt,
      currentOverall: stored.currentOverall,
      aiOverall: stored.aiOverall,
      summary: stored.summary,
      currentBySection: stored.currentBySection,
      aiBySection: stored.aiBySection,
      recommendations: recs,
      usedLlm: stored.usedLlm,
      providerLabel: stored.providerLabel,
      errorDetail: stored.errorDetail,
    );
  }

  Future<ProfileEvaluationResult> runEvaluation() async {
    final sections = await getSections();
    final resume = await getResume();
    final settings = await getAiSettings();
    final result = await _evaluator.evaluate(
      settings: settings,
      sections: sections,
      targetRole: await getTargetRole(),
      targetIndustry: await getTargetIndustry(),
      displayName: await getDisplayName(),
      resumeText: resume?.extractedText,
      profileLanguage: await getProfileLanguage(),
    );

    final evaluation = result.evaluation;
    await _db.saveProfileEvaluation(evaluation);
    await _db.clearEvaluatorRecommendations();
    if (evaluation.recommendations.isNotEmpty) {
      await _db.insertRecommendations(
        evaluation.recommendations
            .map(
              (r) => RecommendationItem(
                sectionKey: r.sectionKey,
                title: r.title,
                body: r.body,
                priority: r.priority,
                category: r.category,
                source: RecommendationSource.evaluator,
                createdAt: DateTime.now(),
              ),
            )
            .toList(),
      );
    }

    return result;
  }
}

class ImportResult {
  const ImportResult({
    required this.success,
    required this.sectionsFound,
    required this.message,
    this.sectionKeys = const [],
    this.pending,
  });

  final bool success;
  final int sectionsFound;
  final String message;
  final List<String> sectionKeys;
  final PendingImport? pending;
}
