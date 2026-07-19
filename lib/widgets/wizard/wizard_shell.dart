import 'package:flutter/material.dart';

import '../../theme/premium_theme.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';

class WizardShell extends StatelessWidget {
  const WizardShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stepIndex,
    required this.stepCount,
    required this.body,
    required this.onBack,
    required this.onNext,
    this.nextLabel,
    this.showBack = true,
    this.busy = false,
    this.leading,
  });

  final String title;
  final String subtitle;
  final int stepIndex;
  final int stepCount;
  final Widget body;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String? nextLabel;
  final bool showBack;
  final bool busy;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PremiumBackdrop(
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ?leading,
                  PremiumBadge(label: l10n.premiumBadge),
                  const Spacer(),
                  Text(
                    l10n.stepOf(stepIndex + 1, stepCount),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _StepDots(current: stepIndex, total: stepCount),
              const SizedBox(height: 32),
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final offset = Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(stepIndex),
                    child: body,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (showBack && onBack != null)
                    OutlinedButton(
                      onPressed: busy ? null : onBack,
                      child: Text(l10n.btnBack),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: busy ? null : onNext,
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(nextLabel ?? l10n.btnNext),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Row(
      children: List.generate(total, (i) {
        final active = i <= current;
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: active
                  ? LinearGradient(colors: [p.primaryDim, p.primary])
                  : null,
              color: active ? null : p.textSecondary.withValues(alpha: 0.15),
            ),
          ),
        );
      }),
    );
  }
}

class TemplateSelectCard extends StatelessWidget {
  const TemplateSelectCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? p.primary
                    : p.textSecondary.withValues(alpha: 0.15),
                width: selected ? 1.5 : 1,
              ),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        p.primary.withValues(alpha: 0.12),
                        p.surface,
                      ],
                    )
                  : null,
              color: selected ? null : p.surface,
            ),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? p.primary : p.textSecondary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
