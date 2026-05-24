import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constants/linkedin_section_order.dart';
import '../models/linkedin_analytics.dart';
import '../models/linkedin_import_record.dart';
import '../models/managed_profile.dart';
import '../models/profile_evaluation.dart';
import '../models/profile_section.dart';
import '../models/profile_snapshot.dart';
import '../models/recommendation_item.dart';
import '../models/resume_document.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;
  Future<Database>? _opening;
  int? _activeProfileId;

  static const _keyActiveProfileId = 'active_profile_id';

  static const _perProfileSettingKeys = {
    'target_role',
    'target_industry',
    'display_name',
    'profile_url',
    'premium_template_id',
    'last_export_path',
    'watch_folder_path',
    'watch_folder_processed_mtime',
    'import_reminder_snooze_until',
    'job_description_text',
    'ai_creativity',
    'ai_variant_count',
    'ai_profile_focus',
    'ai_skip_generation_dialog',
  };

  void invalidateActiveProfileCache() => _activeProfileId = null;

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
      version: 9,
      onCreate: (db, version) async {
        await _createSchemaV9(db, seedDefaultProfile: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _migrateToV2(db);
        if (oldVersion < 3) await _migrateToV3(db);
        if (oldVersion < 4) await _migrateToV4(db);
        if (oldVersion < 5) await _migrateToV5(db);
        if (oldVersion < 6) await _migrateToV6(db);
        if (oldVersion < 7) await _migrateToV7(db);
        if (oldVersion < 8) await _migrateToV8(db);
        if (oldVersion < 9) await _migrateToV9(db);
      },
    );

    return db;
  }

  Future<int> requireActiveProfileId() async {
    if (_activeProfileId != null) return _activeProfileId!;
    final db = await database;
    final saved = await getSetting(_keyActiveProfileId);
    final parsed = int.tryParse(saved ?? '');
    if (parsed != null) {
      final rows = await db.query(
        'profiles',
        where: 'id = ?',
        whereArgs: [parsed],
        limit: 1,
      );
      if (rows.isNotEmpty) {
        _activeProfileId = parsed;
        return parsed;
      }
    }
    final all = await db.query('profiles', orderBy: 'id ASC', limit: 1);
    if (all.isEmpty) {
      final id = await _createDefaultProfile(db);
      _activeProfileId = id;
      await setSetting(_keyActiveProfileId, id.toString());
      return id;
    }
    final id = all.first['id'] as int;
    _activeProfileId = id;
    await setSetting(_keyActiveProfileId, id.toString());
    return id;
  }

  Future<void> setActiveProfileId(int profileId) async {
    final db = await database;
    final rows = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [profileId],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw StateError('Profile $profileId does not exist');
    }
    _activeProfileId = profileId;
    await setSetting(_keyActiveProfileId, profileId.toString());
  }

  Future<List<ManagedProfile>> listProfiles() async {
    final db = await database;
    final rows = await db.query('profiles', orderBy: 'created_at ASC');
    final result = <ManagedProfile>[];
    for (final row in rows) {
      final id = row['id'] as int;
      result.add(
        ManagedProfile(
          id: id,
          name: row['name'] as String? ?? '',
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            row['created_at'] as int,
          ),
          displayName: await getProfileSetting(id, 'display_name') ?? '',
          targetRole: await getProfileSetting(id, 'target_role') ?? '',
        ),
      );
    }
    return result;
  }

  Future<int> createProfile(String name) async {
    final db = await database;
    final trimmed = name.trim();
    final label = trimmed.isEmpty ? 'New profile' : trimmed;
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await db.insert('profiles', {
      'name': label,
      'created_at': now,
    });
    await _seedSectionsForProfile(db, id);
    return id;
  }

  Future<void> renameProfile(int profileId, String name) async {
    final db = await database;
    final trimmed = name.trim();
    await db.update(
      'profiles',
      {'name': trimmed.isEmpty ? 'Profile' : trimmed},
      where: 'id = ?',
      whereArgs: [profileId],
    );
  }

  Future<void> deleteProfile(int profileId) async {
    final db = await database;
    final countRow =
        await db.rawQuery('SELECT COUNT(*) AS c FROM profiles');
    final count = countRow.first['c'] as int? ?? 0;
    if (count <= 1) {
      throw StateError('Cannot delete the only profile');
    }

    final activeId = await requireActiveProfileId();
    await db.transaction((txn) async {
      for (final table in [
        'profile_sections',
        'recommendations',
        'profile_evaluations',
        'resume_documents',
        'profile_snapshots',
        'linkedin_imports',
        'linkedin_analytics',
        'wow_cache',
        'profile_settings',
      ]) {
        await txn.delete(
          table,
          where: 'profile_id = ?',
          whereArgs: [profileId],
        );
      }
      await txn.delete(
        'profiles',
        where: 'id = ?',
        whereArgs: [profileId],
      );
    });

    if (activeId == profileId) {
      invalidateActiveProfileCache();
      final remaining = await listProfiles();
      if (remaining.isNotEmpty) {
        await setActiveProfileId(remaining.first.id);
      }
    }
  }

  Future<String?> getProfileSetting(int profileId, String key) async {
    final db = await database;
    final rows = await db.query(
      'profile_settings',
      where: 'profile_id = ? AND key = ?',
      whereArgs: [profileId, key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setProfileSetting(
    int profileId,
    String key,
    String value,
  ) async {
    final db = await database;
    await db.insert(
      'profile_settings',
      {'profile_id': profileId, 'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getActiveProfileSetting(String key) async {
    final id = await requireActiveProfileId();
    return getProfileSetting(id, key);
  }

  Future<void> setActiveProfileSetting(String key, String value) async {
    final id = await requireActiveProfileId();
    await setProfileSetting(id, key, value);
  }

  Future<int> _createDefaultProfile(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await db.insert('profiles', {
      'name': 'Default profile',
      'created_at': now,
    });
    await _seedSectionsForProfile(db, id);
    return id;
  }

  Future<void> _seedSectionsForProfile(Database db, int profileId) async {
    final batch = db.batch();
    for (final section in linkedInSections) {
      batch.insert('profile_sections', {
        'profile_id': profileId,
        'section_key': section.key,
        'title': section.title,
        'description': section.description,
        'hint': section.hint,
        'content': '',
        'ai_content': '',
        'ai_variants': '',
        'ai_variant_index': 0,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<void> _createSchemaV9(Database db, {required bool seedDefaultProfile}) async {
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE profile_settings (
        profile_id INTEGER NOT NULL,
        key TEXT NOT NULL,
        value TEXT NOT NULL,
        PRIMARY KEY (profile_id, key)
      )
    ''');
    await db.execute('''
      CREATE TABLE profile_sections (
        profile_id INTEGER NOT NULL,
        section_key TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        hint TEXT NOT NULL,
        content TEXT NOT NULL DEFAULT '',
        ai_content TEXT NOT NULL DEFAULT '',
        ai_variants TEXT NOT NULL DEFAULT '',
        ai_variant_index INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER,
        ai_generated_at INTEGER,
        manual_synced_at INTEGER,
        PRIMARY KEY (profile_id, section_key)
      )
    ''');
    await db.execute('''
      CREATE TABLE recommendations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER NOT NULL,
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
        profile_id INTEGER NOT NULL,
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
        profile_id INTEGER NOT NULL,
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
    await db.execute('''
      CREATE TABLE linkedin_analytics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER NOT NULL,
        recorded_at INTEGER NOT NULL,
        metrics_json TEXT NOT NULL,
        source TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE profile_snapshots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER NOT NULL,
        captured_at INTEGER NOT NULL,
        sections_json TEXT NOT NULL,
        source TEXT NOT NULL,
        note TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE linkedin_imports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER NOT NULL,
        profile_url TEXT NOT NULL DEFAULT '',
        source TEXT NOT NULL,
        sections_found INTEGER NOT NULL,
        imported_at INTEGER NOT NULL,
        note TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE wow_cache (
        profile_id INTEGER NOT NULL,
        feature TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        updated_at INTEGER NOT NULL,
        PRIMARY KEY (profile_id, feature)
      )
    ''');

    if (seedDefaultProfile) {
      final id = await _createDefaultProfile(db);
      await _setSettingDb(db, _keyActiveProfileId, id.toString());
      _activeProfileId = id;
    }
  }

  Future<void> _migrateToV9(Database db) async {
    final profileCols = await db.rawQuery('PRAGMA table_info(profiles)');
    if (profileCols.isEmpty) {
      await db.execute('''
        CREATE TABLE profiles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          created_at INTEGER NOT NULL
        )
      ''');
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert('profiles', {
        'id': 1,
        'name': 'Default profile',
        'created_at': now,
      });
    }

    final settingsCols =
        await db.rawQuery('PRAGMA table_info(profile_settings)');
    if (settingsCols.isEmpty) {
      await db.execute('''
        CREATE TABLE profile_settings (
          profile_id INTEGER NOT NULL,
          key TEXT NOT NULL,
          value TEXT NOT NULL,
          PRIMARY KEY (profile_id, key)
        )
      ''');
      for (final key in _perProfileSettingKeys) {
        final rows = await db.query(
          'app_settings',
          where: 'key = ?',
          whereArgs: [key],
          limit: 1,
        );
        if (rows.isNotEmpty) {
          await db.insert('profile_settings', {
            'profile_id': 1,
            'key': key,
            'value': rows.first['value'],
          });
          await db.delete(
            'app_settings',
            where: 'key = ?',
            whereArgs: [key],
          );
        }
      }
      await _setSettingDb(db, _keyActiveProfileId, '1');
    }

    final sectionCols = await db.rawQuery('PRAGMA table_info(profile_sections)');
    final sectionNames =
        sectionCols.map((c) => c['name'] as String).toSet();
    if (!sectionNames.contains('profile_id')) {
      await db.execute('''
        CREATE TABLE profile_sections_new (
          profile_id INTEGER NOT NULL,
          section_key TEXT NOT NULL,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          hint TEXT NOT NULL,
          content TEXT NOT NULL DEFAULT '',
          ai_content TEXT NOT NULL DEFAULT '',
          ai_variants TEXT NOT NULL DEFAULT '',
          ai_variant_index INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER,
          ai_generated_at INTEGER,
          manual_synced_at INTEGER,
          PRIMARY KEY (profile_id, section_key)
        )
      ''');
      await db.execute('''
        INSERT INTO profile_sections_new
        SELECT 1, section_key, title, description, hint, content, ai_content,
               COALESCE(ai_variants, ''), COALESCE(ai_variant_index, 0),
               updated_at, ai_generated_at, manual_synced_at
        FROM profile_sections
      ''');
      await db.execute('DROP TABLE profile_sections');
      await db.execute(
        'ALTER TABLE profile_sections_new RENAME TO profile_sections',
      );
    }

    await _addProfileIdColumn(db, 'recommendations');
    await _addProfileIdColumn(db, 'profile_evaluations');
    await _addProfileIdColumn(db, 'resume_documents');
    await _addProfileIdColumn(db, 'profile_snapshots');
    await _addProfileIdColumn(db, 'linkedin_imports');
    await _addProfileIdColumn(db, 'linkedin_analytics');

    final wowCols = await db.rawQuery('PRAGMA table_info(wow_cache)');
    final wowNames = wowCols.map((c) => c['name'] as String).toSet();
    if (!wowNames.contains('profile_id')) {
      await db.execute('''
        CREATE TABLE wow_cache_new (
          profile_id INTEGER NOT NULL,
          feature TEXT NOT NULL,
          payload_json TEXT NOT NULL,
          updated_at INTEGER NOT NULL,
          PRIMARY KEY (profile_id, feature)
        )
      ''');
      await db.execute('''
        INSERT INTO wow_cache_new (profile_id, feature, payload_json, updated_at)
        SELECT 1, feature, payload_json, updated_at FROM wow_cache
      ''');
      await db.execute('DROP TABLE wow_cache');
      await db.execute('ALTER TABLE wow_cache_new RENAME TO wow_cache');
    }

    _activeProfileId = 1;
  }

  Future<void> _addProfileIdColumn(Database db, String table) async {
    final cols = await db.rawQuery('PRAGMA table_info($table)');
    final names = cols.map((c) => c['name'] as String).toSet();
    if (names.contains('profile_id')) return;
    await db.execute(
      'ALTER TABLE $table ADD COLUMN profile_id INTEGER NOT NULL DEFAULT 1',
    );
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

  Future<void> _migrateToV8(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS wow_cache (
        feature TEXT PRIMARY KEY,
        payload_json TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _migrateToV7(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(profile_sections)');
    final names = columns.map((c) => c['name'] as String).toSet();
    if (!names.contains('ai_variants')) {
      await db.execute(
        "ALTER TABLE profile_sections ADD COLUMN ai_variants TEXT NOT NULL DEFAULT ''",
      );
    }
    if (!names.contains('ai_variant_index')) {
      await db.execute(
        'ALTER TABLE profile_sections ADD COLUMN ai_variant_index INTEGER NOT NULL DEFAULT 0',
      );
    }
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

  Future<List<ProfileSection>> getProfileSections() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'profile_sections',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    final sections = rows.map(ProfileSection.fromMap).toList();
    sections.sort(
      (a, b) => linkedInSectionSortIndex(a.key)
          .compareTo(linkedInSectionSortIndex(b.key)),
    );
    return sections;
  }

  Future<void> saveProfileSection(ProfileSection section) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.update(
      'profile_sections',
      {
        'content': section.content,
        'ai_content': section.aiContent,
        'ai_variants': section.toMap()['ai_variants'],
        'ai_variant_index': section.selectedVariantIndex,
        'updated_at': section.updatedAt?.millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch,
        'ai_generated_at': section.aiGeneratedAt?.millisecondsSinceEpoch,
        'manual_synced_at': section.manualSyncedAt?.millisecondsSinceEpoch,
      },
      where: 'profile_id = ? AND section_key = ?',
      whereArgs: [profileId, section.key],
    );
  }

  Future<void> importLinkedInSections(Map<String, String> sections) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final entry in sections.entries) {
      await db.update(
        'profile_sections',
        {'content': entry.value, 'updated_at': now},
        where: 'profile_id = ? AND section_key = ?',
        whereArgs: [profileId, entry.key],
      );
    }
  }

  Future<void> saveAiSections(Map<String, String> aiByKey) async {
    await saveAiSectionsWithVariants(
      aiByKey.map((k, v) => MapEntry(k, [v])),
    );
  }

  Future<void> saveAiSectionsWithVariants(
    Map<String, List<String>> variantsByKey,
  ) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final entry in variantsByKey.entries) {
      final variants = entry.value.where((v) => v.trim().isNotEmpty).toList();
      if (variants.isEmpty) continue;
      final active = variants.first;
      await db.update(
        'profile_sections',
        {
          'ai_content': active,
          'ai_variants': jsonEncode(variants),
          'ai_variant_index': 0,
          'ai_generated_at': now,
        },
        where: 'profile_id = ? AND section_key = ?',
        whereArgs: [profileId, entry.key],
      );
    }
  }

  Future<void> markSectionSynced(String sectionKey, bool synced) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.update(
      'profile_sections',
      {
        'manual_synced_at':
            synced ? DateTime.now().millisecondsSinceEpoch : null,
      },
      where: 'profile_id = ? AND section_key = ?',
      whereArgs: [profileId, sectionKey],
    );
  }

  Future<LinkedInImportRecord?> getLastImport() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'linkedin_imports',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'imported_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LinkedInImportRecord.fromMap(rows.first);
  }

  Future<void> logImport(LinkedInImportRecord record) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final map = record.toMap();
    map['profile_id'] = profileId;
    await db.insert('linkedin_imports', map);
  }

  Future<void> clearRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.delete(
      'recommendations',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
  }

  Future<void> clearRuleRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.delete(
      'recommendations',
      where: 'profile_id = ? AND source = ?',
      whereArgs: [profileId, RecommendationSource.rules.name],
    );
  }

  Future<void> clearEvaluatorRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.delete(
      'recommendations',
      where: 'profile_id = ? AND source = ?',
      whereArgs: [profileId, RecommendationSource.evaluator.name],
    );
  }

  Future<void> insertRecommendations(List<RecommendationItem> items) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final batch = db.batch();
    for (final item in items) {
      final map = item.toMap();
      map['profile_id'] = profileId;
      batch.insert('recommendations', map);
    }
    await batch.commit(noResult: true);
  }

  Future<List<RecommendationItem>> getRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'recommendations',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<List<RecommendationItem>> getRuleRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'recommendations',
      where: 'profile_id = ? AND source = ?',
      whereArgs: [profileId, RecommendationSource.rules.name],
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<int> saveProfileEvaluation(ProfileEvaluation evaluation) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final map = evaluation.toMap();
    map['profile_id'] = profileId;
    return db.insert('profile_evaluations', map);
  }

  Future<ProfileEvaluation?> getLatestProfileEvaluation() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'profile_evaluations',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'evaluated_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProfileEvaluation.fromMap(rows.first);
  }

  Future<List<RecommendationItem>> getEvaluatorRecommendations() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'recommendations',
      where: 'profile_id = ? AND source = ?',
      whereArgs: [profileId, RecommendationSource.evaluator.name],
      orderBy:
          "CASE priority WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END, created_at DESC",
    );
    return rows.map(RecommendationItem.fromMap).toList();
  }

  Future<void> setRecommendationDone(int id, bool done) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.update(
      'recommendations',
      {'is_done': done ? 1 : 0},
      where: 'id = ? AND profile_id = ?',
      whereArgs: [id, profileId],
    );
  }

  Future<ResumeDocument?> getActiveResume() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'resume_documents',
      where: 'profile_id = ?',
      whereArgs: [profileId],
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
    final profileId = await requireActiveProfileId();
    await db.delete(
      'resume_documents',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    await db.insert('resume_documents', {
      'profile_id': profileId,
      'filename': filename,
      'file_path': filePath,
      'extracted_text': extractedText,
      'uploaded_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<String?> _getSettingDb(Database db, String key) async {
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> _setSettingDb(Database db, String key, String value) async {
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    return _getSettingDb(db, key);
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await _setSettingDb(db, key, value);
  }

  Future<int> saveProfileSnapshot(ProfileSnapshot snapshot) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final map = snapshot.toMap();
    map['profile_id'] = profileId;
    return db.insert('profile_snapshots', map);
  }

  Future<List<ProfileSnapshot>> getProfileSnapshots({int limit = 20}) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'profile_snapshots',
      where: 'profile_id = ?',
      whereArgs: [profileId],
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
    final profileId = await requireActiveProfileId();
    final map = record.toMap();
    map['profile_id'] = profileId;
    return db.insert('linkedin_analytics', map);
  }

  Future<List<LinkedInAnalyticsRecord>> getLinkedInAnalyticsHistory({
    int limit = 12,
  }) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'linkedin_analytics',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return rows.map(LinkedInAnalyticsRecord.fromMap).toList();
  }

  Future<int> getImportCount() async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final row = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM linkedin_imports WHERE profile_id = ?',
      [profileId],
    );
    return row.first['c'] as int? ?? 0;
  }

  Future<List<ProfileEvaluation>> getEvaluationHistory({int limit = 24}) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'profile_evaluations',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'evaluated_at ASC',
      limit: limit,
    );
    return rows.map(ProfileEvaluation.fromMap).toList();
  }

  Future<void> saveWowCache(String feature, String payloadJson) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    await db.insert(
      'wow_cache',
      {
        'profile_id': profileId,
        'feature': feature,
        'payload_json': payloadJson,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getWowCache(String feature) async {
    final db = await database;
    final profileId = await requireActiveProfileId();
    final rows = await db.query(
      'wow_cache',
      where: 'profile_id = ? AND feature = ?',
      whereArgs: [profileId, feature],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['payload_json'] as String?;
  }
}
