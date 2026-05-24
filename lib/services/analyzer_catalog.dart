import '../models/profile_language.dart';

/// Localized strings for [ProfileAnalyzer] (rules-based tips).
class AnalyzerCatalog {
  const AnalyzerCatalog(this.language);

  final ProfileLanguage language;

  String _t(String en, String ru, String es) => switch (language) {
        ProfileLanguage.en => en,
        ProfileLanguage.ru => ru,
        ProfileLanguage.es => es,
      };

  (String title, String body) headlineEmpty() => (
        _t(
          'Fill in your headline',
          'Заполните заголовок',
          'Completa el titular',
        ),
        _t(
          'Headline is the top search element. Add role, specialty, and 1–2 differentiators (stack, industry, format).',
          'Заголовок — главный элемент для поиска. Укажите роль, специализацию и 1–2 отличия (стек, отрасль, формат работы).',
          'El titular es clave en búsquedas. Indica rol, especialidad y 1–2 diferenciadores.',
        ),
      );

  (String title, String body) headlineTooShort(int len) => (
        _t('Expand your headline', 'Расширьте заголовок', 'Amplía el titular'),
        _t(
          'Currently $len characters. Aim for 80–120: role + value + recruiter keywords.',
          'Сейчас $len символов. Оптимально 80–120: роль + ценность + ключевые слова для рекрутеров.',
          'Ahora $len caracteres. Objetivo 80–120: rol + valor + palabras clave.',
        ),
      );

  (String title, String body) headlineTooLong() => (
        _t('Shorten your headline', 'Сократите заголовок', 'Acorta el titular'),
        _t(
          'Long headlines get cut off on mobile. Keep essentials in the first 120 characters.',
          'Длинные заголовки обрезаются в мобильной ленте. Оставьте самое важное в первых 120 символах.',
          'Los titulares largos se cortan en móvil. Lo esencial en los primeros 120 caracteres.',
        ),
      );

  (String title, String body) headlineMissingRole(String role) => (
        _t('Add target role to headline', 'Добавьте целевую роль в заголовок', 'Añade el rol objetivo al titular'),
        _t(
          'Target role is «$role» in settings but missing from headline — recruiters may not find you.',
          'В настройках указана цель «$role», но её нет в заголовке — рекрутеры могут не увидеть вас в поиске.',
          'El rol objetivo es «$role» pero falta en el titular.',
        ),
      );

  (String title, String body) headlineStructure() => (
        _t('Structure your headline', 'Структурируйте заголовок', 'Estructura el titular'),
        _t(
          'Use separators «|» or «•»: Role | Specialty | Industry/format.',
          'Используйте разделители «|» или «•»: Роль | Специализация | Формат/отрасль.',
          'Usa separadores «|» o «•»: Rol | Especialidad | Industria.',
        ),
      );

  (String title, String body) aboutEmpty() => (
        _t('Fill in About', 'Заполните блок «О себе»', 'Completa Acerca de'),
        _t(
          'About builds trust. Write: who you are → value → proof → CTA.',
          'About повышает доверие. Напишите: кто вы → чем полезны → доказательства → CTA.',
          'Acerca de genera confianza: quién eres → valor → pruebas → CTA.',
        ),
      );

  (String title, String body) aboutTooShort(int len) => (
        _t('Expand About', 'Расширьте описание', 'Amplía Acerca de'),
        _t(
          'About ~$len characters. Strong profiles often use 1,500–2,500 with specifics and metrics.',
          'Сейчас ~$len символов. Сильные профили обычно 1 500–2 500 символов с конкретикой и цифрами.',
          '~$len caracteres. Perfiles fuertes suelen tener 1.500–2.500 con métricas.',
        ),
      );

  (String title, String body) aboutMetrics() => (
        _t('Add metrics to About', 'Добавьте цифры и результаты', 'Añade métricas en Acerca de'),
        _t(
          'Include 2–3 measurable wins: %, timelines, scale, team, budget, users.',
          'Включите 2–3 измеримых достижения: %, сроки, объёмы, команда, бюджет, пользователи.',
          'Incluye 2–3 logros medibles: %, plazos, escala, equipo, presupuesto.',
        ),
      );

