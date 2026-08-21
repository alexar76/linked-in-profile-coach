enum DiffType { same, added, removed }

class DiffLine {
  const DiffLine(this.type, this.text);

  final DiffType type;
  final String text;
}

class WordSpan {
  const WordSpan(this.type, this.text);

  final DiffType type;
  final String text;
}

class TextDiff {
  static List<DiffLine> lineDiff(String oldText, String newText) {
    final a = oldText.split('\n');
    final b = newText.split('\n');
    final m = a.length;
    final n = b.length;

    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = m - 1; i >= 0; i--) {
      for (var j = n - 1; j >= 0; j--) {
        if (a[i] == b[j]) {
          dp[i][j] = dp[i + 1][j + 1] + 1;
        } else {
          dp[i][j] = dp[i + 1][j] > dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1];
        }
      }
    }

    final result = <DiffLine>[];
    var i = 0;
    var j = 0;
    while (i < m && j < n) {
      if (a[i] == b[j]) {
        result.add(DiffLine(DiffType.same, a[i]));
        i++;
        j++;
      } else if (dp[i + 1][j] >= dp[i][j + 1]) {
        result.add(DiffLine(DiffType.removed, a[i]));
        i++;
      } else {
        result.add(DiffLine(DiffType.added, b[j]));
        j++;
      }
    }
    while (i < m) {
      result.add(DiffLine(DiffType.removed, a[i++]));
    }
    while (j < n) {
      result.add(DiffLine(DiffType.added, b[j++]));
    }
    return result;
  }

  /// Word-level diff for two lines. Returns spans that can be rendered inline.
  static List<WordSpan> wordDiff(String oldLine, String newLine) {
    final a = _tokenize(oldLine);
    final b = _tokenize(newLine);
    final m = a.length;
    final n = b.length;

    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = m - 1; i >= 0; i--) {
      for (var j = n - 1; j >= 0; j--) {
        if (a[i] == b[j]) {
          dp[i][j] = dp[i + 1][j + 1] + 1;
        } else {
          dp[i][j] = dp[i + 1][j] > dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1];
        }
      }
    }

    final result = <WordSpan>[];
    var i = 0;
    var j = 0;
    while (i < m && j < n) {
      if (a[i] == b[j]) {
        result.add(WordSpan(DiffType.same, a[i]));
        i++;
        j++;
      } else if (dp[i + 1][j] >= dp[i][j + 1]) {
        result.add(WordSpan(DiffType.removed, a[i]));
        i++;
      } else {
        result.add(WordSpan(DiffType.added, b[j]));
        j++;
      }
    }
    while (i < m) {
      result.add(WordSpan(DiffType.removed, a[i++]));
    }
    while (j < n) {
      result.add(WordSpan(DiffType.added, b[j++]));
    }
    return result;
  }

  // Splits text into word tokens, preserving whitespace as separate tokens.
  static List<String> _tokenize(String text) {
    final tokens = <String>[];
    final pattern = RegExp(r'\S+|\s+');
    for (final m in pattern.allMatches(text)) {
      tokens.add(m.group(0)!);
    }
    return tokens;
  }

  static double similarityPercent(String a, String b) {
    if (a.trim().isEmpty && b.trim().isEmpty) return 100;
    if (a.trim().isEmpty || b.trim().isEmpty) return 0;
    final diff = lineDiff(a, b);
    final same = diff.where((d) => d.type == DiffType.same).length;
    final total = diff.length;
    if (total == 0) return 100;
    return (same / total * 100).clamp(0, 100);
  }
}
