import 'package:flutter/material.dart';

import '../../theme/theme_context.dart';

class DashboardKpi extends StatelessWidget {
  const DashboardKpi({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.delta,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accent;
  final int? delta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.palette.textSecondary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 22),
              const Spacer(),
              if (delta != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (delta! >= 0
                            ? const Color(0xFF166534)
                            : const Color(0xFF9A3412))
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${delta! >= 0 ? '+' : ''}$delta%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: delta! >= 0
                          ? const Color(0xFF166534)
                          : const Color(0xFF9A3412),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _AnimatedValue(value: value, accent: accent, context: context),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: context.palette.textSecondary,
              fontSize: 13,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: TextStyle(
                color: context.palette.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnimatedValue extends StatelessWidget {
  const _AnimatedValue({
    required this.value,
    required this.accent,
    required this.context,
  });

  final String value;
  final Color accent;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final style = Theme.of(ctx).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: ctx.palette.textPrimary,
        );

    final parsed = _parseAnimatable(value);
    if (parsed == null) {
      return Text(value, style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: parsed.$1.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(
        '${v.round()}${parsed.$2}',
        style: style,
      ),
    );
  }

  // Returns (numericTarget, suffix) if the value string is animatable.
  (int, String)? _parseAnimatable(String v) {
    final asInt = int.tryParse(v);
    if (asInt != null) return (asInt, '');

    if (v.endsWith('%')) {
      final n = int.tryParse(v.substring(0, v.length - 1));
      if (n != null) return (n, '%');
    }

    return null;
  }
}
