import 'package:flutter/material.dart';

import '../../repositories/app_repository.dart';
import '../../theme/theme_context.dart';
import '../../utils/l10n_ext.dart';
import '../../utils/premium_transitions.dart';
import '../../widgets/premium/staggered_entrance.dart';
import 'benchmark_screen.dart';
import 'career_what_if_screen.dart';
import 'headline_ab_screen.dart';
import 'job_fit_screen.dart';
import 'recruiter_simulator_screen.dart';

class WowHubScreen extends StatelessWidget {
  const WowHubScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    final tiles = [
      _WowTile(
        icon: Icons.record_voice_over_outlined,
        title: l10n.wowRecruiterTitle,
        subtitle: l10n.wowRecruiterSubtitle,
        color: const Color(0xFF0D9488),
        screen: RecruiterSimulatorScreen(repo: repo),
      ),
      _WowTile(
        icon: Icons.work_outline,
        title: l10n.wowJobFitTitle,
        subtitle: l10n.wowJobFitSubtitle,
        color: const Color(0xFF2563EB),
        screen: JobFitScreen(repo: repo),
      ),
      _WowTile(
        icon: Icons.timeline_outlined,
        title: l10n.wowCareerTitle,
        subtitle: l10n.wowCareerSubtitle,
        color: const Color(0xFF7C3AED),
        screen: CareerWhatIfScreen(repo: repo),
      ),
      _WowTile(
        icon: Icons.leaderboard_outlined,
        title: l10n.wowHeadlineAbTitle,
        subtitle: l10n.wowHeadlineAbSubtitle,
        color: const Color(0xFFD97706),
        screen: HeadlineAbScreen(repo: repo),
      ),
      _WowTile(
        icon: Icons.radar_outlined,
        title: l10n.wowBenchmarkTitle,
        subtitle: l10n.wowBenchmarkSubtitle,
        color: const Color(0xFFDB2777),
        screen: BenchmarkScreen(repo: repo),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        StaggeredEntrance(
          children: [
            Text(
              l10n.wowHubTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.wowHubSubtitle,
              style: TextStyle(color: palette.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ...tiles.map((t) => _WowCard(tile: t)),
          ],
        ),
      ],
    );
  }
}

class _WowTile {
  const _WowTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.screen,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget screen;
}

class _WowCard extends StatelessWidget {
  const _WowCard({required this.tile});

  final _WowTile tile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _WowCardAnimated(
        accent: tile.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
          premiumPageRoute(tile.screen),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: tile.color.withValues(alpha: 0.2),
                child: Icon(tile.icon, color: tile.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tile.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.palette.textSecondary),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _WowCardAnimated extends StatefulWidget {
  const _WowCardAnimated({required this.accent, required this.child});

  final Color accent;
  final Widget child;

  @override
  State<_WowCardAnimated> createState() => _WowCardAnimatedState();
}

class _WowCardAnimatedState extends State<_WowCardAnimated> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: widget.accent.withValues(alpha: _hover ? 0.14 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.accent.withValues(alpha: _hover ? 0.45 : 0.2),
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.accent.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
