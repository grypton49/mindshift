import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindshift/core/router/app_router.dart';
import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/core/widgets/calm_scaffold.dart';
import 'package:mindshift/core/widgets/soft_card.dart';
import 'package:mindshift/data/models/puzzle_category.dart';
import 'package:mindshift/data/progression.dart';
import 'package:mindshift/data/providers.dart';

/// The home "journey": a warm greeting, a gentle sense of place ("Level X of N"),
/// and the level path — a connected, top-to-bottom sequence of level cards the
/// player climbs one rung at a time. Locked levels read as calm, not gated;
/// the current step is softly emphasized so there is always one clear next move.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider);
    final currentLevel = ref.watch(currentLevelProvider);
    final streak = ref.watch(progressProvider).streak;
    final avatar = ref.watch(profileProvider).avatar;

    final children = <Widget>[
      const SizedBox(height: AppSpacing.sm),
      _Greeting(
        streak: streak,
        currentLevel: currentLevel,
        totalLevels: levels.length,
      ),
      const SizedBox(height: AppSpacing.xl),
    ];

    if (levels.isEmpty) {
      children.add(const _EmptyState());
    } else {
      for (var i = 0; i < levels.length; i++) {
        if (i > 0) {
          children.add(_PathConnector(completed: levels[i - 1].solved));
        }
        children.add(
          _LevelCard(
            level: levels[i],
            isCurrent: levels[i].levelNumber == currentLevel,
          ),
        );
      }
    }

    return CalmScaffold(
      actions: [
        _AvatarButton(
          avatar: avatar,
          onTap: () => context.push(Routes.profile),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: children,
      ),
    );
  }
}

/// A circular, tappable avatar in the app bar showing the player's chosen emoji.
class _AvatarButton extends StatelessWidget {
  const _AvatarButton({required this.avatar, required this.onTap});

  final String avatar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Tooltip(
        message: 'Your profile',
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Text(avatar, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Warm minimal header: the app name, a gentle subtitle, and — when they apply —
/// a soft streak pill and a calm "Level X of N" indicator.
class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.streak,
    required this.currentLevel,
    required this.totalLevels,
  });

  final int streak;
  final int currentLevel;
  final int totalLevels;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MindShift',
          style: GoogleFonts.nunito(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: c.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your thinking journey, one level at a time.',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: c.textSecondary,
            height: 1.4,
          ),
        ),
        if (streak > 0 || totalLevels > 0) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (streak > 0) _StreakPill(streak: streak),
              if (totalLevels > 0)
                _LevelIndicator(current: currentLevel, total: totalLevels),
            ],
          ),
        ],
      ],
    );
  }
}

/// A soft, non-competitive streak pill. Only shown when the streak is alive.
class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Text(
        '🔥 $streak-day streak',
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: c.accent,
        ),
      ),
    );
  }
}

/// A quiet "you are here" marker for the path: Level X of N.
class _LevelIndicator extends StatelessWidget {
  const _LevelIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.route_rounded, size: 16, color: c.accent),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            'Level $current of $total',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// How a single rung renders. Precedence: locked > solved > current > open.
enum _LevelState { locked, current, solved, open }

/// A gentle vertical connector (three soft dots) drawn between level cards to
/// convey a continuous path. It reads as "walked" once the rung above is solved.
class _PathConnector extends StatelessWidget {
  const _PathConnector({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final color = completed
        ? c.accent.withValues(alpha: 0.5)
        : c.textSecondary.withValues(alpha: 0.25);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ],
        ],
      ),
    );
  }
}

/// One rung of the journey. Locked rungs are gently greyed and untappable;
/// the current rung wears a soft accent ring; solved rungs carry a check and
/// stay open for a revisit.
class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.isCurrent});

  final PuzzleLevel level;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final puzzle = level.puzzle;
    final state = !level.unlocked
        ? _LevelState.locked
        : level.solved
        ? _LevelState.solved
        : isCurrent
        ? _LevelState.current
        : _LevelState.open;
    final locked = state == _LevelState.locked;

    // Trailing action hint, tuned to the rung's state.
    String? actionLabel;
    var filledAction = false;
    switch (state) {
      case _LevelState.locked:
        actionLabel = null;
      case _LevelState.current:
        actionLabel = level.index == 0 ? 'Start' : 'Continue';
        filledAction = true;
      case _LevelState.solved:
        actionLabel = 'Revisit';
      case _LevelState.open:
        actionLabel = 'Play';
    }

    Widget card = SoftCard(
      color: locked ? c.surfaceMuted : c.surface,
      onTap: locked ? null : () => context.push(Routes.puzzlePath(puzzle.id)),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _NodeMarker(state: state, levelNumber: level.levelNumber),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${level.levelNumber}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: locked ? c.textSecondary : c.accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      puzzle.title,
                      style: GoogleFonts.nunito(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: locked ? c.textSecondary : c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: AppSpacing.sm),
                _ActionChip(label: actionLabel, filled: filledAction),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            puzzle.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _CategoryChip(category: puzzle.category, muted: locked),
              const Spacer(),
              _DifficultyDots(difficulty: puzzle.difficulty, muted: locked),
            ],
          ),
          if (locked) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: c.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Solve the level before to unlock.',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    // The current rung wears a soft accent ring so the next step is obvious.
    if (state == _LevelState.current) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          border: Border.all(color: c.accent, width: 2),
        ),
        child: card,
      );
    }

    return locked ? Opacity(opacity: 0.85, child: card) : card;
  }
}

/// The circular node on the path: a check when solved, the level number when
/// playable, and a lock when gated.
class _NodeMarker extends StatelessWidget {
  const _NodeMarker({required this.state, required this.levelNumber});

  final _LevelState state;
  final int levelNumber;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    const size = 40.0;

    switch (state) {
      case _LevelState.solved:
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, size: 20, color: c.onAccent),
        );
      case _LevelState.current:
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.accentSoft,
            shape: BoxShape.circle,
            border: Border.all(color: c.accent, width: 2),
          ),
          child: Text(
            '$levelNumber',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: c.accent,
            ),
          ),
        );
      case _LevelState.locked:
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: c.textSecondary,
          ),
        );
      case _LevelState.open:
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.surfaceMuted,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$levelNumber',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
        );
    }
  }
}

/// A small trailing chip: a filled accent call-to-action on the current rung,
/// a soft accent chip elsewhere.
class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: filled ? c.accent : c.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: filled ? c.onAccent : c.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.arrow_forward_rounded,
            size: 15,
            color: filled ? c.onAccent : c.accent,
          ),
        ],
      ),
    );
  }
}

/// A small colored chip naming the puzzle's category.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, this.muted = false});

  final PuzzleCategory category;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final color = muted ? c.textSecondary : _categoryColor(context, category);
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
    final c = context.palette;
    final filledColor = muted ? c.textSecondary : c.accent;
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
                  : c.textSecondary.withValues(alpha: 0.22),
            ),
          ),
        ],
      ],
    );
  }
}

/// Calm placeholder shown when the ladder has no levels yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(Icons.spa_rounded, size: 40, color: c.accent),
          const SizedBox(height: AppSpacing.md),
          Text(
            'New puzzles coming soon',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Take a breath. Fresh things to think about are on their way.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps a category to its calm accent color from the active [AppPalette].
Color _categoryColor(BuildContext context, PuzzleCategory category) {
  final c = context.palette;
  switch (category) {
    case PuzzleCategory.gameTheory:
      return c.gameTheory;
    case PuzzleCategory.math:
      return c.math;
    case PuzzleCategory.physics:
      return c.physics;
    case PuzzleCategory.lateral:
      return c.lateral;
  }
}
