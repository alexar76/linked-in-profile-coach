import 'package:flutter/material.dart';

import '../../models/dashboard_analytics.dart';
import '../../theme/theme_context.dart';

/// Minimal line chart for dashboard trends (no external chart package).
class TrendChart extends StatefulWidget {
  const TrendChart({
    super.key,
    required this.points,
    required this.lineColor,
    this.height = 120,
    this.fillGradient,
  });

  final List<TrendPoint> points;
  final Color lineColor;
  final double height;
  final List<Color>? fillGradient;

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(TrendChart old) {
    super.didUpdateWidget(old);
    if (old.points != widget.points) {
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
    if (widget.points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            '—',
            style: TextStyle(color: context.palette.textSecondary),
          ),
        ),
      );
    }

    if (widget.points.length == 1) {
      return SizedBox(
        height: widget.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 48,
                  height: widget.height * 0.55,
                  decoration: BoxDecoration(
                    color: widget.lineColor.withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(
          painter: _TrendChartPainter(
            points: widget.points,
            lineColor: widget.lineColor,
            fillColors: widget.fillGradient ??
                [
                  widget.lineColor.withValues(alpha: 0.35),
                  widget.lineColor.withValues(alpha: 0.02),
                ],
            drawProgress: _anim.value,
          ),
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({
    required this.points,
    required this.lineColor,
    required this.fillColors,
    this.drawProgress = 1.0,
  });

  final List<TrendPoint> points;
  final Color lineColor;
  final List<Color> fillColors;
  final double drawProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.map((p) => p.value).toList();
    var minV = values.reduce((a, b) => a < b ? a : b);
    var maxV = values.reduce((a, b) => a > b ? a : b);
    if (maxV - minV < 0.001) {
      minV -= 1;
      maxV += 1;
    }

    // Clip drawing to the animated progress width
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(0, 0, size.width * drawProgress.clamp(0.0, 1.0), size.height),
    );

    final path = Path();
    final fill = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * (i / (points.length - 1));
      final t = (points[i].value - minV) / (maxV - minV);
      final y = size.height - t * size.height * 0.88 - size.height * 0.06;
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: fillColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fill, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Draw endpoint dot only when fully drawn
    if (drawProgress >= 0.98) {
      final dotPaint = Paint()..color = lineColor;
      final lastX = size.width;
      final lastT = (points.last.value - minV) / (maxV - minV);
      final lastY =
          size.height - lastT * size.height * 0.88 - size.height * 0.06;
      canvas.drawCircle(Offset(lastX, lastY), 4, dotPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter old) =>
      old.points != points ||
      old.lineColor != lineColor ||
      old.drawProgress != drawProgress;
}
