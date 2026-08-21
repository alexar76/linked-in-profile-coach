import 'package:flutter/material.dart';

import '../../models/wow/career_what_if_result.dart';
import '../../repositories/app_repository.dart';
import '../../utils/l10n_ext.dart';
import '../../widgets/wow/career_timeline.dart';

class CareerWhatIfScreen extends StatefulWidget {
  const CareerWhatIfScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<CareerWhatIfScreen> createState() => _CareerWhatIfScreenState();
}

class _CareerWhatIfScreenState extends State<CareerWhatIfScreen> {
  double _seniorYears = 0;
  final _courseController = TextEditingController();
  CareerWhatIfResult? _result;
  String _experienceText = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final sections = await widget.repo.getSections();
    final cached = await widget.repo.getLastCareerWhatIf();
    final exp = sections
        .firstWhere((s) => s.key == 'experience', orElse: () => sections.first)
        .content;
    if (!mounted) return;
    setState(() {
      _experienceText = exp;
      _result = cached;
    });
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _forecast() async {
    setState(() => _loading = true);
    try {
      final r = await widget.repo.runCareerWhatIf(
        extraSeniorYears: _seniorYears.round(),
        extraCourse: _courseController.text.trim().isEmpty
            ? null
            : _courseController.text.trim(),
      );
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
      appBar: AppBar(title: Text(l10n.wowCareerTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.wowCareerIntro),
          const SizedBox(height: 20),
          Text(l10n.wowCareerSeniorSlider, style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            value: _seniorYears,
            min: 0,
            max: 5,
            divisions: 5,
            label: '+${_seniorYears.round()} ${l10n.wowCareerYears}',
            onChanged: (v) => setState(() => _seniorYears = v),
          ),
          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              labelText: l10n.wowCareerCourseLabel,
              hintText: l10n.wowCareerCourseHint,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _forecast,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_graph),
            label: Text(l10n.wowCareerForecast),
          ),
          if (r != null) ...[
            const SizedBox(height: 24),
            Text(r.narrative, style: const TextStyle(fontSize: 15)),
            if (r.skillsToAdd.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.wowCareerSkills, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: r.skillsToAdd
                    .map((s) => Chip(label: Text(s)))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            CareerTimeline(
              experienceText: _experienceText,
              forecast: r,
            ),
          ],
        ],
      ),
    );
  }
}
