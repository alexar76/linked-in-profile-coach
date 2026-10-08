import 'package:flutter/material.dart';

import 'theme_context.dart';

/// Full-screen gradient backdrop with soft animated glow orbs.
class PremiumBackdrop extends StatefulWidget {
  const PremiumBackdrop({super.key, required this.child});

  final Widget child;

  @override
  State<PremiumBackdrop> createState() => _PremiumBackdropState();
}

class _PremiumBackdropState extends State<PremiumBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_pulse.value);
        final glowA = 0.10 + t * 0.08;
        final glowB = 0.12 + (1 - t) * 0.06;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: p.backdropGradient,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -120,
                right: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        p.glowColor.withValues(alpha: glowA),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -40,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        p.accentOrb.withValues(alpha: glowB),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 80,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        p.primary.withValues(alpha: 0.04 + t * 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: p.primary.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [
            p.primary.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
