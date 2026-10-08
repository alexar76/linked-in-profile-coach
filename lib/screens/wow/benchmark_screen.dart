import 'package:flutter/material.dart';

import '../../models/wow/benchmark_result.dart';
import '../../repositories/app_repository.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';
import '../../widgets/wow/radar_chart.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  BenchmarkResult? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCached();
  }

  Future<void> _loadCached() async {
    final c = await widget.repo.getLastBenchmark();
    if (!mounted) return;
    setState(() => _result = c);
  }

  Future<void> _run() async {
    setState(() => _loading = true);
    try {
      final r = await widget.repo.runBenchmark();
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
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wowBenchmarkTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.wowBenchmarkIntro),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _run,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.radar),
            label: Text(l10n.wowBenchmarkRun),
          ),
          if (r != null && r.dimensions.isNotEmpty) ...[
            const SizedBox(height: 24),
            Center(
              child: BenchmarkRadarChart(dimensions: r.dimensions),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: palette.primary, label: l10n.wowBenchmarkYou),
                const SizedBox(width: 24),
                _LegendDot(
                  color: palette.textSecondary,
                  label: l10n.wowBenchmarkMedian,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(r.summary),
            const SizedBox(height: 20),
            ...r.dimensions.map(
              (d) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(d.label),
                  subtitle: Text(
                    '${l10n.wowBenchmarkYou}: ${d.you.toStringAsFixed(0)}${d.unit.isNotEmpty ? ' ${d.unit}' : ''} · '
                    '${l10n.wowBenchmarkMedian}: ${d.median.toStringAsFixed(1)}',
                  ),
                  trailing: Icon(
                    d.you >= d.median ? Icons.trending_up : Icons.trending_down,
                    color: d.you >= d.median
                        ? const Color(0xFF166534)
                        : const Color(0xFF9A3412),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
