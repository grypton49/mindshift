import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/core/widgets/calm_scaffold.dart';
import 'package:mindshift/core/widgets/insight_card.dart';
import 'package:mindshift/core/widgets/soft_card.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/providers.dart';

/// A gentle, non-competitive progress screen: how many puzzles the player has
/// solved, their current streak, and a soft list of what they've cracked.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzles = ref.watch(puzzleRegistryProvider);
    final progress = ref.watch(progressProvider);

    final total = puzzles.length;
    final solved = progress.solvedCount;
    final fraction = total == 0 ? 0.0 : (solved / total).clamp(0.0, 1.0);
    final solvedPuzzles = puzzles
        .where((p) => progress.isSolved(p.id))
        .toList();

    return CalmScaffold(
      title: 'Your progress',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        children: [
          _SummaryCard(solved: solved, total: total, fraction: fraction),
          const SizedBox(height: AppSpacing.md),
          _StreakCard(streak: progress.streak),
          const SizedBox(height: AppSpacing.lg),
          if (total == 0)
            const InsightCard(
              icon: Icons.spa_rounded,
              title: 'Nothing to measure yet',
              text:
                  'Puzzles are on their way. Your progress will gather here, '
                  'gently, as you play.',
            )
          else if (solvedPuzzles.isEmpty)
            const InsightCard(
              icon: Icons.self_improvement_rounded,
              title: 'A fresh start',
              text:
                  'No pressure — pick whatever looks interesting and enjoy '
                  'the thinking. Solved puzzles will appear here.',
            )
          else
            _SolvedList(solved: solvedPuzzles),
        ],
      ),
    );
  }
}

/// The big calm headline: solved count out of total plus a soft progress bar.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.solved,
    required this.total,
    required this.fraction,
  });

  final int solved;
  final int total;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Puzzles solved',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$solved',
                style: GoogleFonts.nunito(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: c.accent,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'of $total',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 10,
              backgroundColor: c.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(c.accent),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _encouragement(solved, total),
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _encouragement(int solved, int total) {
    if (total == 0) return 'New puzzles are on their way.';
    if (solved == 0) return 'Every puzzle starts with a single thought.';
    if (solved >= total) {
      return 'You have explored them all — beautifully done.';
    }
    return 'Lovely progress. Enjoy the next one whenever you like.';
  }
}

/// A soft streak card — celebratory, never punishing when the streak is zero.
class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final active = streak > 0;
    return SoftCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: c.accentSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              active ? '🔥' : '🌱',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  active ? '$streak-day streak' : 'No streak yet',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  active
                      ? 'Nice rhythm. Come back tomorrow to keep it going.'
                      : 'Solve a puzzle any day to begin one.',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A warm list of the puzzles the player has solved, by title.
class _SolvedList extends StatelessWidget {
  const _SolvedList({required this.solved});

  final List<Puzzle> solved;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            'Solved so far',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SoftCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            children: [
              for (var i = 0; i < solved.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, thickness: 1, color: c.surfaceMuted),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 20,
                        color: c.positive,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          solved[i].title,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        solved[i].category.label,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
