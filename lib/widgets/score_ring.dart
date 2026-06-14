import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

class ScoreRing extends StatefulWidget {
  const ScoreRing({
    super.key,
    required this.score,
    required this.label,
    this.size = 120,
    this.subtitle,
  });

  final int score;
  final String label;
  final double size;
  final String? subtitle;

  @override
  State<ScoreRing> createState() => _ScoreRingState();
}

class _ScoreRingState extends State<ScoreRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(ScoreRing old) {
    super.didUpdateWidget(old);
    if (old.score != widget.score) {
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
    final p = context.palette;
    final clamped = widget.score.clamp(0, 100);
    final color = _scoreColor(clamped, p);

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final progress = _anim.value;
        final displayScore = (clamped * progress).round();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: (clamped / 100) * progress,
                  trackColor: p.textSecondary.withValues(alpha: 0.15),
                  progressColor: color,
                  strokeWidth: widget.size * 0.08,
                ),
                child: Center(
                  child: Text(
                    '$displayScore',
                    style: TextStyle(
                      fontSize: widget.size * 0.28,
                      fontWeight: FontWeight.w800,
                      color: p.textPrimary,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: p.textPrimary,
              ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: p.textSecondary),
              ),
            ],
          ],
        );
      },
    );
  }

  Color _scoreColor(int value, dynamic p) {
    if (value >= 75) return p.primary;
    if (value >= 50) return const Color(0xFFE8B84A);
    return Colors.redAccent.shade200;
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arc = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, track);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
