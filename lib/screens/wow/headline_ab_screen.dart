import 'package:flutter/material.dart';

import '../../models/wow/headline_ab_result.dart';
import '../../repositories/app_repository.dart';
import '../../utils/l10n_ext.dart';

class HeadlineAbScreen extends StatefulWidget {
  const HeadlineAbScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<HeadlineAbScreen> createState() => _HeadlineAbScreenState();
}

class _HeadlineAbScreenState extends State<HeadlineAbScreen> {
  HeadlineAbResult? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCached();
  }

  Future<void> _loadCached() async {
    final c = await widget.repo.getLastHeadlineAb();
    if (!mounted) return;
    setState(() => _result = c);
  }

  Future<void> _generate() async {
    setState(() => _loading = true);
    try {
      final r = await widget.repo.runHeadlineAb();
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

  Future<void> _apply(HeadlineVariantScore v) async {
    await widget.repo.applyHeadlineVariant(v.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.wowHeadlineApplied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final variants = _result?.headlineVariants ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wowHeadlineAbTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.wowHeadlineAbIntro),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.leaderboard),
            label: Text(l10n.wowHeadlineGenerate),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.wowHeadlineAbLegend,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 20),
          ...variants.asMap().entries.map((entry) {
            final i = entry.key;
            final v = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          child: Text('${i + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${v.overall}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('/100'),
                        const Spacer(),
                        if (i == 0)
                          Chip(
                            label: Text(l10n.wowHeadlineBest),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(v.text, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 12),
                    _ScoreRow(label: 'ATS', value: v.ats),
                    _ScoreRow(label: l10n.wowHeadlineReadability, value: v.readability),
                    _ScoreRow(label: l10n.wowHeadlineHook, value: v.hook),
                    _ScoreRow(label: l10n.wowHeadlineUnique, value: v.uniqueness),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _apply(v),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.wowHeadlineUse),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text('$value', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
