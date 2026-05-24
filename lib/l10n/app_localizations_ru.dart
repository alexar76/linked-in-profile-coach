// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Profile Coach';

  @override
  String get appTagline => 'Премиум-аналитика профиля LinkedIn';

  @override
  String get navOverview => 'Обзор';

  @override
  String get navLinkedIn => 'LinkedIn';

  @override
  String get navAiProfile => 'ИИ профиль';

  @override
  String get navCompare => 'Сравнение';

  @override
  String get navScoring => 'Скоринг';

  @override
  String get navTips => 'Советы';

  @override
  String get navAdmin => 'Настройки';

  @override
  String get btnNext => 'Далее';

  @override
  String get btnBack => 'Назад';

  @override
  String get btnSkip => 'Пропустить';

  @override
  String get btnFinish => 'Готово';

  @override
  String get btnGetStarted => 'Начать';

  @override
  String get btnAnalyze => 'Анализ';

  @override
  String get btnScore => 'Оценить профиль';

  @override
  String get btnGenerateAi => 'Сгенерировать ИИ';

  @override
  String get btnOpenWizard => 'Пошаговый анализ';

  @override
  String get btnSave => 'Сохранить';

  @override
  String get btnTest => 'Проверить';

  @override
  String get langEnglish => 'English';

  @override
  String get langRussian => 'Русский';

  @override
  String get langSpanish => 'Español';

  @override
  String get setupWelcomeTitle => 'Добро пожаловать в Profile Coach';

  @override
  String get setupWelcomeSubtitle =>
      'Премиум-пространство для импорта, улучшения и публикации вашего LinkedIn.';

  @override
  String get setupLanguageTitle => 'Выберите язык';

  @override
  String get setupLanguageSubtitle =>
      'Можно изменить в любой момент в настройках.';

  @override
  String get setupProfileTitle => 'Ваша идентичность';

  @override
  String get setupProfileSubtitle =>
      'Как вы отображаетесь в превью и черновиках ИИ.';

  @override
  String get setupNameLabel => 'Имя';

  @override
  String get setupNameHint => 'Иван Иванов';

  @override
  String get setupUrlLabel => 'URL профиля LinkedIn';

  @override
  String get setupUrlHint => 'https://www.linkedin.com/in/username/';

  @override
  String get setupGoalTitle => 'Карьерный фокус';

  @override
  String get setupGoalSubtitle =>
      'Заголовок, навыки и ИИ-тексты будут под эту цель.';

  @override
  String get setupRoleLabel => 'Целевая роль';

  @override
  String get setupRoleHint => 'Senior Product Manager';

  @override
  String get setupIndustryLabel => 'Отрасль';

  @override
  String get setupIndustryHint => 'FinTech, SaaS, HealthTech…';

  @override
  String get setupTemplateTitle => 'Премиум-шаблоны';

  @override
  String get setupTemplateSubtitle =>
      'Готовые рамки позиционирования. Выберите один для черновика ИИ.';

  @override
  String get templateExecutive => 'Executive';

  @override
  String get templateExecutiveDesc =>
      'Авторитет, масштаб, влияние на уровне C-level.';

  @override
  String get templateTechLeader => 'Tech leader';

  @override
  String get templateTechLeaderDesc =>
      'Инженерное лидерство, delivery, архитектура.';

  @override
  String get templateCreator => 'Creator & brand';

  @override
  String get templateCreatorDesc => 'Аудитория, контент, личный бренд.';

  @override
  String get templateCareerShift => 'Смена карьеры';

  @override
  String get templateCareerShiftDesc =>
      'Переносимые навыки, связующий нарратив.';

  @override
  String get setupAiTitle => 'ИИ-провайдер';

  @override
  String get setupAiSubtitle =>
      'По умолчанию DeepSeek. Укажите API-ключ или пропустите — локальные шаблоны.';

  @override
  String get setupResumeTitle => 'Резюме (опционально)';

  @override
  String get setupResumeSubtitle =>
      'Загрузите .docx (Word 2007+). Старый формат .doc не поддерживается.';

  @override
  String get resumeDragDropHint => 'Перетащите .docx сюда или нажмите «Обзор».';

  @override
  String get resumeErrorLegacyDoc =>
      'Формат .doc не поддерживается. В Word: «Сохранить как» → .docx.';

  @override
  String resumeErrorUnsupportedExt(String ext) {
    return 'Неподдерживаемый тип файла «$ext». Нужен только .docx.';
  }

  @override
  String get resumeErrorEmptyDocx => 'В .docx нет читаемого текста.';

  @override
  String get resumeErrorInvalidDocx =>
      'Не удалось прочитать файл как .docx. Проверьте документ Word.';

  @override
  String get setupImportTitle => 'Импорт LinkedIn';

  @override
  String get setupImportSubtitle =>
      'Скопируйте разделы с заголовками HEADLINE, ABOUT, EXPERIENCE — или позже.';

  @override
  String get setupReadyTitle => 'Всё готово';

  @override
  String get setupReadySubtitle =>
      'Проведём пошаговый анализ — плавно и по делу.';

  @override
  String get analysisTitle => 'Пошаговый анализ';

  @override
  String get analysisStepImport => 'Импорт профиля';

  @override
  String get analysisStepImportDesc => 'Вставьте разделы LinkedIn или JSON.';

  @override
  String get analysisStepAi => 'ИИ-профиль';

  @override
  String get analysisStepAiDesc => 'Улучшенная версия под цель и шаблон.';

  @override
  String get analysisStepReview => 'Сравнение';

  @override
  String get analysisStepReviewDesc => 'Diff и процент схожести по разделам.';

  @override
  String get analysisStepInsights => 'Рекомендации';

  @override
  String get analysisStepInsightsDesc =>
      'Приоритеты: заполнение, продвижение, согласование.';

  @override
  String get analysisStepPublish => 'Публикация';

  @override
  String get analysisStepPublishDesc =>
      'Копирование, ссылки на формы LinkedIn, отметки.';

  @override
  String get analysisCompleteTitle => 'Анализ завершён';

  @override
  String get analysisCompleteSubtitle =>
      'Рабочее пространство готово. Продолжайте с дашборда.';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String stepOf(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get snackAnalysisDone => 'Анализ завершён';

  @override
  String get snackAiDone => 'ИИ-профиль сгенерирован';

  @override
  String get snackSaved => 'Сохранено';

  @override
  String get snackImportDone => 'Импорт выполнен';

  @override
  String get dashboardTitle => 'Обзор';

  @override
  String get dashboardSubtitle =>
      'Полнота профиля, срочные советы и быстрые действия.';

  @override
  String get statSections => 'Разделов заполнено';

  @override
  String get statUrgent => 'Срочных советов';

  @override
  String get statTotalTips => 'Всего советов';

  @override
  String get importLinkedIn => 'Импорт из буфера';

  @override
  String get importJson => 'JSON файл';

  @override
  String get compareTitle => 'Сравнение';

  @override
  String get updateLinkedIn => 'Обновить в LinkedIn';

  @override
  String get linkedInApiNote =>
      'LinkedIn не даёт публичный API для записи в профиль. Копируйте текст и вставляйте в браузере.';

  @override
  String get adminTitle => 'Настройки';

  @override
  String get adminAiSection => 'ИИ — API';

  @override
  String get adminProfileSection => 'Профиль и цель';

  @override
  String get adminResumeSection => 'Резюме (.docx)';

  @override
  String get restartSetup => 'Запустить визард настройки';

  @override
  String get restartAnalysis => 'Запустить пошаговый анализ';

  @override
  String get themeSectionTitle => 'Оформление';

  @override
  String get themeSectionSubtitle =>
      'Тёмные, светлые и розовые палитры — в любой момент.';

  @override
  String get themeGroupDark => 'Тёмные';

  @override
  String get themeGroupLight => 'Светлые';

  @override
  String get themeGroupPink => 'Розовые';

  @override
  String get themeGroupPremium => 'Премиум';

  @override
  String get themeDarkGold => 'Золото ночи';

  @override
  String get themeDarkOcean => 'Глубокий океан';

  @override
  String get themeDarkPlum => 'Королевская слива';

  @override
  String get themeLightIvory => 'Слоновая кость';

  @override
  String get themeLightCloud => 'Облачный синий';

  @override
  String get themeLightSage => 'Мягкий шалфей';

  @override
  String get themeLightPearl => 'Жемчужный';

  @override
  String get themeLightSand => 'Тёплый песок';

  @override
  String get themeLightMint => 'Свежая мята';

  @override
  String get themeLightAmber => 'Золотой янтарь';

  @override
  String get themePinkRose => 'Розовый кварц';

  @override
  String get themePinkBlush => 'Нежный лепесток';

  @override
  String get themePinkLilac => 'Сиреневая мечта';

  @override
  String get themeDarkObsidian => 'Обсидиан платина';

  @override
  String get themeDarkChampagne => 'Шампань нуар';

  @override
  String get themeDarkEmerald => 'Изумруд люкс';

  @override
  String get themeLightPlatinum => 'Платиновый шёлк';

  @override
  String get themeLightChampagne => 'Шампань шёлк';

  @override
  String get btnCancel => 'Отмена';

  @override
  String get btnImport => 'Импортировать';

  @override
  String get btnUploadResume => 'Загрузить .docx';

  @override
  String get btnReplaceResume => 'Заменить резюме';

  @override
  String errorGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get importParseFailed =>
      'Не удалось распознать разделы. Используйте заголовки: HEADLINE, ABOUT, EXPERIENCE…';

  @override
  String importSectionsImported(int count) {
    return 'Импортировано разделов: $count';
  }

  @override
  String get previewNotGenerated => '— Ещё не сгенерировано —';

  @override
  String get previewNotImported => '— Не импортировано —';

  @override
  String get previewYourName => 'Ваше имя';

  @override
  String previewImportMeta(int count, String date) {
    return '$count разд. • $date';
  }

  @override
  String get previewSyncedTooltip => 'Отмечено как применено в LinkedIn';

  @override
  String get previewChangedLabel => 'изменено';

  @override
  String get dashboardHowTo => 'Как пользоваться';

  @override
  String get dashboardStep1 =>
      'Откройте LinkedIn → скопируйте текст каждого раздела';

  @override
  String get dashboardStep2 =>
      'Вставьте на вкладке LinkedIn или через импорт из буфера';

  @override
  String get dashboardStep3 =>
      'Загрузите .docx резюме в настройках (опционально)';

  @override
  String get dashboardStep4 => 'Запустите анализ — получите советы по разделам';

  @override
  String adminResumeLoaded(String date) {
    return 'Загружено: $date';
  }

  @override
  String get adminResumePreviewLabel => 'Превью текста:';

  @override
  String get adminPrivacyNote =>
      'Приложение не подключается к LinkedIn напрямую (ограничения платформы). Скопируйте разделы вручную — так безопаснее для аккаунта.';

  @override
  String adminResumeUploaded(String filename) {
    return 'Резюме загружено: $filename';
  }

  @override
  String get importDialogTitle => 'Импорт из LinkedIn';

  @override
  String get importDialogBody =>
      'Скопируйте разделы профиля с LinkedIn и вставьте ниже. Используйте заголовки:';

  @override
  String get importDialogPlaceholder => 'Вставьте текст профиля…';

  @override
  String get importFormatExample =>
      'HEADLINE:\n...\n\nABOUT:\n...\n\nEXPERIENCE:\n...';

  @override
  String get setupImportPasteHint =>
      'Вставьте с заголовками HEADLINE, ABOUT, EXPERIENCE — или пропустите.';

  @override
  String get aiConnectionOkTitle => 'Соединение OK';

  @override
  String aiConnectionReply(String reply) {
    return 'Ответ: $reply';
  }

  @override
  String get btnClose => 'Закрыть';

  @override
  String get aiProfileTitle => 'Профиль — версия ИИ';

  @override
  String aiProfileSectionsCount(int count) {
    return '$count разделов';
  }

  @override
  String aiProfileDiffCount(int count) {
    return '$count отличий';
  }

  @override
  String get aiProfileSubtitle =>
      'Через LLM (DeepSeek и др.) или локальные шаблоны при ошибке API';

  @override
  String get aiProfileEmptyTitle => 'ИИ-версия ещё не создана';

  @override
  String get aiProfileEmptyHint => 'Нажмите «Сгенерировать ИИ» вверху';

  @override
  String get aiSectionEditLabel => 'Текст ИИ-версии';

  @override
  String get aiSettingsSubtitle =>
      'По умолчанию DeepSeek. При ошибке API — локальные шаблоны.';

  @override
  String get aiGenOptionsTitle => 'Параметры генерации ИИ';

  @override
  String get aiGenOptionsSubtitle =>
      'Настройте стиль профиля. Креативность управляет температурой модели.';

  @override
  String get aiGenFocusLabel => 'Цель профиля';

  @override
  String get aiGenFocusJobSearch => 'Поиск работы';

  @override
  String get aiGenFocusJobSearchDesc => 'Рекрутеры, ATS, соответствие роли';

  @override
  String get aiGenFocusNetworking => 'Нетворкинг';

  @override
  String get aiGenFocusNetworkingDesc => 'Связи, интро, коллаборации';

  @override
  String get aiGenFocusThoughtLeadership => 'Экспертность';

  @override
  String get aiGenFocusThoughtLeadershipDesc => 'Авторитет, инсайты, аудитория';

  @override
  String get aiGenFocusFreelance => 'Фриланс и клиенты';

  @override
  String get aiGenFocusFreelanceDesc => 'Услуги, результаты, доверие';

  @override
  String get aiGenVariantCountLabel => 'Варианты черновика';

  @override
  String get aiGenVariantOne => '1';

  @override
  String get aiGenVariantTwo => '2';

  @override
  String get aiGenVariantThree => '3';

  @override
  String get aiCreativityLabel => 'Креативность';

  @override
  String get aiCreativityHint =>
      'Ниже — факты и стабильность. Выше — разнообразнее формулировки (температура LLM).';

  @override
  String get aiGenSkipDialogLabel =>
      'Больше не спрашивать — использовать эти настройки';

  @override
  String get aiGenPrefsSection => 'Параметры генерации по умолчанию';

  @override
  String get aiGenPrefsSectionSubtitle =>
      'Применяются при «Сгенерировать ИИ» (если не менять в окне).';

  @override
  String get aiVariantPickerLabel => 'Вариант';

  @override
  String get aiProviderLabel => 'Провайдер';

  @override
  String get aiApiKeyLabel => 'API-ключ';

  @override
  String get aiApiKeyStored => 'Ключ провайдера';

  @override
  String get aiModelLabel => 'Модель';

  @override
  String get aiResetDefaults => 'Сбросить URL/модель';

  @override
  String get aiProviderOpenAiHint =>
      'OpenAI: platform.openai.com — /v1/chat/completions';

  @override
  String get aiProviderCompatibleHint =>
      'Любой OpenAI-compatible (Together, Groq, local proxy…)';

  @override
  String get aiProviderAnthropicHint =>
      'Anthropic: console.anthropic.com — отдельный API';

  @override
  String get aiProviderLmRouterHint =>
      'LM Router: base URL из документации сервиса';

  @override
  String get aiProviderOllamaHint => 'Ollama: localhost:11434 — ключ не нужен';

  @override
  String get analysisImportNow => 'Импорт из буфера';

  @override
  String get linkedinSourceTitle => 'LinkedIn — что импортировано';

  @override
  String linkedinSectionsMeta(int filled, int total) {
    return 'Импортировано разделов: $filled / $total';
  }

  @override
  String get linkedinSectionEditLabel => 'Текст из LinkedIn';

  @override
  String get aiLlmToggle => 'LLM';

  @override
  String get aiBaseUrlLabel => 'Base URL';

  @override
  String get aiProviderOpenAiCompatible => 'OpenAI-совместимый';

  @override
  String get aiProviderOllama => 'Ollama (локально)';

  @override
  String get aiProviderCompatibleEndpointHint =>
      'Любой endpoint с /chat/completions';

  @override
  String get aiProviderLmRouterEndpointHint =>
      'Укажите свой base URL, если отличается';

  @override
  String get aiProviderOllamaServeHint => 'Запустите: ollama serve';

  @override
  String get aiProviderDeepseekSetupHint =>
      'DeepSeek: platform.deepseek.com → API Keys. Endpoint: api.deepseek.com';

  @override
  String get aiGenLocalFallback =>
      'LLM выключен или нет API-ключа — локальные шаблоны';

  @override
  String aiGenViaProvider(String provider) {
    return 'Сгенерировано через $provider';
  }

  @override
  String aiGenLlmErrorFallback(String error) {
    return 'Ошибка LLM ($error) — использованы локальные шаблоны';
  }

  @override
  String get compareEmptyLinkedIn => '— пусто —';

  @override
  String get compareEmptyAi => '— не сгенерировано —';

  @override
  String compareSectionsWithDiff(int count) {
    return '$count разделов с отличиями';
  }

  @override
  String get compareSideBySide => 'Рядом';

  @override
  String get compareDiffMode => 'Diff';

  @override
  String get compareSectionLabel => 'Раздел';

  @override
  String get compareLinkedInColumn => 'LinkedIn (импорт)';

  @override
  String get compareAiColumn => 'ИИ-версия';

  @override
  String get diffRemoved => 'Удалено';

  @override
  String get diffAdded => 'Добавлено';

  @override
  String diffSimilarity(String percent) {
    return 'Схожесть: $percent%';
  }

  @override
  String get publishSheetTitle => 'Обновить профиль в LinkedIn';

  @override
  String publishChangedCount(int count) {
    return 'Изменённых разделов: $count';
  }

  @override
  String get publishHasChanges => 'есть изменения';

  @override
  String get publishCopyAi => 'Копировать ИИ-текст';

  @override
  String get publishOpenLinkedIn => 'Открыть в LinkedIn';

  @override
  String get publishMarkDone => 'Отметить готово';

  @override
  String publishCopiedSection(String title) {
    return 'Скопировано: $title';
  }

  @override
  String get publishBrowserFailed => 'Не удалось открыть браузер';

  @override
  String get publishCapabilityCopy => 'Только копирование + ручная вставка';

  @override
  String get publishCapabilityBrowser =>
      'Копировать → открыть форму → вставить';

  @override
  String get publishCapabilityManual => 'Только вручную в интерфейсе LinkedIn';

  @override
  String get publishNoteHeadline =>
      'Вставьте заголовок в поле Headline на странице Intro.';

  @override
  String get publishNoteAbout =>
      'Текст «О себе» — в том же разделе Intro, поле Summary.';

  @override
  String get publishNoteExperience =>
      'Добавьте или отредактируйте каждую позицию отдельно.';

  @override
  String get publishNoteEducation => 'Укажите учебные заведения и годы.';

  @override
  String get publishNoteSkills =>
      'Добавьте навыки вручную; подтверждения — отдельно.';

  @override
  String get publishNoteCertifications => 'Сертификаты добавляются по одному.';

  @override
  String get publishNoteProjects => 'Проекты и ссылки — в разделе Projects.';

  @override
  String get publishNoteFeatured =>
      'Избранное: закрепите пост или ссылку через Add profile section.';

  @override
  String get publishNoteVolunteer => 'Волонтёрский опыт — отдельная форма.';

  @override
  String get publishNoteRecommendations =>
      'Рекомендации запрашиваются у людей — текст нельзя вставить самому.';

  @override
  String get publishNoteGeneral =>
      'Откройте профиль и вставьте текст в нужный раздел.';

  @override
  String get sectionEditDefaultLabel => 'Текст раздела';

  @override
  String get sectionEditPaste => 'Вставить';

  @override
  String get sectionEditHintPrefix => 'Подсказка:';

  @override
  String sectionCharCount(int count) {
    return '$count символов';
  }

  @override
  String get recommendationsEmpty => 'Рекомендаций пока нет';

  @override
  String get recommendationsEmptyHint =>
      'Нажмите «Анализ» в панели — появятся подсказки по разделам (правила).';

  @override
  String get recommendationsEmptyScoringHint =>
      'Советы от «Оценить профиль» (агент-оценщик) — на вкладке «Скоринг», не здесь.';

  @override
  String get filterAllSections => 'Все разделы';

  @override
  String get filterGeneralPromotion => 'Общее / продвижение';

  @override
  String get priorityHigh => 'Высокий';

  @override
  String get priorityMedium => 'Средний';

  @override
  String get priorityLow => 'Низкий';

  @override
  String get categoryFill => 'Заполнение';

  @override
  String get categoryPromote => 'Продвижение';

  @override
  String get categoryAlign => 'Согласование';

  @override
  String get sectionHeadlineTitle => 'Заголовок (Headline)';

  @override
  String get sectionHeadlineDescription =>
      'Первая строка под именем — её видят в поиске рекрутеров и в ленте.';

  @override
  String get sectionHeadlineHint =>
      'Например: Senior Flutter Developer | FinTech | Remote';

  @override
  String get sectionAboutTitle => 'О себе (About)';

  @override
  String get sectionAboutDescription =>
      'Краткая история, ценность, специализация и призыв к действию.';

  @override
  String get sectionAboutHint =>
      '2–4 абзаца: кто вы, чем полезны, чем отличаетесь, как связаться.';

  @override
  String get sectionExperienceTitle => 'Опыт (Experience)';

  @override
  String get sectionExperienceDescription =>
      'Должности, компании, даты и достижения с цифрами.';

  @override
  String get sectionExperienceHint =>
      'Каждая роль: контекст → действия → результат (метрики).';

  @override
  String get sectionEducationTitle => 'Образование (Education)';

  @override
  String get sectionEducationDescription =>
      'ВУЗы, степени, годы, релевантные курсы.';

  @override
  String get sectionEducationHint =>
      'Укажите специальность и активности, если они усиливают профиль.';

  @override
  String get sectionSkillsTitle => 'Навыки (Skills)';

  @override
  String get sectionSkillsDescription =>
      'Ключевые навыки для поиска и подтверждения экспертизы.';

  @override
  String get sectionSkillsHint =>
      'Через запятую или с новой строки: Flutter, Dart, SQLite, ...';

  @override
  String get sectionCertificationsTitle => 'Сертификаты';

  @override
  String get sectionCertificationsDescription =>
      'Официальные курсы и экзамены, повышающие доверие.';

  @override
  String get sectionCertificationsHint => 'Название | Организация | Год';

  @override
  String get sectionProjectsTitle => 'Проекты';

  @override
  String get sectionProjectsDescription =>
      'Публичные кейсы, pet-проекты, open source.';

  @override
  String get sectionProjectsHint => 'Название — роль — стек — результат/ссылка';

  @override
  String get sectionFeaturedTitle => 'Избранное (Featured)';

  @override
  String get sectionFeaturedDescription =>
      'Статьи, посты, портфолио — то, что хотите показать первым.';

  @override
  String get sectionFeaturedHint =>
      'Ссылки или описание материалов в избранном';

  @override
  String get sectionVolunteerTitle => 'Волонтёрство';

  @override
  String get sectionVolunteerDescription =>
      'Некоммерческий опыт, если он релевантен цели.';

  @override
  String get sectionVolunteerHint => 'Организация — роль — период — вклад';

  @override
  String get sectionRecommendationsTitle => 'Рекомендации';

  @override
  String get sectionRecommendationsDescription =>
      'Отзывы коллег — социальное доказательство.';

  @override
  String get sectionRecommendationsHint =>
      'Кого попросить и какие темы попросить осветить';

  @override
  String get sectionLocationIndustryTitle => 'Локация и отрасль';

  @override
  String get sectionLocationIndustryDescription =>
      'Где вы базируетесь и отрасль — видны на карточке профиля.';

  @override
  String get sectionLocationIndustryHint => 'Город, страна · Отрасль';

  @override
  String get sectionContactLinksTitle => 'Контакты и ссылки';

  @override
  String get sectionContactLinksDescription =>
      'Сайты, портфолио, email и соцсети.';

  @override
  String get sectionContactLinksHint => 'Одна ссылка на строку с подписью';

  @override
  String get sectionOpenToWorkTitle => 'Open to work';

  @override
  String get sectionOpenToWorkDescription =>
      'Предпочтения поиска работы и видимость для рекрутеров.';

  @override
  String get sectionOpenToWorkHint =>
      'Роли, локации, дата старта, remote/hybrid';

  @override
  String get sectionLanguagesTitle => 'Языки';

  @override
  String get sectionLanguagesDescription => 'Языки и уровень владения.';

  @override
  String get sectionLanguagesHint => 'English — Full professional proficiency';

  @override
  String get sectionHonorsTitle => 'Награды';

  @override
  String get sectionHonorsDescription => 'Премии и формальное признание.';

  @override
  String get sectionHonorsHint => 'Название — организация — год';

  @override
  String get sectionPublicationsTitle => 'Публикации';

  @override
  String get sectionPublicationsDescription => 'Статьи, доклады, книги.';

  @override
  String get sectionPublicationsHint => 'Название — издатель — дата — ссылка';

  @override
  String get sectionPatentsTitle => 'Патенты';

  @override
  String get sectionPatentsDescription => 'Патенты, где вы автор или соавтор.';

  @override
  String get sectionPatentsHint => 'Название — ведомство — номер — год';

  @override
  String get sectionCoursesTitle => 'Курсы';

  @override
  String get sectionCoursesDescription => 'Обучение помимо дипломов.';

  @override
  String get sectionCoursesHint => 'Курс — провайдер — год';

  @override
  String get sectionOrganizationsTitle => 'Организации';

  @override
  String get sectionOrganizationsDescription =>
      'Членство в профессиональных ассоциациях.';

  @override
  String get sectionOrganizationsHint => 'Организация — роль — годы';

  @override
  String get sectionServicesTitle => 'Услуги';

  @override
  String get sectionServicesDescription => 'Услуги, которые вы предлагаете.';

  @override
  String get sectionServicesHint => 'Услуга — описание';

  @override
  String get sectionCausesTitle => 'Ценности (Causes)';

  @override
  String get sectionCausesDescription =>
      'Поддерживаемые вами причины на профиле.';

  @override
  String get sectionCausesHint => 'Список или короткая заметка';

  @override
  String get sectionRecommendationsGivenTitle => 'Данные рекомендации';

  @override
  String get sectionRecommendationsGivenDescription =>
      'Рекомендации, которые вы написали другим.';

  @override
  String get sectionRecommendationsGivenHint => 'Имя — связь — выдержка';

  @override
  String get sectionActivityTitle => 'Активность';

  @override
  String get sectionActivityDescription =>
      'Недавние посты — ваш публичный голос.';

  @override
  String get sectionActivityHint => 'Заголовки или выдержки из постов';

  @override
  String get sectionCreatorNewsletterTitle => 'Creator и рассылка';

  @override
  String get sectionCreatorNewsletterDescription =>
      'Newsletter или creator mode.';

  @override
  String get sectionCreatorNewsletterHint => 'Название — тема — ссылка';

  @override
  String get publishNoteLocationIndustry =>
      'Локация и отрасль — на странице редактирования Intro.';

  @override
  String get publishNoteContactLinks =>
      'Сайты и контакты — в Intro или Contact info.';

  @override
  String get publishNoteOpenToWork => 'Настройки — Jobs → Open to work.';

  @override
  String get publishNoteLanguages =>
      'Каждый язык с уровнем — в разделе Languages.';

  @override
  String get publishNoteHonors =>
      'Награды добавляются по одной в Honors & awards.';

  @override
  String get publishNotePublications => 'Публикации — по одной со ссылками.';

  @override
  String get publishNotePatents => 'Патенты — в разделе Patents.';

  @override
  String get publishNoteCourses => 'Курсы — в разделе Courses.';

  @override
  String get publishNoteOrganizations => 'Организации добавляются отдельно.';

  @override
  String get publishNoteServices => 'Услуги — раздел Services.';

  @override
  String get publishNoteCauses => 'Causes — через Add profile section.';

  @override
  String get publishNoteRecommendationsGiven =>
      'Выданные рекомендации нельзя вставить списком.';

  @override
  String get publishNoteActivity =>
      'Активность — это лента; посты создаются на LinkedIn.';

  @override
  String get publishNoteCreatorNewsletter =>
      'Newsletter — в Creator mode / Pages.';

  @override
  String get importFromProfileUrl => 'Импорт по URL профиля';

  @override
  String get importLinkedInExport => 'Выгрузка LinkedIn';

  @override
  String get importLinkedInExportTooltip =>
      'ZIP или JSON из Настройки → Конфиденциальность → Получить копию данных';

  @override
  String get refreshLinkedIn => 'Обновить с LinkedIn';

  @override
  String get refreshLinkedInTooltip =>
      'Повторный импорт: папка → последний файл → URL';

  @override
  String get refreshLinkedInNothing =>
      'Новых данных нет. Укажите папку или файл в Настройках.';

  @override
  String get importUpToDate => 'Разделы уже актуальны.';

  @override
  String get importMergeCancelled => 'Импорт отменён.';

  @override
  String get importMergeTitle => 'Проверка изменений';

  @override
  String importMergeSubtitle(String source, int count) {
    return 'Источник: $source · изменено: $count';
  }

  @override
  String get importMergeSelectChanged => 'Только изменённые';

  @override
  String get importMergeSelectAll => 'Все';

  @override
  String get importMergeSelectNone => 'Снять';

  @override
  String get importMergePreview => 'Просмотр';

  @override
  String get importMergeApply => 'Применить';

  @override
  String get importMergeCurrent => 'Сейчас';

  @override
  String get importMergeIncoming => 'Новое';

  @override
  String get importMergeStatusNew => 'Новый раздел';

  @override
  String get importMergeStatusChanged => 'Изменён';

  @override
  String get importMergeStatusUnchanged => 'Без изменений';

  @override
  String get snapshotsTitle => 'История';

  @override
  String get snapshotsEmpty => 'Снимки создаются перед каждым импортом.';

  @override
  String get snapshotRestore => 'Восстановить';

  @override
  String get snapshotRestoreTitle => 'Восстановить снимок?';

  @override
  String get snapshotRestoreBody =>
      'Текущий профиль будет заменён. Сначала сохранится резервная копия.';

  @override
  String get snapshotRestoreConfirm => 'Восстановить';

  @override
  String get snapshotRestored => 'Снимок восстановлен.';

  @override
  String get atsMatchTitle => 'Совпадение с ATS';

  @override
  String atsMatchScore(int percent) {
    return 'Совпадение: $percent%';
  }

  @override
  String atsMatchMissing(String keywords) {
    return 'Добавьте: $keywords';
  }

  @override
  String importReminderBody(int days) {
    return 'Импорт был $days дн. назад. Обновите данные.';
  }

  @override
  String get importReminderSnooze => 'Напомнить через 7 дн.';

  @override
  String get syncSettingsTitle => 'Синхронизация LinkedIn';

  @override
  String get syncSettingsSubtitle =>
      'Папка наблюдения — авто-импорт нового ZIP/JSON.';

  @override
  String lastExportPath(String path) {
    return 'Последний файл: $path';
  }

  @override
  String get watchFolderNotSet => 'Папка наблюдения не задана';

  @override
  String watchFolderPath(String path) {
    return 'Папка: $path';
  }

  @override
  String get watchFolderPick => 'Выбрать папку';

  @override
  String get watchFolderSet => 'Папка сохранена.';

  @override
  String get experienceRolesTitle => 'Роли (разбор)';

  @override
  String get dashboardImports => 'Импортов';

  @override
  String get dashboardDynamicsTitle => 'Динамика роста';

  @override
  String get dashboardDynamicsSubtitle =>
      'Полнота профиля по снимкам и оценки после scoring.';

  @override
  String get dashboardCompletenessTrend => 'Полнота профиля';

  @override
  String get dashboardTrendHint => 'Заполненные разделы во времени';

  @override
  String get dashboardScoreTrend => 'Оценка профиля';

  @override
  String get dashboardScoreTrendHint => 'Балл оценщика после каждого запуска';

  @override
  String get dashboardLinkedInStatsTitle => 'Статистика LinkedIn';

  @override
  String get dashboardLinkedInStatsEmpty =>
      'Импортируйте ZIP-выгрузку LinkedIn с CSV аналитики (просмотры, поиск и т.д.).';

  @override
  String dashboardTargetRole(String role) {
    return 'Цель: $role';
  }

  @override
  String dashboardLastImport(String when) {
    return 'Импорт: $when';
  }

  @override
  String get dashboardMetricProfileViews => 'Просмотры профиля';

  @override
  String get dashboardMetricSearch => 'Появления в поиске';

  @override
  String get dashboardMetricPosts => 'Показы постов';

  @override
  String get dashboardMetricFollowers => 'Подписчики';

  @override
  String get dashboardMetricConnections => 'Контакты';

  @override
  String get importFromUrlFailed =>
      'Не удалось загрузить профиль по URL. LinkedIn часто блокирует авто-импорт — скопируйте разделы вручную или вставьте ниже.';

  @override
  String get importFromUrlHint =>
      'Используется сохранённый URL. Только публичные профили; данные могут быть неполными.';

  @override
  String get profileLanguageTitle => 'Язык приложения';

  @override
  String get profileLanguageSubtitle =>
      'Интерфейс, советы, ИИ-тексты и оценка — на одном языке.';

  @override
  String get snackLanguageChanged =>
      'Язык изменён. Запустите анализ заново для новых советов.';

  @override
  String get compareOnlyWithAi => 'Только разделы с ИИ';

  @override
  String compareAiSectionsCount(int count) {
    return '$count с ИИ-версией';
  }

  @override
  String get compareNoAiTitle => 'ИИ-версия ещё не создана';

  @override
  String get compareNoAiHint =>
      'Сначала нажмите «Сгенерировать ИИ», затем вернитесь к сравнению.';

  @override
  String get scoreTitle => 'Скоринг профиля';

  @override
  String get scoreSubtitle =>
      'Независимая оценка рекрутера: текущий профиль и ИИ-версия.';

  @override
  String get scoreEmptyTitle => 'Оценки пока нет';

  @override
  String get scoreEmptyHint =>
      'Импортируйте профиль и нажмите «Оценить профиль» в панели. Используется отдельный агент-оценщик, не тот же, что пишет текст.';

  @override
  String get scoreCurrentProfile => 'Текущий профиль';

  @override
  String get scoreAiProfile => 'ИИ-версия';

  @override
  String get scoreAiNotGenerated => 'Не создана';

  @override
  String scoreDeltaPositive(int delta) {
    return '+$delta к текущему';
  }

  @override
  String scoreDeltaNegative(int delta) {
    return '−$delta к текущему';
  }

  @override
  String get scoreDeltaNeutral => 'Как текущий';

  @override
  String get scoreSectionBreakdown => 'Оценки по разделам';

  @override
  String get scoreRecommendationsTitle => 'Рекомендации оценщика';

  @override
  String get scoreRecommendationsSubtitle =>
      'От независимого агента скоринга — не от генератора контента.';

  @override
  String get scoreCurrentShort => 'Текущий';

  @override
  String get scoreAiShort => 'ИИ';

  @override
  String scoreEvaluatorBadge(String provider) {
    return 'Оценщик · $provider';
  }

  @override
  String get statProfileScore => 'Оценка профиля';

  @override
  String get statAiScore => 'Оценка ИИ';

  @override
  String scoreEvalViaProvider(String provider) {
    return 'Оценено через $provider';
  }

  @override
  String get scoreEvalLocalFallback => 'LLM недоступен — эвристическая оценка';

  @override
  String scoreEvalLlmErrorFallback(String error) {
    return 'Ошибка оценщика ($error) — эвристика';
  }

  @override
  String get snackScoreDone => 'Профиль оценён';

  @override
  String get navCoach => 'Coach+';

  @override
  String get wowHubTitle => 'Инструменты Coach+';

  @override
  String get wowHubSubtitle =>
      'Симулятор рекрутёра, match вакансии, карьерный прогноз, A/B заголовки, бенчмарк.';

  @override
  String get wowRecruiterTitle => 'Симулятор рекрутёра';

  @override
  String get wowRecruiterSubtitle => 'Вопросы, вердикт, heat-map секций';

  @override
  String get wowRecruiterIntro =>
      'ИИ-рекрутёр оценивает профиль под вашу целевую роль и задаёт жёсткие вопросы.';

  @override
  String get wowRunSimulation => 'Запустить симуляцию';

  @override
  String get wowHeatmapTitle => 'Heat-map секций';

  @override
  String get wowHeatmapEmpty => 'Нет данных heat-map.';

  @override
  String get wowHeatStrong => 'Сильно';

  @override
  String get wowHeatNeutral => 'Нейтрально';

  @override
  String get wowHeatWeak => 'Слабо';

  @override
  String get wowQuestionsTitle => 'Вопросы на собеседовании';

  @override
  String get wowVerdictInterview => 'Пригласил бы';

  @override
  String get wowVerdictMaybe => 'Возможно';

  @override
  String get wowVerdictPass => 'Отказ';

  @override
  String get wowLocalFallbackHint => 'LLM выключен — эвристическая симуляция.';

  @override
  String get wowJobFitTitle => 'Match вакансии';

  @override
  String get wowJobFitSubtitle => 'Вставьте вакансию — % match, gaps, правки';

  @override
  String get wowJobFitIntro =>
      'Сравните профиль с конкретной вакансией. Сохраняется tailored snapshot.';

  @override
  String get wowJobFitPasteLabel => 'Текст вакансии';

  @override
  String get wowJobFitPasteHint => 'Вставьте полный текст вакансии…';

  @override
  String get wowJobFitAnalyze => 'Анализировать';

  @override
  String get wowJobFitMatch => 'Соответствие';

  @override
  String get wowJobFitMissing => 'Недостающие ключевые слова';

  @override
  String get wowJobFitGaps => 'Список пробелов';

  @override
  String get wowJobFitSaveSnapshot => 'Сохранить snapshot';

  @override
  String get wowJobFitApplyAi => 'Применить к ИИ-черновику';

  @override
  String get wowJobFitSnapshotSaved => 'Tailored snapshot сохранён.';

  @override
  String get wowJobFitAppliedAi => 'Правки применены к ИИ-секциям.';

  @override
  String get wowCareerTitle => 'Карьера what-if';

  @override
  String get wowCareerSubtitle => 'Таймлайн + прогноз 1/3/5 лет';

  @override
  String get wowCareerIntro => 'Таймлайн опыта и прогноз следующих шагов.';

  @override
  String get wowCareerSeniorSlider => 'Доп. senior-опыт';

  @override
  String get wowCareerYears => 'лет';

  @override
  String get wowCareerCourseLabel => 'Курс / сертификат (опционально)';

  @override
  String get wowCareerCourseHint => 'например AWS Solutions Architect';

  @override
  String get wowCareerForecast => 'Прогноз';

  @override
  String get wowCareerSkills => 'Навыки к добавлению';

  @override
  String get wowHeadlineAbTitle => 'A/B заголовка';

  @override
  String get wowHeadlineAbSubtitle => '5 вариантов с рейтингом';

  @override
  String get wowHeadlineAbIntro =>
      'Сгенерируйте варианты headline и выберите лучший.';

  @override
  String get wowHeadlineGenerate => 'Сгенерировать';

  @override
  String get wowHeadlineAbLegend =>
      'Оценки: ATS, читаемость, hook, уникальность.';

  @override
  String get wowHeadlineBest => 'Лучший';

  @override
  String get wowHeadlineReadability => 'Читаемость';

  @override
  String get wowHeadlineHook => 'Hook';

  @override
  String get wowHeadlineUnique => 'Уникальность';

  @override
  String get wowHeadlineUse => 'Выбрать';

  @override
  String get wowHeadlineApplied => 'Заголовок применён к ИИ.';

  @override
  String get wowBenchmarkTitle => 'Вы vs медиана';

  @override
  String get wowBenchmarkSubtitle => 'Радар-бенчмарк по роли';

  @override
  String get wowBenchmarkIntro =>
      'Сравнение метрик профиля с медианой по роли.';

  @override
  String get wowBenchmarkRun => 'Сравнить';

  @override
  String get wowBenchmarkYou => 'Вы';

  @override
  String get wowBenchmarkMedian => 'Медиана';

  @override
  String get profilesSwitcherLabel => 'Профиль';

  @override
  String get profilesSectionTitle => 'Управление профилями';

  @override
  String get profilesSectionSubtitle =>
      'Переключайтесь между кандидатами — у каждого свои данные LinkedIn, ИИ-черновики и оценки.';

  @override
  String get profilesAddTitle => 'Новый профиль';

  @override
  String get profilesAddAction => 'Добавить профиль';

  @override
  String get profilesAddConfirm => 'Создать';

  @override
  String get profilesRenameTitle => 'Переименовать';

  @override
  String get profilesRenameAction => 'Переименовать';

  @override
  String get profilesDeleteTitle => 'Удалить профиль?';

  @override
  String profilesDeleteBody(String name) {
    return 'Удалить «$name» и все данные? Это нельзя отменить.';
  }

  @override
  String get profilesDeleteAction => 'Удалить';

  @override
  String get profilesDeleteConfirm => 'Удалить';

  @override
  String get profilesCannotDeleteLast => 'Нужен хотя бы один профиль.';

  @override
  String get profilesNameHint => 'например Иван Петров — Senior PM';

  @override
  String get profilesActive => 'Активный';

  @override
  String profilesCount(int count) {
    return '$count профилей';
  }

  @override
  String snackProfileSwitched(String name) {
    return 'Переключено на $name';
  }

  @override
  String get navMarketplace => 'Маркетплейс';

  @override
  String get marketplaceCatalogTitle => 'Маркетплейс карьеры';

  @override
  String get marketplaceTopUp => 'Пополнить через браузер';

  @override
  String get marketplaceCategoryCareer => 'Карьерные возможности';

  @override
  String get marketplacePrivacyNotice =>
      'Ваш профиль остаётся на этом устройстве. Возможности доставляются к вам, а не наоборот.';

  @override
  String get aiProviderAimarket => 'AI Market';

  @override
  String get aiProviderAimarketHint =>
      'Маркетплейс с оплатой за вызов. На основе кошелька, без API-ключа.';

  @override
  String get aiProviderAimarketSetupHint =>
      'AI Market: hub.aicom.io — децентрализованный маркетплейс. Сначала пополните баланс.';
}
