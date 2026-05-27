import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/app_repository.dart';
import '../theme/app_theme_id.dart';
import '../utils/l10n_ext.dart';
import '../widgets/ai_settings_card.dart';
import '../widgets/resume_upload_panel.dart';
import '../widgets/theme/theme_picker.dart';
import 'wizard/analysis_wizard_screen.dart';
import 'wizard/setup_wizard_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({
    super.key,
    required this.repo,
    this.onImported,
    this.onThemeChanged,
    this.onLocaleChanged,
  });

  final AppRepository repo;
  final VoidCallback? onImported;
  final ValueChanged<AppThemeId>? onThemeChanged;
  final ValueChanged<Locale>? onLocaleChanged;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _roleController = TextEditingController();
  final _industryController = TextEditingController();
  final _nameController = TextEditingController();
  final _profileUrlController = TextEditingController();
  String? _resumeName;
  DateTime? _resumeUploaded;
  String _resumePreview = '';
  bool _loading = true;
  AppThemeId _themeId = AppThemeId.darkGold;
  String? _watchFolder;
  String? _lastExportPath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final role = await widget.repo.getTargetRole();
    final industry = await widget.repo.getTargetIndustry();
    final name = await widget.repo.getDisplayName();
    final profileUrl = await widget.repo.getProfileUrl();
    final resume = await widget.repo.getResume();
    final theme = await widget.repo.getThemeId();
    final watchFolder = await widget.repo.getWatchFolderPath();
    final lastExport = await widget.repo.getLastExportPath();

    _roleController.text = role;
    _industryController.text = industry;
    _nameController.text = name;
    _profileUrlController.text = profileUrl;

    if (!mounted) return;
    setState(() {
      _themeId = theme;
      _resumeName = resume?.filename;
      _resumeUploaded = resume?.uploadedAt;
      _resumePreview = resume != null
          ? resume.extractedText.length > 400
              ? '${resume.extractedText.substring(0, 400)}...'
              : resume.extractedText
          : '';
      _watchFolder = watchFolder;
      _lastExportPath = lastExport;
      _loading = false;
    });
  }

  Future<void> _pickWatchFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    await widget.repo.saveWatchFolderPath(path);
    setState(() => _watchFolder = path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.watchFolderSet)),
    );
  }

  Future<void> _saveSettings() async {
    await widget.repo.saveTargetRole(_roleController.text.trim());
    await widget.repo.saveTargetIndustry(_industryController.text.trim());
    await widget.repo.saveDisplayName(_nameController.text.trim());
    await widget.repo.saveProfileUrl(_profileUrlController.text.trim());
    widget.onImported?.call();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.snackSaved)),
    );
  }

  @override
  void dispose() {
    _roleController.dispose();
    _industryController.dispose();
    _nameController.dispose();
    _profileUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          context.l10n.adminTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(context.l10n.dashboardSubtitle),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ThemePicker(
              selected: _themeId,
              onSelected: (id) {
                setState(() => _themeId = id);
                widget.repo.saveThemeId(id);
                widget.onThemeChanged?.call(id);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminProfileSection,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.setupNameLabel,
                    hintText: context.l10n.setupNameHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _profileUrlController,
                  decoration: InputDecoration(
                    labelText: context.l10n.setupUrlLabel,
                    hintText: context.l10n.setupUrlHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.setupRoleLabel,
                    hintText: context.l10n.setupRoleHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _industryController,
                  decoration: InputDecoration(
                    labelText: context.l10n.setupIndustryLabel,
                    hintText: context.l10n.setupIndustryHint,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _saveSettings,
                  child: Text(context.l10n.btnSave),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.syncSettingsTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.syncSettingsSubtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 12),
                if (_lastExportPath != null && _lastExportPath!.isNotEmpty)
                  Text(
                    context.l10n.lastExportPath(_lastExportPath!),
                    style: const TextStyle(fontSize: 12),
                  ),
                const SizedBox(height: 8),
                Text(
                  _watchFolder == null || _watchFolder!.isEmpty
                      ? context.l10n.watchFolderNotSet
                      : context.l10n.watchFolderPath(_watchFolder!),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickWatchFolder,
                  icon: const Icon(Icons.folder_open),
                  label: Text(context.l10n.watchFolderPick),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AiSettingsCard(
          repo: widget.repo,
          onLocaleChanged: widget.onLocaleChanged,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminResumeSection,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.setupResumeSubtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 16),
                if (_resumeName != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(_resumeName!),
                    subtitle: Text(
                      _resumeUploaded != null
                          ? context.l10n.adminResumeLoaded(
                              dateFmt.format(_resumeUploaded!),
                            )
                          : '',
                    ),
                  ),
                  if (_resumePreview.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.adminResumePreviewLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _resumePreview,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
                ResumeUploadPanel(
                  repo: widget.repo,
                  compact: true,
                  onUploaded: _load,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.btnOpenWizard,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AnalysisWizardScreen(repo: widget.repo),
                      ),
                    );
                  },
                  child: Text(context.l10n.restartAnalysis),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    await widget.repo.setOnboardingComplete(false);
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => SetupWizardScreen(
                          repo: widget.repo,
                          onLocaleChanged: (_) {},
                        ),
                      ),
                      (_) => false,
                    );
                  },
                  child: Text(context.l10n.restartSetup),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF0A66C2)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.adminPrivacyNote,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
