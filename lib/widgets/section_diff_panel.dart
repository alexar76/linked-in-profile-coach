import 'package:flutter/material.dart';

import '../services/text_diff.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';

class SectionDiffPanel extends StatelessWidget {
  const SectionDiffPanel({
    super.key,
    required this.oldText,
    required this.newText,
    required this.similarityPercent,
  });

  final String oldText;
  final String newText;
  final double similarityPercent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rawDiff = TextDiff.lineDiff(oldText, newText);
    // Build inline-diff items: pair consecutive removed+added into word-level entries.
    final items = _buildItems(rawDiff);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _LegendDot(color: Colors.red.shade100, label: l10n.diffRemoved),
            const SizedBox(width: 16),
            _LegendDot(color: Colors.green.shade100, label: l10n.diffAdded),
            const Spacer(),
            Text(
              l10n.diffSimilarity(similarityPercent.toStringAsFixed(0)),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, i) => _buildItem(context, items[i]),
            ),
          ),
        ),
      ],
    );
  }

  List<_DiffItem> _buildItems(List<DiffLine> lines) {
    final items = <_DiffItem>[];
    var idx = 0;
    while (idx < lines.length) {
      final line = lines[idx];
      // Detect single removed + single added pair → render as inline word diff.
      if (line.type == DiffType.removed &&
          idx + 1 < lines.length &&
          lines[idx + 1].type == DiffType.added) {
        items.add(_DiffItem.inline(
          removed: line.text,
          added: lines[idx + 1].text,
        ));
        idx += 2;
        continue;
      }
      items.add(_DiffItem.line(line));
      idx++;
    }
    return items;
  }

  Widget _buildItem(BuildContext context, _DiffItem item) {
    if (item.isInline) {
      return _InlineDiffRow(
        removed: item.removed!,
        added: item.added!,
      );
    }

    final line = item.line!;
    if (line.type == DiffType.same && line.text.trim().isEmpty) {
      return const SizedBox(height: 4);
    }

    final bg = switch (line.type) {
      DiffType.added => Colors.green.shade50,
      DiffType.removed => Colors.red.shade50,
      DiffType.same => Colors.transparent,
    };
    final prefix = switch (line.type) {
      DiffType.added => '+ ',
      DiffType.removed => '− ',
      DiffType.same => '  ',
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$prefix${line.text.isEmpty ? ' ' : line.text}',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }
}

/// Renders a removed line immediately above an added line with word-level
/// highlight within each — deleted words highlighted red, added words green.
class _InlineDiffRow extends StatelessWidget {
  const _InlineDiffRow({required this.removed, required this.added});

  final String removed;
  final String added;

  @override
  Widget build(BuildContext context) {
    final spans = TextDiff.wordDiff(removed, added);

    final removedSpans = spans
        .where((s) => s.type != DiffType.added)
        .map((s) => _wordSpan(s, forRemoved: true))
        .toList();

    final addedSpans = spans
        .where((s) => s.type != DiffType.removed)
        .map((s) => _wordSpan(s, forRemoved: false))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DiffRichLine(prefix: '− ', spans: removedSpans, bg: Colors.red.shade50),
        const SizedBox(height: 2),
        _DiffRichLine(prefix: '+ ', spans: addedSpans, bg: Colors.green.shade50),
        const SizedBox(height: 2),
      ],
    );
  }

  InlineSpan _wordSpan(WordSpan s, {required bool forRemoved}) {
    if (s.type == DiffType.same) {
      return TextSpan(
        text: s.text,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      );
    }
    final bg = forRemoved
        ? Colors.red.shade200.withValues(alpha: 0.7)
        : Colors.green.shade200.withValues(alpha: 0.7);
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          s.text,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
      ),
    );
  }
}

class _DiffRichLine extends StatelessWidget {
  const _DiffRichLine({
    required this.prefix,
    required this.spans,
    required this.bg,
  });

  final String prefix;
  final List<InlineSpan> spans;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.4,
            color: Colors.black87,
          ),
          children: [
            TextSpan(text: prefix),
            ...spans,
          ],
        ),
      ),
    );
  }
}

class _DiffItem {
  _DiffItem.line(DiffLine l)
      : line = l,
        removed = null,
        added = null;

  _DiffItem.inline({required this.removed, required this.added}) : line = null;

  final DiffLine? line;
  final String? removed;
  final String? added;

  bool get isInline => line == null;
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
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class SideBySideCompare extends StatelessWidget {
  const SideBySideCompare({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.leftText,
    required this.rightText,
  });

  final String leftTitle;
  final String rightTitle;
  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _Pane(
            title: leftTitle,
            text: leftText,
            accent: p.textSecondary,
            border: p.textSecondary.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _Pane(
            title: rightTitle,
            text: rightText,
            accent: p.primary,
            border: p.primary.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _Pane extends StatelessWidget {
  const _Pane({
    required this.title,
    required this.text,
    required this.accent,
    required this.border,
  });

  final String title;
  final String text;
  final Color accent;
  final Color border;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(width: 4, height: 22, color: accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: p.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(height: 1.55, color: p.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
