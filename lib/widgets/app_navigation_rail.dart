import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import 'profile_coach_logo.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<(IconData icon, String label)> destinations;

  static const double width = 96;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: p.backgroundElevated,
        border: Border(
          right: BorderSide(
            color: p.textSecondary.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: ProfileCoachLogo(size: 40),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final d = destinations[index];
                  final selected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onSelected(index),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selected
                                ? p.primary.withValues(alpha: 0.14)
                                : Colors.transparent,
                            border: selected
                                ? Border.all(
                                    color: p.primary.withValues(alpha: 0.45),
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                d.$1,
                                size: 22,
                                color: selected ? p.primary : p.textSecondary,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                d.$2,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 1.2,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? p.textPrimary
                                      : p.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
