import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindshift/core/router/app_router.dart';
import 'package:mindshift/core/theme/app_colors.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/core/widgets/calm_scaffold.dart';
import 'package:mindshift/core/widgets/soft_card.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/models/puzzle_category.dart';
import 'package:mindshift/data/models/puzzle_progress.dart';
import 'package:mindshift/data/providers.dart';

/// The home "shelf": a warm greeting, a deterministic daily puzzle hero, and a
/// calm grid of all puzzles. Coming-soon puzzles read as gently locked.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzles = ref.watch(puzzleRegistryProvider);
    final progress = ref.watch(progressProvider);

    // Prefer a playable puzzle for the hero; skip coming-soon when possible.
    final playable = puzzles.where((p) => !p.comingSoon).toList();
    final Puzzle? hero = playable.isEmpty
        ? null
        : playable[dayOfEpoch(DateTime.now()) % playable.length];

    return CalmScaffold(
      actions: [
        IconButton(
          tooltip: 'Your progress',
          icon: const Icon(Icons.insights_rounded),
          color: AppColors.textPrimary,
          onPressed: () => context.push(Routes.stats),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          const SizedBox(height: AppSpacing.sm),
          _Greeting(streak: progress.streak),
          const SizedBox(height: AppSpacing.xl),
          if (puzzles.isEmpty)
            const _EmptyState()
          else ...[
            if (hero != null) ...[
              const _SectionLabel('Daily puzzle'),
              const SizedBox(height: AppSpacing.md),
              _HeroCard(
                puzzle: hero,
                solved: progress.isSolved(hero.id),
                onTap: () => context.push(Routes.puzzlePath(hero.id)),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
            const _SectionLabel('All puzzles'),
            const SizedBox(height: AppSpacing.md),
            _PuzzleGrid(puzzles: puzzles, progress: progress),
          ],
        ],
      ),
    );
  }
}

/// Warm minimal header: the app name, a gentle subtitle, and — only when the
/// streak is alive — a soft streak pill.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MindShift',
          style: GoogleFonts.nunito(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'A little thinking, well spent.',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        if (streak > 0) ...[
          const SizedBox(height: AppSpacing.md),
          _StreakPill(streak: streak),
        ],
      ],
    );
  }
}

class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Text(
        '🔥 $streak-day streak',
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

/// A quiet section heading above the hero and the grid.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// The larger "daily puzzle" card. Always playable (heroes skip coming-soon).
class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.puzzle,
    required this.solved,
    required this.onTap,
  });

  final Puzzle puzzle;
  final bool solved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryChip(category: puzzle.category),
              const Spacer(),
              if (solved) const _SolvedBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            puzzle.title,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            puzzle.tagline,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _DifficultyDots(difficulty: puzzle.difficulty),
              const Spacer(),
              Row(
                children: [
                  Text(
                    solved ? 'Revisit' : 'Play',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Responsive grid: one column on narrow phones, two on wider screens.
class _PuzzleGrid extends StatelessWidget {
  const _PuzzleGrid({required this.puzzles, required this.progress});

  final List<Puzzle> puzzles;
  final PuzzleProgress progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        const gap = AppSpacing.md;
        final itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final p in puzzles)
              SizedBox(
                width: itemWidth,
                child: _PuzzleCard(puzzle: p, solved: progress.isSolved(p.id)),
              ),
          ],
        );
      },
    );
  }
}

/// A single puzzle tile. Coming-soon puzzles render greyed and are not tappable.
class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({required this.puzzle, required this.solved});

  final Puzzle puzzle;
  final bool solved;

  @override
  Widget build(BuildContext context) {
    final locked = puzzle.comingSoon;

    final card = SoftCard(
      color: locked ? AppColors.surfaceMuted : AppColors.surface,
      onTap: locked ? null : () => context.push(Routes.puzzlePath(puzzle.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryChip(category: puzzle.category, muted: locked),
              const Spacer(),
              if (locked)
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                )
              else if (solved)
                const _SolvedBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            puzzle.title,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: locked ? AppColors.textSecondary : AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            puzzle.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _DifficultyDots(difficulty: puzzle.difficulty, muted: locked),
              const Spacer(),
              if (locked)
                Text(
                  'Coming soon',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    return locked ? Opacity(opacity: 0.75, child: card) : card;
  }
}

/// A small colored chip naming the puzzle's category.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, this.muted = false});

  final PuzzleCategory category;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? AppColors.textSecondary : _categoryColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        category.label,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Five dots; the first [difficulty] are filled with the accent.
class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({required this.difficulty, this.muted = false});

  final int difficulty;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final filledColor = muted ? AppColors.textSecondary : AppColors.accent;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++) ...[
          if (i > 1) const SizedBox(width: AppSpacing.xs + 1),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= difficulty
                  ? filledColor
                  : AppColors.textSecondary.withValues(alpha: 0.22),
            ),
          ),
        ],
      ],
    );
  }
}

/// A gentle "solved" check, never competitive.
class _SolvedBadge extends StatelessWidget {
  const _SolvedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: const BoxDecoration(
        color: AppColors.accentSoft,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 16,
        color: AppColors.positive,
      ),
    );
  }
}

/// Calm placeholder shown when no puzzles are registered yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const Icon(Icons.spa_rounded, size: 40, color: AppColors.accent),
          const SizedBox(height: AppSpacing.md),
          Text(
            'New puzzles coming soon',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Take a breath. Fresh things to think about are on their way.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps a category to its calm accent color.
Color _categoryColor(PuzzleCategory category) {
  switch (category) {
    case PuzzleCategory.gameTheory:
      return AppColors.gameTheory;
    case PuzzleCategory.math:
      return AppColors.math;
    case PuzzleCategory.physics:
      return AppColors.physics;
    case PuzzleCategory.lateral:
      return AppColors.lateral;
  }
}
