@Tags(['doc-screenshots'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/fixtures/doc_compare_samples.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';
import 'package:linkedin_profile_coach/services/text_diff.dart';
import 'package:linkedin_profile_coach/theme/app_theme_id.dart';
import 'package:linkedin_profile_coach/theme/app_themes.dart';
import 'package:linkedin_profile_coach/widgets/section_diff_panel.dart';

/// Generates PNGs for docs/USER_GUIDE.md
///
/// Run: flutter test test/generate_doc_screenshots_test.dart
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('write compare screenshots to docs/images', (tester) async {
    final outDir = Directory('docs/images');
    outDir.createSync(recursive: true);

    for (final sample in docCompareSamples) {
      await _captureSideBySide(tester, outDir, sample);
      if (sample.key == 'headline' || sample.key == 'about') {
        await _captureDiff(tester, outDir, sample);
      }
    }

    await _captureOverview(tester, outDir);
  });
}

Future<void> _captureSideBySide(
  WidgetTester tester,
  Directory outDir,
  DocCompareSample sample,
) async {
  final key = GlobalKey();
  await tester.binding.setSurfaceSize(const Size(1100, 520));
  await tester.pumpWidget(_wrap(
    key: key,
    child: _CompareDocFrame(
      title: sample.titleRu,
      child: SideBySideCompare(
        leftTitle: 'LinkedIn (импорт)',
        rightTitle: 'ИИ-версия',
        leftText: sample.before,
        rightText: sample.after,
      ),
    ),
  ));
  await tester.pump();
  await _savePng(tester, key, '${outDir.path}/compare-${sample.key}-side-by-side.png');
}

Future<void> _captureDiff(
  WidgetTester tester,
  Directory outDir,
  DocCompareSample sample,
) async {
  final key = GlobalKey();
  final similarity = TextDiff.similarityPercent(sample.before, sample.after);
  await tester.binding.setSurfaceSize(const Size(1100, 520));
  await tester.pumpWidget(_wrap(
    key: key,
    child: _CompareDocFrame(
      title: '${sample.titleRu} — режим Diff',
      child: SectionDiffPanel(
        oldText: sample.before,
        newText: sample.after,
        similarityPercent: similarity,
      ),
    ),
  ));
  await tester.pump();
  await _savePng(tester, key, '${outDir.path}/compare-${sample.key}-diff.png');
}

Future<void> _captureOverview(WidgetTester tester, Directory outDir) async {
  final key = GlobalKey();
  final sample = docCompareSamples.first;
  final similarity = TextDiff.similarityPercent(sample.before, sample.after);

  await tester.binding.setSurfaceSize(const Size(1100, 640));
  await tester.pumpWidget(_wrap(
    key: key,
    child: _CompareDocFrame(
      title: 'Сравнение — обзор',
      subtitle:
          'Слева текст с LinkedIn, справа ИИ-черновик. Кольцо — % схожести (${similarity.toStringAsFixed(0)}%).',
      headerExtra: _SimilarityBadge(percent: similarity),
      child: SideBySideCompare(
        leftTitle: 'LinkedIn (импорт)',
        rightTitle: 'ИИ-версия',
        leftText: sample.before,
        rightText: sample.after,
      ),
    ),
  ));
  await tester.pump();
  await _savePng(tester, key, '${outDir.path}/compare-overview.png');
}

Widget _wrap({required GlobalKey key, required Widget child}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppThemes.themeData(AppThemeId.darkGold),
    home: Scaffold(
      backgroundColor: AppThemes.palette(AppThemeId.darkGold).background,
      body: Center(
        child: RepaintBoundary(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );
}

Future<void> _savePng(
  WidgetTester tester,
  GlobalKey key,
  String path,
) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  await File(path).writeAsBytes(bytes!.buffer.asUint8List());
}

class _CompareDocFrame extends StatelessWidget {
  const _CompareDocFrame({
    required this.title,
    required this.child,
    this.subtitle,
    this.headerExtra,
  });

  final String title;
  final String? subtitle;
  final Widget? headerExtra;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = AppThemes.palette(AppThemeId.darkGold);

    return Container(
      width: 1068,
      height: 488,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: p.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: p.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?headerExtra,
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SimilarityBadge extends StatelessWidget {
  const _SimilarityBadge({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final p = AppThemes.palette(AppThemeId.darkGold);
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: p.primary, width: 4),
      ),
      child: Text(
        '${percent.toStringAsFixed(0)}%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: p.textPrimary,
        ),
      ),
    );
  }
}