  (String title, String body) aboutCta() => (
        _t('Add a call to action', 'Добавьте призыв к действию', 'Añade una llamada a la acción'),
        _t(
          'End with how to reach you and topics you are open to (hiring, consulting, mentoring).',
          'В конце укажите, как связаться и по каким темам вы открыты (найм, консалтинг, менторство).',
          'Cierra con cómo contactarte y temas abiertos (empleo, consultoría).',
        ),
      );

  (String title, String body) experienceEmpty() => (
        _t('Fill in Experience', 'Заполните опыт работы', 'Completa Experiencia'),
        _t(
          'Add at least 2 recent roles with bullets: context → action → outcome.',
          'Минимум 2 последние роли с буллетами: задача → действие → результат.',
          'Añade al menos 2 roles recientes: contexto → acción → resultado.',
        ),
      );

  (String title, String body) experienceMetrics() => (
        _t('Add metrics to Experience', 'Добавьте метрики в опыт', 'Añade métricas en Experiencia'),
        _t(
          'Per role add 1–2 bullets with numbers: growth, savings, speed, scale.',
          'К каждой роли добавьте 1–2 пункта с цифрами: рост, экономия, скорость, масштаб.',
          'Por rol, 1–2 viñetas con cifras: crecimiento, ahorro, velocidad.',
        ),
      );

  (String title, String body) experienceActionVerbs() => (
        _t('Use action verbs', 'Используйте глаголы действия', 'Usa verbos de acción'),
        _t(
          'Start bullets with: built, led, optimized, implemented, automated.',
          'Начинайте пункты с: разработал, внедрил, оптимизировал, руководил, автоматизировал.',
          'Empieza con: desarrollé, implementé, optimicé, lideré, automaticé.',
        ),
      );

  (String title, String body) educationEmpty() => (
        _t('Add education', 'Добавьте образование', 'Añade formación'),
        _t(
          'List school, degree, years. Can be brief if experience is strong.',
          'Укажите ВУЗ, степень и годы. Если опыт силён — блок может быть короче.',
          'Indica centro, título y años. Puede ser breve si la experiencia es fuerte.',
        ),
      );

  (String title, String body) skillsEmpty() => (
        _t('Fill in skills', 'Заполните навыки', 'Completa habilidades'),
        _t(
          'Add 15–30 skills: technical, soft skills, tools. Ask colleagues to endorse top 3.',
          'Добавьте 15–30 навыков. Попросите коллег подтвердить топ-3.',
          'Añade 15–30 habilidades. Pide endorsos en las 3 principales.',
        ),
      );

  (String title, String body) skillsTooFew(int count) => (
        _t('Expand skills list', 'Расширьте список навыков', 'Amplía habilidades'),
        _t(
          '~$count skills now. Add tools, frameworks, domains from resume and job posts.',
          'Сейчас ~$count навыков. Добавьте инструменты и домены из резюме и вакансий.',
          '~$count habilidades. Añade herramientas y dominios del CV.',
        ),
      );

  (String title, String body) skillsMissingRole(String missing) => (
        _t('Add skills for target role', 'Добавьте навыки под целевую роль', 'Habilidades para el rol objetivo'),
        _t(
          'Consider adding: $missing (from your target role).',
          'Рассмотрите добавление: $missing (из формулировки целевой роли).',
          'Considera añadir: $missing (del rol objetivo).',
        ),
      );

  (String title, String body) certificationsEmpty() => (
        _t('Add certifications (if any)', 'Добавьте сертификаты (если есть)', 'Añade certificaciones (si aplica)'),
        _t(
          'Coursera, AWS, Google, languages — optional but builds trust.',
          'Курсы Coursera, AWS, Google — повышают доверие. Если нет — можно пропустить.',
          'Coursera, AWS, Google — opcional pero da credibilidad.',
        ),
      );

  (String title, String body) projectsEmpty() => (
        _t('Add 1–2 projects', 'Добавьте 1–2 проекта', 'Añade 1–2 proyectos'),
        _t(
          'Pet projects, open source, or case studies with links — especially for career pivots.',
          'Pet-проекты, open source или кейсы с ссылкой — особенно при смене роли.',
          'Proyectos personales u open source con enlaces.',
        ),
      );

  (String title, String body) featuredEmpty() => (
        _t('Fill Featured', 'Заполните «Избранное»', 'Completa Destacado'),
        _t(
          'Pin your best post, article, or portfolio link.',
          'Закрепите лучший пост, статью или портфолио.',
          'Fija tu mejor publicación, artículo o portafolio.',
        ),
      );

