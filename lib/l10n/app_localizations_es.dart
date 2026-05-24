// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Profile Coach';

  @override
  String get appTagline => 'Inteligencia premium para tu perfil de LinkedIn';

  @override
  String get navOverview => 'Resumen';

  @override
  String get navLinkedIn => 'LinkedIn';

  @override
  String get navAiProfile => 'Perfil IA';

  @override
  String get navCompare => 'Comparar';

  @override
  String get navScoring => 'Puntuación';

  @override
  String get navTips => 'Consejos';

  @override
  String get navAdmin => 'Ajustes';

  @override
  String get btnNext => 'Continuar';

  @override
  String get btnBack => 'Atrás';

  @override
  String get btnSkip => 'Omitir';

  @override
  String get btnFinish => 'Finalizar';

  @override
  String get btnGetStarted => 'Empezar';

  @override
  String get btnAnalyze => 'Analizar';

  @override
  String get btnScore => 'Puntuar perfil';

  @override
  String get btnGenerateAi => 'Generar IA';

  @override
  String get btnOpenWizard => 'Análisis guiado';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnTest => 'Probar';

  @override
  String get langEnglish => 'English';

  @override
  String get langRussian => 'Русский';

  @override
  String get langSpanish => 'Español';

  @override
  String get setupWelcomeTitle => 'Bienvenido a Profile Coach';

  @override
  String get setupWelcomeSubtitle =>
      'Un espacio premium para importar, refinar y publicar tu presencia en LinkedIn.';

  @override
  String get setupLanguageTitle => 'Elige tu idioma';

  @override
  String get setupLanguageSubtitle =>
      'Puedes cambiarlo en Ajustes en cualquier momento.';

  @override
  String get setupProfileTitle => 'Tu identidad';

  @override
  String get setupProfileSubtitle =>
      'Cómo apareces en vistas previas y borradores de IA.';

  @override
  String get setupNameLabel => 'Nombre';

  @override
  String get setupNameHint => 'María García';

  @override
  String get setupUrlLabel => 'URL del perfil de LinkedIn';

  @override
  String get setupUrlHint => 'https://www.linkedin.com/in/usuario/';

  @override
  String get setupGoalTitle => 'Enfoque profesional';

  @override
  String get setupGoalSubtitle =>
      'Alineamos titular, habilidades y textos de IA con este objetivo.';

  @override
  String get setupRoleLabel => 'Rol objetivo';

  @override
  String get setupRoleHint => 'Senior Product Manager';

  @override
  String get setupIndustryLabel => 'Industria';

  @override
  String get setupIndustryHint => 'FinTech, SaaS, HealthTech…';

  @override
  String get setupTemplateTitle => 'Plantillas premium';

  @override
  String get setupTemplateSubtitle =>
      'Marcos de posicionamiento curados. Elige uno para sembrar tu borrador de IA.';

  @override
  String get templateExecutive => 'Presencia ejecutiva';

  @override
  String get templateExecutiveDesc =>
      'Autoridad, escala, impacto a nivel directivo.';

  @override
  String get templateTechLeader => 'Líder técnico';

  @override
  String get templateTechLeaderDesc =>
      'Liderazgo de ingeniería, entrega, arquitectura.';

  @override
  String get templateCreator => 'Creador y marca';

  @override
  String get templateCreatorDesc => 'Audiencia, contenido, marca personal.';

  @override
  String get templateCareerShift => 'Cambio de carrera';

  @override
  String get templateCareerShiftDesc =>
      'Habilidades transferibles, narrativa puente.';

  @override
  String get setupAiTitle => 'Proveedor de IA';

  @override
  String get setupAiSubtitle =>
      'DeepSeek por defecto. Añade tu API key u omite para plantillas locales.';

  @override
  String get setupResumeTitle => 'Currículum (opcional)';

  @override
  String get setupResumeSubtitle =>
      'Sube un .docx (Word 2007+). El formato .doc antiguo no es compatible.';

  @override
  String get resumeDragDropHint => 'Arrastra un .docx aquí o usa Examinar.';

  @override
  String get resumeErrorLegacyDoc =>
      'El .doc antiguo no es compatible. En Word: Guardar como → .docx.';

  @override
  String resumeErrorUnsupportedExt(String ext) {
    return 'Tipo de archivo no compatible \"$ext\". Solo .docx.';
  }

  @override
  String get resumeErrorEmptyDocx => 'El .docx no contiene texto legible.';

  @override
  String get resumeErrorInvalidDocx =>
      'No se pudo leer el archivo como .docx. Comprueba el documento.';

  @override
  String get setupImportTitle => 'Importar LinkedIn';

  @override
  String get setupImportSubtitle =>
      'Copia secciones con encabezados HEADLINE, ABOUT, EXPERIENCE — o más tarde.';

  @override
  String get setupReadyTitle => 'Todo listo';

  @override
  String get setupReadySubtitle =>
      'Te guiaremos en un análisis enfocado — paso a paso.';

  @override
  String get analysisTitle => 'Análisis guiado';

  @override
  String get analysisStepImport => 'Importar perfil';

  @override
  String get analysisStepImportDesc =>
      'Pega secciones de LinkedIn o carga JSON.';

  @override
  String get analysisStepAi => 'Perfil con IA';

  @override
  String get analysisStepAiDesc =>
      'Versión pulida alineada con tu objetivo y plantilla.';

  @override
  String get analysisStepReview => 'Revisar y comparar';

  @override
  String get analysisStepReviewDesc =>
      'Diff lado a lado y puntuación por sección.';

  @override
  String get analysisStepInsights => 'Insights';

  @override
  String get analysisStepInsightsDesc =>
      'Recomendaciones priorizadas de contenido y promoción.';

  @override
  String get analysisStepPublish => 'Plan de publicación';

  @override
  String get analysisStepPublishDesc =>
      'Copiar, abrir formularios de LinkedIn, marcar hecho.';

  @override
  String get analysisCompleteTitle => 'Análisis completo';

  @override
  String get analysisCompleteSubtitle =>
      'Tu espacio está listo. Sigue iterando desde el panel principal.';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String stepOf(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get snackAnalysisDone => 'Análisis completado';

  @override
  String get snackAiDone => 'Perfil IA generado';

  @override
  String get snackSaved => 'Guardado';

  @override
  String get snackImportDone => 'Importación exitosa';

  @override
  String get dashboardTitle => 'Resumen';

  @override
  String get dashboardSubtitle =>
      'Completitud, insights urgentes y acciones rápidas.';

  @override
  String get statSections => 'Secciones completadas';

  @override
  String get statUrgent => 'Insights urgentes';

  @override
  String get statTotalTips => 'Total de consejos';

  @override
  String get importLinkedIn => 'Importar del portapapeles';

  @override
  String get importJson => 'Archivo JSON';

  @override
  String get compareTitle => 'Comparar';

  @override
  String get updateLinkedIn => 'Actualizar en LinkedIn';

  @override
  String get linkedInApiNote =>
      'LinkedIn no ofrece API pública de escritura para perfiles personales. Copia el texto y pégalo en el navegador.';

  @override
  String get adminTitle => 'Ajustes';

  @override
  String get adminAiSection => 'IA — API';

  @override
  String get adminProfileSection => 'Perfil y objetivo';

  @override
  String get adminResumeSection => 'Currículum (.docx)';

  @override
  String get restartSetup => 'Ejecutar asistente de configuración';

  @override
  String get restartAnalysis => 'Ejecutar análisis guiado';

  @override
  String get themeSectionTitle => 'Apariencia';

  @override
  String get themeSectionSubtitle =>
      'Paletas oscuras, claras y rosadas — cámbialas cuando quieras.';

  @override
  String get themeGroupDark => 'Oscuro';

  @override
  String get themeGroupLight => 'Claro';

  @override
  String get themeGroupPink => 'Rosa y blush';

  @override
  String get themeGroupPremium => 'Premium';

  @override
  String get themeDarkGold => 'Oro medianoche';

  @override
  String get themeDarkOcean => 'Océano profundo';

  @override
  String get themeDarkPlum => 'Ciruela real';

  @override
  String get themeLightIvory => 'Marfil pro';

  @override
  String get themeLightCloud => 'Azul nube';

  @override
  String get themeLightSage => 'Salvia suave';

  @override
  String get themeLightPearl => 'Perla gris';

  @override
  String get themeLightSand => 'Arena cálida';

  @override
  String get themeLightMint => 'Menta fresca';

  @override
  String get themeLightAmber => 'Ámbar dorado';

  @override
  String get themePinkRose => 'Cuarzo rosa';

  @override
  String get themePinkBlush => 'Pétalo blush';

  @override
  String get themePinkLilac => 'Sueño lila';

  @override
  String get themeDarkObsidian => 'Obsidiana platino';

  @override
  String get themeDarkChampagne => 'Champagne noir';

  @override
  String get themeDarkEmerald => 'Esmeralda lujo';

  @override
  String get themeLightPlatinum => 'Seda platino';

  @override
  String get themeLightChampagne => 'Seda champagne';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnImport => 'Importar';

  @override
  String get btnUploadResume => 'Subir .docx';

  @override
  String get btnReplaceResume => 'Reemplazar currículum';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get importParseFailed =>
      'No se reconocieron secciones. Use encabezados: HEADLINE, ABOUT, EXPERIENCE…';

  @override
  String importSectionsImported(int count) {
    return 'Importadas $count secciones';
  }

  @override
  String get previewNotGenerated => '— Aún no generado —';

  @override
  String get previewNotImported => '— No importado —';

  @override
  String get previewYourName => 'Su nombre';

  @override
  String previewImportMeta(int count, String date) {
    return '$count secc. • $date';
  }

  @override
  String get previewSyncedTooltip => 'Marcado como aplicado en LinkedIn';

  @override
  String get previewChangedLabel => 'cambiado';

  @override
  String get dashboardHowTo => 'Cómo usar';

  @override
  String get dashboardStep1 => 'Abra LinkedIn y copie cada sección del perfil';

  @override
  String get dashboardStep2 =>
      'Pegue en la pestaña LinkedIn o importe desde el portapapeles';

  @override
  String get dashboardStep3 => 'Suba un .docx en Ajustes (opcional)';

  @override
  String get dashboardStep4 => 'Ejecute el análisis para consejos por sección';

  @override
  String adminResumeLoaded(String date) {
    return 'Subido: $date';
  }

  @override
  String get adminResumePreviewLabel => 'Vista previa del texto:';

  @override
  String get adminPrivacyNote =>
      'La app no se conecta a LinkedIn directamente (límites de la plataforma). Copie las secciones manualmente.';

  @override
  String adminResumeUploaded(String filename) {
    return 'Currículum subido: $filename';
  }

  @override
  String get importDialogTitle => 'Importar desde LinkedIn';

  @override
  String get importDialogBody =>
      'Copie las secciones del perfil y péguelas abajo. Use encabezados:';

  @override
  String get importDialogPlaceholder => 'Pegue el texto del perfil…';

  @override
  String get importFormatExample =>
      'HEADLINE:\n...\n\nABOUT:\n...\n\nEXPERIENCE:\n...';

  @override
  String get setupImportPasteHint =>
      'Pegue con HEADLINE, ABOUT, EXPERIENCE — o omita e importe después.';

  @override
  String get aiConnectionOkTitle => 'Conexión OK';

  @override
  String aiConnectionReply(String reply) {
    return 'Respuesta: $reply';
  }

  @override
  String get btnClose => 'Cerrar';

  @override
  String get aiProfileTitle => 'Perfil IA';

  @override
  String aiProfileSectionsCount(int count) {
    return '$count secciones';
  }

  @override
  String aiProfileDiffCount(int count) {
    return '$count diferencias';
  }

  @override
  String get aiProfileSubtitle =>
      'Vía LLM (DeepSeek, etc.) o plantillas locales si falla la API';

  @override
  String get aiProfileEmptyTitle => 'Versión IA aún no creada';

  @override
  String get aiProfileEmptyHint => 'Pulse Generar IA en la barra superior';

  @override
  String get aiSectionEditLabel => 'Texto versión IA';

  @override
  String get aiSettingsSubtitle =>
      'DeepSeek por defecto. Si falla la API — plantillas locales.';

  @override
  String get aiGenOptionsTitle => 'Opciones de generación IA';

  @override
  String get aiGenOptionsSubtitle =>
      'Ajusta cómo se escribe el perfil. La creatividad controla la temperatura del modelo.';

  @override
  String get aiGenFocusLabel => 'Objetivo del perfil';

  @override
  String get aiGenFocusJobSearch => 'Búsqueda de empleo';

  @override
  String get aiGenFocusJobSearchDesc => 'Reclutadores, ATS, encaje con el rol';

  @override
  String get aiGenFocusNetworking => 'Networking';

  @override
  String get aiGenFocusNetworkingDesc => 'Conexiones, intros, colaboración';

  @override
  String get aiGenFocusThoughtLeadership => 'Liderazgo de opinión';

  @override
  String get aiGenFocusThoughtLeadershipDesc => 'Autoridad, ideas, audiencia';

  @override
  String get aiGenFocusFreelance => 'Freelance y clientes';

  @override
  String get aiGenFocusFreelanceDesc => 'Servicios, resultados, confianza';

  @override
  String get aiGenVariantCountLabel => 'Variantes de borrador';

  @override
  String get aiGenVariantOne => '1';

  @override
  String get aiGenVariantTwo => '2';

  @override
  String get aiGenVariantThree => '3';

  @override
  String get aiCreativityLabel => 'Creatividad';

  @override
  String get aiCreativityHint =>
      'Bajo = factual y estable. Alto = más variedad (temperatura LLM).';

  @override
  String get aiGenSkipDialogLabel =>
      'No volver a preguntar — usar estos valores';

  @override
  String get aiGenPrefsSection => 'Valores por defecto de generación';

  @override
  String get aiGenPrefsSectionSubtitle =>
      'Se usan al pulsar Generar IA (salvo que cambies en el diálogo).';

  @override
  String get aiVariantPickerLabel => 'Variante';

  @override
  String get aiProviderLabel => 'Proveedor';

  @override
  String get aiApiKeyLabel => 'Clave API';

  @override
  String get aiApiKeyStored => 'Clave del proveedor';

  @override
  String get aiModelLabel => 'Modelo';

  @override
  String get aiResetDefaults => 'Restablecer URL/modelo';

  @override
  String get aiProviderOpenAiHint =>
      'OpenAI: platform.openai.com — /v1/chat/completions';

  @override
  String get aiProviderCompatibleHint =>
      'Cualquier endpoint compatible con OpenAI';

  @override
  String get aiProviderAnthropicHint =>
      'Anthropic: console.anthropic.com — API separada';

  @override
  String get aiProviderLmRouterHint =>
      'LM Router: URL base de la documentación';

  @override
  String get aiProviderOllamaHint => 'Ollama: localhost:11434 — sin clave API';

  @override
  String get analysisImportNow => 'Importar del portapapeles';

  @override
  String get linkedinSourceTitle => 'LinkedIn — perfil importado';

  @override
  String linkedinSectionsMeta(int filled, int total) {
    return '$filled / $total secciones importadas';
  }

  @override
  String get linkedinSectionEditLabel => 'Texto de sección LinkedIn';

  @override
  String get aiLlmToggle => 'LLM';

  @override
  String get aiBaseUrlLabel => 'URL base';

  @override
  String get aiProviderOpenAiCompatible => 'Compatible con OpenAI';

  @override
  String get aiProviderOllama => 'Ollama (local)';

  @override
  String get aiProviderCompatibleEndpointHint =>
      'Cualquier endpoint con /chat/completions';

  @override
  String get aiProviderLmRouterEndpointHint =>
      'Indique su URL base si es distinta';

  @override
  String get aiProviderOllamaServeHint => 'Ejecute: ollama serve';

  @override
  String get aiProviderDeepseekSetupHint =>
      'DeepSeek: platform.deepseek.com → API Keys. Endpoint: api.deepseek.com';

  @override
  String get aiGenLocalFallback =>
      'LLM desactivado o sin clave API — plantillas locales';

  @override
  String aiGenViaProvider(String provider) {
    return 'Generado vía $provider';
  }

  @override
  String aiGenLlmErrorFallback(String error) {
    return 'Error LLM ($error) — plantillas locales usadas';
  }

  @override
  String get compareEmptyLinkedIn => '— vacío —';

  @override
  String get compareEmptyAi => '— no generado —';

  @override
  String compareSectionsWithDiff(int count) {
    return '$count secciones con diferencias';
  }

  @override
  String get compareSideBySide => 'Lado a lado';

  @override
  String get compareDiffMode => 'Diff';

  @override
  String get compareSectionLabel => 'Sección';

  @override
  String get compareLinkedInColumn => 'LinkedIn (importado)';

  @override
  String get compareAiColumn => 'Versión IA';

  @override
  String get diffRemoved => 'Eliminado';

  @override
  String get diffAdded => 'Añadido';

  @override
  String diffSimilarity(String percent) {
    return 'Similitud: $percent%';
  }

  @override
  String get publishSheetTitle => 'Actualizar perfil en LinkedIn';

  @override
  String publishChangedCount(int count) {
    return 'Secciones cambiadas: $count';
  }

  @override
  String get publishHasChanges => 'con cambios';

  @override
  String get publishCopyAi => 'Copiar texto IA';

  @override
  String get publishOpenLinkedIn => 'Abrir en LinkedIn';

  @override
  String get publishMarkDone => 'Marcar listo';

  @override
  String publishCopiedSection(String title) {
    return 'Copiado: $title';
  }

  @override
  String get publishBrowserFailed => 'No se pudo abrir el navegador';

  @override
  String get publishCapabilityCopy => 'Solo copiar + pegar manualmente';

  @override
  String get publishCapabilityBrowser => 'Copiar → abrir formulario → pegar';

  @override
  String get publishCapabilityManual =>
      'Solo manualmente en la interfaz de LinkedIn';

  @override
  String get publishNoteHeadline =>
      'Pegue el titular en el campo Headline en Intro.';

  @override
  String get publishNoteAbout =>
      'El texto About está en la misma sección Intro, campo Summary.';

  @override
  String get publishNoteExperience => 'Añada o edite cada puesto por separado.';

  @override
  String get publishNoteEducation => 'Indique centros educativos y años.';

  @override
  String get publishNoteSkills =>
      'Añada habilidades manualmente; los endorsements son aparte.';

  @override
  String get publishNoteCertifications =>
      'Las certificaciones se añaden una a una.';

  @override
  String get publishNoteProjects =>
      'Proyectos y enlaces en la sección Projects.';

  @override
  String get publishNoteFeatured =>
      'Featured: fije un post o enlace vía Add profile section.';

  @override
  String get publishNoteVolunteer =>
      'Experiencia de voluntariado usa un formulario aparte.';

  @override
  String get publishNoteRecommendations =>
      'Las recomendaciones se solicitan a otros — no puede pegar texto usted mismo.';

  @override
  String get publishNoteGeneral =>
      'Abra su perfil y pegue el texto en la sección correcta.';

  @override
  String get sectionEditDefaultLabel => 'Texto de la sección';

  @override
  String get sectionEditPaste => 'Pegar';

  @override
  String get sectionEditHintPrefix => 'Consejo:';

  @override
  String sectionCharCount(int count) {
    return '$count caracteres';
  }

  @override
  String get recommendationsEmpty => 'Aún no hay recomendaciones';

  @override
  String get recommendationsEmptyHint =>
      'Pulse Analizar en la barra — consejos por sección (reglas).';

  @override
  String get recommendationsEmptyScoringHint =>
      'Los consejos de Puntuar perfil están en la pestaña Puntuación, no aquí.';

  @override
  String get filterAllSections => 'Todas las secciones';

  @override
  String get filterGeneralPromotion => 'General / promoción';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get priorityMedium => 'Media';

  @override
  String get priorityLow => 'Baja';

  @override
  String get categoryFill => 'Completar';

  @override
  String get categoryPromote => 'Promoción';

  @override
  String get categoryAlign => 'Alineación';

  @override
  String get sectionHeadlineTitle => 'Titular';

  @override
  String get sectionHeadlineDescription =>
      'La primera línea bajo su nombre — visible para reclutadores.';

  @override
  String get sectionHeadlineHint =>
      'p. ej. Senior Flutter Developer | FinTech | Remote';

  @override
  String get sectionAboutTitle => 'Acerca de';

  @override
  String get sectionAboutDescription =>
      'Historia breve, propuesta de valor, especialidad y llamada a la acción.';

  @override
  String get sectionAboutHint =>
      '2–4 párrafos: quién es, cómo ayuda, qué le diferencia, cómo contactar.';

  @override
  String get sectionExperienceTitle => 'Experiencia';

  @override
  String get sectionExperienceDescription =>
      'Puestos, empresas, fechas y logros con cifras.';

  @override
  String get sectionExperienceHint =>
      'Cada puesto: contexto → acciones → resultado (métricas).';

  @override
  String get sectionEducationTitle => 'Educación';

  @override
  String get sectionEducationDescription =>
      'Centros, títulos, años, cursos relevantes.';

  @override
  String get sectionEducationHint =>
      'Incluya especialidad y actividades si refuerzan el perfil.';

  @override
  String get sectionSkillsTitle => 'Habilidades';

  @override
  String get sectionSkillsDescription =>
      'Habilidades clave para búsqueda y credibilidad.';

  @override
  String get sectionSkillsHint =>
      'Separadas por coma o línea: Flutter, Dart, SQLite, …';

  @override
  String get sectionCertificationsTitle => 'Certificaciones';

  @override
  String get sectionCertificationsDescription =>
      'Cursos y exámenes oficiales que generan confianza.';

  @override
  String get sectionCertificationsHint => 'Nombre | Organización | Año';

  @override
  String get sectionProjectsTitle => 'Proyectos';

  @override
  String get sectionProjectsDescription =>
      'Casos públicos, proyectos personales, open source.';

  @override
  String get sectionProjectsHint => 'Nombre — rol — stack — resultado/enlace';

  @override
  String get sectionFeaturedTitle => 'Destacado';

  @override
  String get sectionFeaturedDescription =>
      'Artículos, posts, portafolio — lo que quiere mostrar primero.';

  @override
  String get sectionFeaturedHint =>
      'Enlaces o descripciones de elementos destacados';

  @override
  String get sectionVolunteerTitle => 'Voluntariado';

  @override
  String get sectionVolunteerDescription =>
      'Experiencia sin ánimo de lucro si es relevante.';

  @override
  String get sectionVolunteerHint => 'Organización — rol — periodo — impacto';

  @override
  String get sectionRecommendationsTitle => 'Recomendaciones';

  @override
  String get sectionRecommendationsDescription =>
      'Endosos de colegas — prueba social.';

  @override
  String get sectionRecommendationsHint => 'A quién pedir y qué temas cubrir';

  @override
  String get sectionLocationIndustryTitle => 'Ubicación e industria';

  @override
  String get sectionLocationIndustryDescription =>
      'Dónde está y su industria — visible en la tarjeta intro.';

  @override
  String get sectionLocationIndustryHint => 'Ciudad, país · Industria';

  @override
  String get sectionContactLinksTitle => 'Contacto y enlaces';

  @override
  String get sectionContactLinksDescription =>
      'Sitios web, portfolio, email y redes.';

  @override
  String get sectionContactLinksHint => 'Un enlace por línea con etiqueta';

  @override
  String get sectionOpenToWorkTitle => 'Open to work';

  @override
  String get sectionOpenToWorkDescription =>
      'Preferencias de búsqueda y visibilidad para reclutadores.';

  @override
  String get sectionOpenToWorkHint =>
      'Roles, ubicaciones, fecha, remoto/híbrido';

  @override
  String get sectionLanguagesTitle => 'Idiomas';

  @override
  String get sectionLanguagesDescription => 'Idiomas y nivel de dominio.';

  @override
  String get sectionLanguagesHint =>
      'Inglés — Competencia profesional completa';

  @override
  String get sectionHonorsTitle => 'Honores y premios';

  @override
  String get sectionHonorsDescription => 'Premios y reconocimiento formal.';

  @override
  String get sectionHonorsHint => 'Título — emisor — año';

  @override
  String get sectionPublicationsTitle => 'Publicaciones';

  @override
  String get sectionPublicationsDescription => 'Artículos, papers y libros.';

  @override
  String get sectionPublicationsHint => 'Título — editorial — fecha — enlace';

  @override
  String get sectionPatentsTitle => 'Patentes';

  @override
  String get sectionPatentsDescription => 'Patentes en las que participó.';

  @override
  String get sectionPatentsHint => 'Título — oficina — número — año';

  @override
  String get sectionCoursesTitle => 'Cursos';

  @override
  String get sectionCoursesDescription =>
      'Formación además de títulos formales.';

  @override
  String get sectionCoursesHint => 'Curso — proveedor — año';

  @override
  String get sectionOrganizationsTitle => 'Organizaciones';

  @override
  String get sectionOrganizationsDescription =>
      'Membresías en asociaciones profesionales.';

  @override
  String get sectionOrganizationsHint => 'Organización — rol — años';

  @override
  String get sectionServicesTitle => 'Servicios';

  @override
  String get sectionServicesDescription =>
      'Servicios que ofrece (freelance / consultoría).';

  @override
  String get sectionServicesHint => 'Servicio — descripción';

  @override
  String get sectionCausesTitle => 'Causas';

  @override
  String get sectionCausesDescription => 'Causas que apoya en su perfil.';

  @override
  String get sectionCausesHint => 'Lista de causas o nota breve';

  @override
  String get sectionRecommendationsGivenTitle => 'Recomendaciones dadas';

  @override
  String get sectionRecommendationsGivenDescription =>
      'Recomendaciones que escribió para otros.';

  @override
  String get sectionRecommendationsGivenHint => 'Nombre — relación — extracto';

  @override
  String get sectionActivityTitle => 'Actividad';

  @override
  String get sectionActivityDescription =>
      'Publicaciones recientes — su voz pública.';

  @override
  String get sectionActivityHint => 'Títulos o extractos de publicaciones';

  @override
  String get sectionCreatorNewsletterTitle => 'Creator y newsletter';

  @override
  String get sectionCreatorNewsletterDescription =>
      'Newsletter o modo creador.';

  @override
  String get sectionCreatorNewsletterHint => 'Nombre — tema — enlace';

  @override
  String get publishNoteLocationIndustry =>
      'Ubicación e industria en la página Intro.';

  @override
  String get publishNoteContactLinks =>
      'Sitios y contacto en Intro o Contact info.';

  @override
  String get publishNoteOpenToWork => 'Preferencias en Jobs → Open to work.';

  @override
  String get publishNoteLanguages => 'Cada idioma con nivel en Languages.';

  @override
  String get publishNoteHonors => 'Honores se añaden uno a uno.';

  @override
  String get publishNotePublications =>
      'Publicaciones individuales con enlaces.';

  @override
  String get publishNotePatents => 'Patentes en la sección Patents.';

  @override
  String get publishNoteCourses => 'Cursos en la sección Courses.';

  @override
  String get publishNoteOrganizations => 'Organizaciones por separado.';

  @override
  String get publishNoteServices => 'Servicios en la sección Services.';

  @override
  String get publishNoteCauses => 'Causas vía Add profile section.';

  @override
  String get publishNoteRecommendationsGiven =>
      'Las recomendaciones dadas no se pegan en bloque.';

  @override
  String get publishNoteActivity => 'La actividad es su feed en LinkedIn.';

  @override
  String get publishNoteCreatorNewsletter =>
      'Newsletter en Creator mode / Pages.';

  @override
  String get importFromProfileUrl => 'Importar desde URL del perfil';

  @override
  String get importLinkedInExport => 'Exportación de LinkedIn';

  @override
  String get importLinkedInExportTooltip =>
      'ZIP o JSON de Ajustes → Privacidad → Obtener copia de tus datos';

  @override
  String get refreshLinkedIn => 'Actualizar desde LinkedIn';

  @override
  String get refreshLinkedInTooltip =>
      'Reimportar: carpeta → último archivo → URL';

  @override
  String get refreshLinkedInNothing =>
      'No hay datos nuevos. Configure carpeta o archivo en Ajustes.';

  @override
  String get importUpToDate => 'Las secciones ya están actualizadas.';

  @override
  String get importMergeCancelled => 'Importación cancelada.';

  @override
  String get importMergeTitle => 'Revisar cambios';

  @override
  String importMergeSubtitle(String source, int count) {
    return 'Origen: $source · $count secciones cambiadas';
  }

  @override
  String get importMergeSelectChanged => 'Solo cambiadas';

  @override
  String get importMergeSelectAll => 'Todas';

  @override
  String get importMergeSelectNone => 'Ninguna';

  @override
  String get importMergePreview => 'Vista previa';

  @override
  String get importMergeApply => 'Aplicar';

  @override
  String get importMergeCurrent => 'Actual';

  @override
  String get importMergeIncoming => 'Nuevo';

  @override
  String get importMergeStatusNew => 'Nueva sección';

  @override
  String get importMergeStatusChanged => 'Actualizada';

  @override
  String get importMergeStatusUnchanged => 'Sin cambios';

  @override
  String get snapshotsTitle => 'Historial';

  @override
  String get snapshotsEmpty =>
      'Las instantáneas se crean antes de cada importación.';

  @override
  String get snapshotRestore => 'Restaurar';

  @override
  String get snapshotRestoreTitle => '¿Restaurar instantánea?';

  @override
  String get snapshotRestoreBody =>
      'Se reemplazará el perfil actual. Primero se guarda una copia.';

  @override
  String get snapshotRestoreConfirm => 'Restaurar';

  @override
  String get snapshotRestored => 'Instantánea restaurada.';

  @override
  String get atsMatchTitle => 'Coincidencia ATS';

  @override
  String atsMatchScore(int percent) {
    return 'Puntuación: $percent%';
  }

  @override
  String atsMatchMissing(String keywords) {
    return 'Añada: $keywords';
  }

  @override
  String importReminderBody(int days) {
    return 'Última importación hace $days días. Actualice los datos.';
  }

  @override
  String get importReminderSnooze => 'Recordar en 7 días';

  @override
  String get syncSettingsTitle => 'Sincronización LinkedIn';

  @override
  String get syncSettingsSubtitle =>
      'La carpeta vigilada importa el ZIP/JSON más reciente.';

  @override
  String lastExportPath(String path) {
    return 'Última exportación: $path';
  }

  @override
  String get watchFolderNotSet => 'Carpeta no configurada';

  @override
  String watchFolderPath(String path) {
    return 'Carpeta: $path';
  }

  @override
  String get watchFolderPick => 'Elegir carpeta';

  @override
  String get watchFolderSet => 'Carpeta guardada.';

  @override
  String get experienceRolesTitle => 'Roles detectados';

  @override
  String get dashboardImports => 'Importaciones';

  @override
  String get dashboardDynamicsTitle => 'Dinámica de crecimiento';

  @override
  String get dashboardDynamicsSubtitle =>
      'Completitud por instantáneas y puntuación del evaluador.';

  @override
  String get dashboardCompletenessTrend => 'Completitud del perfil';

  @override
  String get dashboardTrendHint => 'Secciones rellenadas en el tiempo';

  @override
  String get dashboardScoreTrend => 'Puntuación del perfil';

  @override
  String get dashboardScoreTrendHint => 'Puntuación tras cada evaluación';

  @override
  String get dashboardLinkedInStatsTitle => 'Estadísticas de LinkedIn';

  @override
  String get dashboardLinkedInStatsEmpty =>
      'Importe un ZIP de LinkedIn con CSV de analíticas (vistas, búsquedas, etc.).';

  @override
  String dashboardTargetRole(String role) {
    return 'Objetivo: $role';
  }

  @override
  String dashboardLastImport(String when) {
    return 'Importación: $when';
  }

  @override
  String get dashboardMetricProfileViews => 'Vistas del perfil';

  @override
  String get dashboardMetricSearch => 'Apariciones en búsqueda';

  @override
  String get dashboardMetricPosts => 'Impresiones de publicaciones';

  @override
  String get dashboardMetricFollowers => 'Seguidores';

  @override
  String get dashboardMetricConnections => 'Conexiones';

  @override
  String get importFromUrlFailed =>
      'No se pudo cargar el perfil desde la URL. LinkedIn puede bloquear la importación automática — copie manualmente o pegue abajo.';

  @override
  String get importFromUrlHint =>
      'Usa la URL guardada. Solo perfiles públicos; los datos pueden ser parciales.';

  @override
  String get profileLanguageTitle => 'Idioma de la app';

  @override
  String get profileLanguageSubtitle =>
      'Interfaz, consejos, borradores IA y puntuación usan el mismo idioma.';

  @override
  String get snackLanguageChanged =>
      'Idioma actualizado. Ejecute el análisis de nuevo.';

  @override
  String get compareOnlyWithAi => 'Solo secciones con IA';

  @override
  String compareAiSectionsCount(int count) {
    return '$count con versión IA';
  }

  @override
  String get compareNoAiTitle => 'Aún no hay versión IA';

  @override
  String get compareNoAiHint =>
      'Genere el perfil IA primero y vuelva aquí para comparar.';

  @override
  String get scoreTitle => 'Puntuación del perfil';

  @override
  String get scoreSubtitle =>
      'Evaluación independiente estilo reclutador: perfil actual y borrador IA.';

  @override
  String get scoreEmptyTitle => 'Sin puntuación aún';

  @override
  String get scoreEmptyHint =>
      'Importe su perfil y pulse Puntuar perfil en la barra. Usa un agente evaluador distinto del generador de contenido.';

  @override
  String get scoreCurrentProfile => 'Perfil actual';

  @override
  String get scoreAiProfile => 'Versión IA';

  @override
  String get scoreAiNotGenerated => 'No generada';

  @override
  String scoreDeltaPositive(int delta) {
    return '+$delta vs actual';
  }

  @override
  String scoreDeltaNegative(int delta) {
    return '−$delta vs actual';
  }

  @override
  String get scoreDeltaNeutral => 'Igual que actual';

  @override
  String get scoreSectionBreakdown => 'Puntuación por sección';

  @override
  String get scoreRecommendationsTitle => 'Recomendaciones del evaluador';

  @override
  String get scoreRecommendationsSubtitle =>
      'Del agente de puntuación independiente — no del redactor.';

  @override
  String get scoreCurrentShort => 'Actual';

  @override
  String get scoreAiShort => 'IA';

  @override
  String scoreEvaluatorBadge(String provider) {
    return 'Evaluador · $provider';
  }

  @override
  String get statProfileScore => 'Puntuación';

  @override
  String get statAiScore => 'Puntuación IA';

  @override
  String scoreEvalViaProvider(String provider) {
    return 'Puntuado vía $provider';
  }

  @override
  String get scoreEvalLocalFallback =>
      'LLM no disponible — puntuación heurística';

  @override
  String scoreEvalLlmErrorFallback(String error) {
    return 'Error del evaluador ($error) — heurística';
  }

  @override
  String get snackScoreDone => 'Perfil puntuado';

  @override
  String get navCoach => 'Coach+';

  @override
  String get wowHubTitle => 'Herramientas Coach+';

  @override
  String get wowHubSubtitle =>
      'Simulador reclutador, match vacante, pronóstico, A/B titular, benchmark.';

  @override
  String get wowRecruiterTitle => 'Simulador reclutador';

  @override
  String get wowRecruiterSubtitle => 'Preguntas, veredicto, mapa de secciones';

  @override
  String get wowRecruiterIntro =>
      'Un reclutador IA revisa su perfil y hace preguntas difíciles.';

  @override
  String get wowRunSimulation => 'Ejecutar simulación';

  @override
  String get wowHeatmapTitle => 'Mapa de secciones';

  @override
  String get wowHeatmapEmpty => 'Sin datos de mapa.';

  @override
  String get wowHeatStrong => 'Fuerte';

  @override
  String get wowHeatNeutral => 'Neutral';

  @override
  String get wowHeatWeak => 'Débil';

  @override
  String get wowQuestionsTitle => 'Preguntas que harían';

  @override
  String get wowVerdictInterview => 'Entrevistaría';

  @override
  String get wowVerdictMaybe => 'Tal vez';

  @override
  String get wowVerdictPass => 'Descartaría';

  @override
  String get wowLocalFallbackHint => 'LLM off — simulación heurística.';

  @override
  String get wowJobFitTitle => 'Match vacante';

  @override
  String get wowJobFitSubtitle => 'Pegue la oferta — % match, gaps, ediciones';

  @override
  String get wowJobFitIntro =>
      'Compare su perfil con una vacante. Guarda snapshot tailored.';

  @override
  String get wowJobFitPasteLabel => 'Descripción del puesto';

  @override
  String get wowJobFitPasteHint => 'Pegue el texto completo de la oferta…';

  @override
  String get wowJobFitAnalyze => 'Analizar fit';

  @override
  String get wowJobFitMatch => 'Encaje';

  @override
  String get wowJobFitMissing => 'Palabras clave faltantes';

  @override
  String get wowJobFitGaps => 'Lista de gaps';

  @override
  String get wowJobFitSaveSnapshot => 'Guardar snapshot';

  @override
  String get wowJobFitApplyAi => 'Aplicar a borrador IA';

  @override
  String get wowJobFitSnapshotSaved => 'Snapshot guardado.';

  @override
  String get wowJobFitAppliedAi => 'Ediciones aplicadas a IA.';

  @override
  String get wowCareerTitle => 'Carrera what-if';

  @override
  String get wowCareerSubtitle => 'Línea temporal + pronóstico 1/3/5 años';

  @override
  String get wowCareerIntro =>
      'Timeline de experiencia y pronóstico de pasos siguientes.';

  @override
  String get wowCareerSeniorSlider => 'Experiencia senior extra';

  @override
  String get wowCareerYears => 'años';

  @override
  String get wowCareerCourseLabel => 'Curso / certificación (opcional)';

  @override
  String get wowCareerCourseHint => 'ej. AWS Solutions Architect';

  @override
  String get wowCareerForecast => 'Pronosticar';

  @override
  String get wowCareerSkills => 'Skills a añadir';

  @override
  String get wowHeadlineAbTitle => 'A/B titular';

  @override
  String get wowHeadlineAbSubtitle => '5 variantes rankeadas';

  @override
  String get wowHeadlineAbIntro =>
      'Genere titulares y elija el mejor del ranking.';

  @override
  String get wowHeadlineGenerate => 'Generar y rankear';

  @override
  String get wowHeadlineAbLegend =>
      'Puntuación: ATS, legibilidad, hook, unicidad.';

  @override
  String get wowHeadlineBest => 'Mejor';

  @override
  String get wowHeadlineReadability => 'Legibilidad';

  @override
  String get wowHeadlineHook => 'Hook';

  @override
  String get wowHeadlineUnique => 'Único';

  @override
  String get wowHeadlineUse => 'Usar';

  @override
  String get wowHeadlineApplied => 'Titular aplicado a IA.';

  @override
  String get wowBenchmarkTitle => 'Tú vs mediana';

  @override
  String get wowBenchmarkSubtitle => 'Radar benchmark por rol';

  @override
  String get wowBenchmarkIntro => 'Compare métricas con la mediana del rol.';

  @override
  String get wowBenchmarkRun => 'Comparar';

  @override
  String get wowBenchmarkYou => 'Tú';

  @override
  String get wowBenchmarkMedian => 'Mediana';

  @override
  String get profilesSwitcherLabel => 'Perfil';

  @override
  String get profilesSectionTitle => 'Perfiles gestionados';

  @override
  String get profilesSectionSubtitle =>
      'Cambie entre candidatos: cada perfil tiene sus datos de LinkedIn, borradores IA y puntuaciones.';

  @override
  String get profilesAddTitle => 'Nuevo perfil';

  @override
  String get profilesAddAction => 'Añadir perfil';

  @override
  String get profilesAddConfirm => 'Crear';

  @override
  String get profilesRenameTitle => 'Renombrar perfil';

  @override
  String get profilesRenameAction => 'Renombrar';

  @override
  String get profilesDeleteTitle => '¿Eliminar perfil?';

  @override
  String profilesDeleteBody(String name) {
    return '¿Eliminar «$name» y todos sus datos? No se puede deshacer.';
  }

  @override
  String get profilesDeleteAction => 'Eliminar';

  @override
  String get profilesDeleteConfirm => 'Eliminar';

  @override
  String get profilesCannotDeleteLast => 'Necesita al menos un perfil.';

  @override
  String get profilesNameHint => 'ej. Alex Morgan — Senior PM';

  @override
  String get profilesActive => 'Activo';

  @override
  String profilesCount(int count) {
    return '$count perfiles';
  }

  @override
  String snackProfileSwitched(String name) {
    return 'Cambiado a $name';
  }

  @override
  String get navMarketplace => 'Marketplace';

  @override
  String get marketplaceCatalogTitle => 'Marketplace de carrera';

  @override
  String get marketplaceTopUp => 'Recargar créditos en el navegador';

  @override
  String get marketplaceCategoryCareer => 'Capacidades de carrera';

  @override
  String get marketplacePrivacyNotice =>
      'Tu perfil nunca sale de este dispositivo. Las capacidades se entregan a ti, no al revés.';

  @override
  String get aiProviderAimarket => 'AI Market';

  @override
  String get aiProviderAimarketHint =>
      'Marketplace de pago por uso. Basado en wallet, sin API key.';

  @override
  String get aiProviderAimarketSetupHint =>
      'AI Market: hub.aicom.io — marketplace descentralizado. Recarga créditos primero.';
}
