import 'package:flutter/material.dart';

import '../../models/wow/job_fit_result.dart';
import '../../repositories/app_repository.dart';
import '../../utils/l10n_ext.dart';
import '../../utils/section_l10n.dart';

class JobFitScreen extends StatefulWidget {
  const JobFitScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<JobFitScreen> createState() => _JobFitScreenState();
}

class _JobFitScreenState extends State<JobFitScreen> {
  final _controller = TextEditingController();
  JobFitResult? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final saved = await widget.repo.getJobDescription();
    final cached = await widget.repo.getLastJobFit();
    if (!mounted) return;
    if (saved != null) _controller.text = saved;
    setState(() => _result = cached);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final r = await widget.repo.runJobFit(text);
      if (!mounted) return;
      setState(() => _result = r);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorGeneric(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveSnapshot() async {
    if (_result == null) return;
    await widget.repo.saveJobFitTailoredSnapshot(_result!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.wowJobFitSnapshotSaved)),
    );
  }

  Future<void> _applyAi() async {
    if (_result == null) return;
    await widget.repo.applyJobFitEditsToAi(_result!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.wowJobFitAppliedAi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r = _result;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wowJobFitTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.wowJobFitIntro),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 12,
            decoration: InputDecoration(
              labelText: l10n.wowJobFitPasteLabel,
              hintText: l10n.wowJobFitPasteHint,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _loading ? null : _analyze,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.analytics_outlined),
            label: Text(l10n.wowJobFitAnalyze),
          ),
          if (r != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  '${r.matchPercent}%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    r.jobTitle.isNotEmpty ? r.jobTitle : l10n.wowJobFitMatch,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (r.summary != null) ...[
              const SizedBox(height: 8),
              Text(r.summary!),
            ],
            const SizedBox(height: 16),
            if (r.missingKeywords.isNotEmpty) ...[
              Text(l10n.wowJobFitMissing, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: r.missingKeywords
                    .take(15)
                    .map((k) => Chip(label: Text(k), visualDensity: VisualDensity.compact))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            Text(l10n.wowJobFitGaps, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...r.gaps.map(
              (g) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(sectionTitle(l10n, g.sectionKey)),
                  subtitle: Text('${g.issue}\n${g.suggestion}'),
                  isThreeLine: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _saveSnapshot,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(l10n.wowJobFitSaveSnapshot),
                ),
                if (r.sectionEdits.isNotEmpty)
                  FilledButton.icon(
                    onPressed: _applyAi,
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(l10n.wowJobFitApplyAi),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
