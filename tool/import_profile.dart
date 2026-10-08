// One-off / dev import of public LinkedIn profile into local DB.
// Run: dart run tool/import_profile.dart

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final home = Platform.environment['HOME']!;
  final dbPath = p.join(
    home,
    'Library/Containers/com.profilecoach.linkedinProfileCoach/Data/Library/Application Support/com.profilecoach.linkedinProfileCoach/linkedin_profile_coach.db',
  );

  if (!File(dbPath).existsSync()) {
    stderr.writeln('Database not found: $dbPath');
    exit(1);
  }

  final db = await openDatabase(dbPath);
  final now = DateTime.now().millisecondsSinceEpoch;

  const sections = <String, String>{
    'headline': 'CTO (AraX Group Ltd.) | CTO at AraxGroup Ltd.',
    'about': '''Опыт разработки: 15+ лет
Формат работы: Дистанционная

Языки программирования
C#: WPF, Avalonia — продвинутый уровень
JavaScript: Node.js, фронтенд и бэкенд — продвинутый уровень
Python: AI/ML — опыт работы

Фреймворки: Node.js (Express, NestJS), React, Keras, TensorFlow, Scikit-learn
Базы данных: MSSQL, PostgreSQL, MySQL, MongoDB — продвинутый уровень
Blockchain: Solidity, dApps, Truffle, Hardhat, Web3.js
DevOps: Docker, GitLab CI''',
    'experience': '''CTO at AraxGroup Ltd. (текущая позиция)
Июль 2007 — настоящее время (18+ лет)
Москва, Россия
Engineering and Technical • C-Level''',
    'education': '''Инженер, Электроника физических установок
Национальный исследовательский ядерный университет «МИФИ»
1992 — 1998''',
    'skills':
        'C#, WPF, Avalonia, JavaScript, Node.js, Express, NestJS, React, Python, AI/ML, Keras, TensorFlow, Tesseract, Scikit-learn, Pandas, NumPy, MSSQL, PostgreSQL, MySQL, MongoDB, Solidity, Web3.js, Truffle, Hardhat, Docker, GitLab CI, DevOps',
  };

  for (final entry in sections.entries) {
    await db.update(
      'profile_sections',
      {
        'content': entry.value,
        'updated_at': now,
      },
      where: 'section_key = ?',
      whereArgs: [entry.key],
    );
  }

  await db.insert(
    'linkedin_imports',
    {
      'profile_url': 'https://www.linkedin.com/in/alex-artamokhov-6a686886/',
      'source': 'profileUrl',
      'sections_found': sections.length,
      'imported_at': now,
      'note': 'Public profile import: ${sections.keys.join(', ')}',
    },
  );

  await db.close();
  stdout.writeln('Imported ${sections.length} sections into $dbPath');
}
