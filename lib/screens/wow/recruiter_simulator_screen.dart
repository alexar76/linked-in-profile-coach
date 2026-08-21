import 'package:flutter/material.dart';

import '../../models/wow/recruiter_simulator_result.dart';
import '../../repositories/app_repository.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';
import '../../widgets/wow/section_heatmap.dart';

class RecruiterSimulatorScreen extends StatefulWidget {
  const RecruiterSimulatorScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<RecruiterSimulatorScreen> createState() =>
      _RecruiterSimulatorScreenState();
}

class _RecruiterSimulatorScreenState extends State<RecruiterSimulatorScreen> {
  RecruiterSimulatorResult? _result;
  bool _loading = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadCached();
  }

  Future<void> _loadCached() async {
    final cached = await widget.repo.getLastRecruiterSimulator();
    if (!mounted) return;
    setState(() {
      _result = cached;
      _loaded = true;
    });
  }

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final r = await widget.repo.runRecruiterSimulator();
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r = _result;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wowRecruiterTitle)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(l10n.wowRecruiterIntro, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loading ? null : _run,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(l10n.wowRunSimulation),
                ),
                if (r != null) ...[
                  const SizedBox(height: 24),
                  _VerdictCard(result: r),
                  const SizedBox(height: 20),
                  Text(
                    l10n.wowHeatmapTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SectionHeatmap(heatmap: r.sectionHeatmap),
                  const SizedBox(height: 24),
                  Text(
                    l10n.wowQuestionsTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ...r.questions.map(
                    (q) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(q.question),
                        subtitle: Text(q.concern),
                        leading: const Icon(Icons.help_outline),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                  if (!r.usedLlm)
                    Text(
                      l10n.wowLocalFallbackHint,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.palette.textSecondary,
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.result});

  final RecruiterSimulatorResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, color, label) = switch (result.verdict) {
      RecruiterVerdict.interview => (
          Icons.check_circle,
          const Color(0xFF166534),
          l10n.wowVerdictInterview,
        ),
      RecruiterVerdict.pass => (
          Icons.cancel_outlined,
          const Color(0xFF9A3412),
          l10n.wowVerdictPass,
        ),
      _ => (Icons.help_outline, const Color(0xFFB45309), l10n.wowVerdictMaybe),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                '${result.overallScore}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(result.verdictSummary),
        ],
      ),
    );
  }
}
