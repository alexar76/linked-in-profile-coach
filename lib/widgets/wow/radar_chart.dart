import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/wow/benchmark_result.dart';
import '../../theme/theme_context.dart';

/// Radar chart: you vs median per dimension (animated draw-in).
class BenchmarkRadarChart extends StatefulWidget {
  const BenchmarkRadarChart({
    super.key,
    required this.dimensions,
    this.size = 280,
  });

  final List<BenchmarkDimension> dimensions;
  final double size;

  @override
  State<BenchmarkRadarChart> createState() => _BenchmarkRadarChartState();
}

class _BenchmarkRadarChartState extends State<BenchmarkRadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(BenchmarkRadarChart old) {
    super.didUpdateWidget(old);
    if (old.dimensions != widget.dimensions) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dimensions.isEmpty) {
      return const SizedBox.shrink();
    }
    final palette = context.palette;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(
              dimensions: widget.dimensions,
              youColor: palette.primary,
              medianColor: palette.textSecondary.withValues(alpha: 0.5),
              gridColor: palette.textSecondary.withValues(alpha: 0.2),
              drawProgress: _progress.value,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.dimensions,
    required this.youColor,
    required this.medianColor,
    required this.gridColor,
    this.drawProgress = 1,
  });

  final List<BenchmarkDimension> dimensions;
  final Color youColor;
  final Color medianColor;
  final Color gridColor;
  final double drawProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final n = dimensions.length;
    if (n < 3) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    final t = drawProgress.clamp(0.0, 1.0);

    for (var ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4 * t;
      final path = Path();
      for (var i = 0; i < n; i++) {
        final angle = -math.pi / 2 + 2 * math.pi * i / n;
        final p = Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = gridColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    void drawPolygon(List<double> values, Color color, {double alpha = 0.35}) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final angle = -math.pi / 2 + 2 * math.pi * i / n;
        final v = (values[i].clamp(0.0, 1.0) * t);
        final p = Offset(
          center.dx + radius * v * math.cos(angle),
          center.dy + radius * v * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final youVals = dimensions.map((d) => d.youNorm).toList();
    final medVals = dimensions.map((d) => d.medianNorm).toList();
    drawPolygon(medVals, medianColor, alpha: 0.15);
    drawPolygon(youVals, youColor, alpha: 0.25);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.dimensions != dimensions || old.drawProgress != drawProgress;
}
