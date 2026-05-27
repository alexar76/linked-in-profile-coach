import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/linkedin_import_record.dart';
import '../models/profile_evaluation.dart';
import '../constants/linkedin_section_order.dart';
import '../models/profile_section.dart';
import '../models/recommendation_item.dart';
import '../models/linkedin_analytics.dart';
import '../models/profile_snapshot.dart';
import '../models/resume_document.dart';
import 'dart:convert';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;
  Future<Database>? _opening;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _opening ??= _init();
    _db = await _opening;
    return _db!;
  }

  static bool _ffiInitialized = false;

  Future<Database> _init() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (!_ffiInitialized) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        _ffiInitialized = true;
      }
    }

    final dir = await getApplicationSupportDirectory();
    final dbPath = p.join(dir.path, 'linkedin_profile_coach.db');

    final db = await openDatabase(
      dbPath,
      version: 6,
      onCreate: (db, version) async {
        await _createSchema(db, seedSections: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _migrateToV2(db);
        }
        if (oldVersion < 3) {
          await _migrateToV3(db);
        }
        if (oldVersion < 4) {
          await _migrateToV4(db);
        }
        if (oldVersion < 5) {
          await _migrateToV5(db);
        }
        if (oldVersion < 6) {
          await _migrateToV6(db);
        }
      },
    );

    return db;
  }

  Future<void> _createSchema(Database db, {required bool seedSections}) async {
    await db.execute('''
      CREATE TABLE profile_sections (
        section_key TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        hint TEXT NOT NULL,
        content TEXT NOT NULL DEFAULT '',
        ai_content TEXT NOT NULL DEFAULT '',
        updated_at INTEGER,
        ai_generated_at INTEGER,
        manual_synced_at INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE recommendations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        section_key TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        priority TEXT NOT NULL,
        category TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        source TEXT NOT NULL DEFAULT 'rules'
      )
    ''');
    await db.execute('''
      CREATE TABLE profile_evaluations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        evaluated_at INTEGER NOT NULL,
        current_overall INTEGER NOT NULL,
        ai_overall INTEGER NOT NULL DEFAULT 0,
        summary TEXT NOT NULL DEFAULT '',
        current_scores_json TEXT NOT NULL DEFAULT '{}',
        ai_scores_json TEXT NOT NULL DEFAULT '{}',
        used_llm INTEGER NOT NULL DEFAULT 0,
        provider_label TEXT,
        error_detail TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE resume_documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filename TEXT NOT NULL,
        file_path TEXT NOT NULL,
        extracted_text TEXT NOT NULL,
        uploaded_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    if (seedSections) {
      final batch = db.batch();
      for (final section in linkedInSections) {
        batch.insert('profile_sections', {
          'section_key': section.key,
          'title': section.title,
          'description': section.description,
          'hint': section.hint,
          'content': '',
          'ai_content': '',
        });
      }
      await batch.commit(noResult: true);
    }

    await db.execute('''
      CREATE TABLE linkedin_analytics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recorded_at INTEGER NOT NULL,
        metrics_json TEXT NOT NULL,
        source TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE profile_snapshots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        captured_at INTEGER NOT NULL,
        sections_json TEXT NOT NULL,
        source TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS linkedin_imports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_url TEXT NOT NULL DEFAULT '',
        source TEXT NOT NULL,
        sections_found INTEGER NOT NULL,
        imported_at INTEGER NOT NULL,
        note TEXT
      )
    ''');
  }

  Future<void> _migrateToV3(Database db) async {
    final recCols = await db.rawQuery('PRAGMA table_info(recommendations)');
    final recNames = recCols.map((c) => c['name'] as String).toSet();
    if (!recNames.contains('source')) {
      await db.execute(
        "ALTER TABLE recommendations ADD COLUMN source TEXT NOT NULL DEFAULT 'rules'",
      );
    }

    await db.execute('''
      CREATE TABLE IF NOT EXISTS profile_evaluations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        evaluated_at INTEGER NOT NULL,
        current_overall INTEGER NOT NULL,
        ai_overall INTEGER NOT NULL DEFAULT 0,
        summary TEXT NOT NULL DEFAULT '',
        current_scores_json TEXT NOT NULL DEFAULT '{}',
        ai_scores_json TEXT NOT NULL DEFAULT '{}',
        used_llm INTEGER NOT NULL DEFAULT 0,
        provider_label TEXT,
        error_detail TEXT
      )
    ''');
  }

  Future<void> _migrateToV2(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(profile_sections)');
    final names = columns.map((c) => c['name'] as String).toSet();

    if (!names.contains('ai_content')) {
      await db.execute(
        "ALTER TABLE profile_sections ADD COLUMN ai_content TEXT NOT NULL DEFAULT ''",
      );
    }
    if (!names.contains('ai_generated_at')) {
      await db.execute(
        'ALTER TABLE profile_sections ADD COLUMN ai_generated_at INTEGER',
      );
    }
    if (!names.contains('manual_synced_at')) {
      await db.execute(
        'ALTER TABLE profile_sections ADD COLUMN manual_synced_at INTEGER',
      );
    }

    await db.execute('''
      CREATE TABLE IF NOT EXISTS linkedin_imports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_url TEXT NOT NULL DEFAULT '',
        source TEXT NOT NULL,
        sections_found INTEGER NOT NULL,
        imported_at INTEGER NOT NULL,
        note TEXT
      )
    ''');
  }

  Future<List<ProfileSection>> getProfileSections() async {
    final db = await database;
    final rows = await db.query('profile_sections');
    final sections = rows.map(ProfileSection.fromMap).toList();
    sections.sort(
      (a, b) => linkedInSectionSortIndex(a.key)
          .compareTo(linkedInSectionSortIndex(b.key)),
    );
    return sections;
  }

  Future<void> _migrateToV6(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS linkedin_analytics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recorded_at INTEGER NOT NULL,
        metrics_json TEXT NOT NULL,
        source TEXT NOT NULL
      )
    ''');
  }

  Future<void> _migrateToV5(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS profile_snapshots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        captured_at INTEGER NOT NULL,
        sections_json TEXT NOT NULL,
        source TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  Future<void> _migrateToV4(Database db) async {
    final existing = await db.query('profile_sections');
    final existingKeys =
        existing.map((r) => r['section_key'] as String).toSet();
    final batch = db.batch();
    for (final section in linkedInSections) {
      if (!existingKeys.contains(section.key)) {
        batch.insert('profile_sections', {
          'section_key': section.key,
          'title': section.title,
          'description': section.description,
          'hint': section.hint,
          'content': '',
          'ai_content': '',
        });
      }
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveProfileSection(ProfileSection section) async {
    final db = await database;
    await db.update(
      'profile_sections',
      {
        'content': section.content,
        'ai_content': section.aiContent,
        'updated_at': section.updatedAt?.millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch,
        'ai_generated_at': section.aiGeneratedAt?.millisecondsSinceEpoch,
        'manual_synced_at': section.manualSyncedAt?.millisecondsSinceEpoch,
      },
      where: 'section_key = ?',
      whereArgs: [section.key],
    );
  }

  Future<void> importLinkedInSections(Map<String, String> sections) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final entry in sections.entries) {
      await db.update(
        'profile_sections',
        {'content': entry.value, 'updated_at': now},
        where: 'section_key = ?',
        whereArgs: [entry.key],
      );
    }
  }

  Future<void> saveAiSections(Map<String, String> aiByKey) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final entry in aiByKey.entries) {
      await db.update(
        'profile_sections',
        {'ai_content': entry.value, 'ai_generated_at': now},
        where: 'section_key = ?',
        whereArgs: [entry.key],
      );
    }
  }

  Future<void> markSectionSynced(String sectionKey, bool synced) async {
    final db = await database;
    await db.update(
      'profile_sections',
      {
        'manual_synced_at':
            synced ? DateTime.now().millisecondsSinceEpoch : null,
      },
      where: 'section_key = ?',
      whereArgs: [sectionKey],
    );
  }

  Future<LinkedInImportRecord?> getLastImport() async {
    final db = await database;
    final rows = await db.query(
      'linkedin_imports',
      orderBy: 'imported_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LinkedInImportRecord.fromMap(rows.first);
  }

  Future<void> logImport(LinkedInImportRecord record) async {
    final db = await database;
    await db.insert('linkedin_imports', record.toMap());
  }

  Future<void> clearRecommendations() async {
    final db = await database;
    await db.delete('recommendations');
  }

  Future<void> clearRuleRecommendations() async {
    final db = await database;
    await db.delete(
      'recommendations',
      where: 'source = ?',
      whereArgs: [RecommendationSource.rules.name],
    );
  }

  Future<void> clearEvaluatorRecommendations() async {
    final db = await database;
    await db.delete(
      'recommendations',
      where: "source = ?",
      whereArgs: [RecommendationSource.evaluator.name],
    );
  }

  Future<void> insertRecommendations(List<RecommendationItem> items) async {
    final db = await database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert('recommendations', item.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<RecommendationItem>> getRecommendations() async {
    final db = await database;
    final rows = await db.query(
      'recommendations',
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<List<RecommendationItem>> getRuleRecommendations() async {
    final db = await database;
    final rows = await db.query(
      'recommendations',
      where: 'source = ?',
      whereArgs: [RecommendationSource.rules.name],
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<int> saveProfileEvaluation(ProfileEvaluation evaluation) async {
    final db = await database;
    return db.insert('profile_evaluations', evaluation.toMap());
  }

  Future<ProfileEvaluation?> getLatestProfileEvaluation() async {
    final db = await database;
    final rows = await db.query(
      'profile_evaluations',
      orderBy: 'evaluated_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProfileEvaluation.fromMap(rows.first);
  }

  Future<List<RecommendationItem>> getEvaluatorRecommendations() async {
    final db = await database;
    final rows = await db.query(
      'recommendations',
      where: 'source = ?',
      whereArgs: [RecommendationSource.evaluator.name],
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<void> setRecommendationDone(int id, bool done) async {
    final db = await database;
    await db.update(
      'recommendations',
      {'is_done': done ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ResumeDocument?> getActiveResume() async {
    final db = await database;
    final rows = await db.query(
      'resume_documents',
      orderBy: 'uploaded_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ResumeDocument.fromMap(rows.first);
  }

  Future<void> saveResume({
    required String filename,
    required String filePath,
    required String extractedText,
  }) async {
    final db = await database;
    await db.delete('resume_documents');
    await db.insert('resume_documents', {
      'filename': filename,
      'file_path': filePath,
      'extracted_text': extractedText,
      'uploaded_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> saveProfileSnapshot(ProfileSnapshot snapshot) async {
    final db = await database;
    return db.insert('profile_snapshots', snapshot.toMap());
  }

  Future<List<ProfileSnapshot>> getProfileSnapshots({int limit = 20}) async {
    final db = await database;
    final rows = await db.query(
      'profile_snapshots',
      orderBy: 'captured_at DESC',
      limit: limit,
    );
    return rows.map(ProfileSnapshot.fromMap).toList();
  }

  Future<void> restoreProfileSnapshot(ProfileSnapshot snapshot) async {
    final map =
        jsonDecode(snapshot.sectionsJson) as Map<String, dynamic>;
    final content = <String, String>{};
    for (final e in map.entries) {
      if (e.value is String) content[e.key] = e.value as String;
    }
    await importLinkedInSections(content);
  }

  Future<Map<String, String>> snapshotCurrentContent() async {
    final sections = await getProfileSections();
    return {for (final s in sections) s.key: s.content};
  }

  Future<int> saveLinkedInAnalytics(LinkedInAnalyticsRecord record) async {
    final db = await database;
    return db.insert('linkedin_analytics', record.toMap());
  }

  Future<List<LinkedInAnalyticsRecord>> getLinkedInAnalyticsHistory({
    int limit = 12,
  }) async {
    final db = await database;
    final rows = await db.query(
      'linkedin_analytics',
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return rows.map(LinkedInAnalyticsRecord.fromMap).toList();
  }

  Future<int> getImportCount() async {
    final db = await database;
    final row = await db.rawQuery('SELECT COUNT(*) AS c FROM linkedin_imports');
    return row.first['c'] as int? ?? 0;
  }

  Future<List<ProfileEvaluation>> getEvaluationHistory({int limit = 24}) async {
    final db = await database;
    final rows = await db.query(
      'profile_evaluations',
      orderBy: 'evaluated_at ASC',
      limit: limit,
    );
    return rows.map(ProfileEvaluation.fromMap).toList();
  }
}
