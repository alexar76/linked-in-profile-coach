/// Demo «до / после ИИ» for documentation screenshots.
class DocCompareSample {
  const DocCompareSample({
    required this.key,
    required this.titleRu,
    required this.before,
    required this.after,
  });

  final String key;
  final String titleRu;
  final String before;
  final String after;
}

const docCompareSamples = [
  DocCompareSample(
    key: 'headline',
    titleRu: 'Заголовок (Headline)',
    before: 'Flutter Developer',
    after:
        'Senior Flutter Developer | FinTech & B2B SaaS | Remote · 8+ лет · Dart, CI/CD',
  ),
  DocCompareSample(
    key: 'about',
    titleRu: 'О себе (About)',
    before:
        'Разрабатываю мобильные приложения. Интересуюсь Flutter и продуктовой разработкой.',
    after:
        'Senior Flutter-разработчик с 8+ годами опыта в FinTech и B2B.\n\n'
        '• Вёл команды до 6 человек, выводил продукты в production\n'
        '• Сократил time-to-release на 35% за счёт CI/CD и модульной архитектуры\n'
        '• Стек: Flutter, Dart, SQLite, REST, Firebase\n\n'
        'Открыт к роли Tech Lead / Senior Mobile — пишите в LinkedIn.',
  ),
  DocCompareSample(
    key: 'experience',
    titleRu: 'Опыт (Experience)',
    before:
        '2020–2024 — Mobile Developer, FinApp\n'
        'Делал приложение на Flutter.',
    after:
        '2022–н.в. — Senior Flutter Developer, FinApp (FinTech, 200+ сотрудников)\n'
        '• Спроектировал архитектуру клиента (60k+ MAU), снизил краши на 40%\n'
        '• Внедрил feature flags и golden-тесты — релизы 2× чаще\n'
        '• Менторил 3 middle-разработчиков\n\n'
        '2019–2022 — Flutter Developer, StartupLab\n'
        '• MVP за 10 недель → seed-раунд; интеграции с KYC-провайдерами',
  ),
  DocCompareSample(
    key: 'skills',
    titleRu: 'Навыки (Skills)',
    before: 'Flutter, Dart, Git',
    after:
        'Flutter, Dart, SQLite, REST API, CI/CD, Firebase, FinTech, '
        'Mobile Architecture, Team Leadership, Agile, Kotlin (basic)',
  ),
];