  (String title, String body) recommendationsEmpty() => (
        _t('Request recommendations', 'Запросите рекомендации', 'Pide recomendaciones'),
        _t(
          'Ask 2–3 colleagues for specific stories (leadership, technical wins, outcomes).',
          'Попросите 2–3 коллег описать конкретные кейсы.',
          'Pide a 2–3 colegas historias concretas.',
        ),
      );

  (String title, String body) sectionEmpty(String sectionTitle) => (
        _t('Fill $sectionTitle', 'Заполните «$sectionTitle»', 'Completa $sectionTitle'),
        _t(
          'Import from LinkedIn data export or paste this section — it strengthens your profile.',
          'Импортируйте из выгрузки LinkedIn или вставьте вручную — раздел усиливает профиль.',
          'Importa desde la exportación de LinkedIn o pega esta sección.',
        ),
      );

  (String title, String body) completenessLow(int pct) => (
        _t('Profile completeness: $pct%', 'Полнота профиля: $pct%', 'Completitud del perfil: $pct%'),
        _t(
          'Fill headline, About, experience, and skills. Complete profiles get far more views.',
          'Заполните заголовок, about, опыт, навыки. Полные профили получают больше просмотров.',
          'Completa titular, Acerca de, experiencia y habilidades.',
        ),
      );

  (String title, String body) completenessOk(String industry) => (
        _t('Profile completeness: OK', 'Полнота профиля: хорошо', 'Completitud: bien'),
        _t(
          'Solid base. Post 1–2 times per week on ${industry.isNotEmpty ? industry : 'your topic'}.',
          'Хорошая база. Сфокусируйтесь на активности: 1–2 поста в неделю по ${industry.isNotEmpty ? industry : 'вашей теме'}.',
          'Buena base. Publica 1–2 veces por semana sobre ${industry.isNotEmpty ? industry : 'tu tema'}.',
        ),
      );

  (String title, String body) recruiterSearch(String role) => (
        _t('Optimize for recruiter search', 'Оптимизация под поиск рекрутеров', 'Optimiza para reclutadores'),
        role.isNotEmpty
            ? _t(
                'Include «$role» in headline, About, and skills. Use Open to Work filters.',
                'Включите «$role» в заголовок, about и навыки. Включите режим Open to Work.',
                'Incluye «$role» en titular, Acerca de y habilidades.',
              )
            : _t(
                'Set a target role in Settings — tips will be more accurate.',
                'Укажите целевую роль в настройках — рекомендации станут точнее.',
                'Indica un rol objetivo en Ajustes.',
              ),
      );

  (String title, String body) networking() => (
        _t('Network and engage', 'Сеть и вовлечённость', 'Red y engagement'),
        _t(
          'Add 5–10 relevant contacts weekly; comment on leaders\' posts; share short insights.',
          'Добавляйте 5–10 контактов в неделю, комментируйте посты лидеров, публикуйте инсайты.',
          'Añade contactos relevantes y comparte ideas breves.',
        ),
      );

  (String title, String body) resumeSkillsMissing(String skills) => (
        _t('Resume skills missing on profile', 'Навыки из резюме не в профиле', 'Habilidades del CV faltan'),
        _t(
          'Add to LinkedIn: $skills. Improves ATS and recruiter match.',
          'Добавьте в LinkedIn: $skills.',
          'Añade en LinkedIn: $skills.',
        ),
      );

  (String title, String body) experienceShorterThanResume() => (
        _t('Experience shorter than resume', 'Опыт короче резюме', 'Experiencia más corta que el CV'),
        _t(
          'Move key roles and wins from your resume into Experience — adapt for LinkedIn format.',
          'Перенесите ключевые роли из резюме в Experience — адаптируйте под LinkedIn.',
          'Traslada roles clave del CV a Experiencia.',
        ),
      );

  (String title, String body) roleResumeMismatch(String role) => (
        _t('Target role vs resume mismatch', 'Целевая роль не совпадает с резюме', 'Rol objetivo vs CV'),
        _t(
          'Settings say «$role» but resume mentions it rarely. Align both under one position.',
          'В настройках «$role», но в резюме мало. Согласуйте профиль и CV.',
          'Rol «$role» en ajustes pero poco en el CV.',
        ),
      );
}
