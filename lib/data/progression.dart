import 'models/puzzle.dart';

/// One rung of the level ladder: a puzzle plus its unlock/solve state.
class PuzzleLevel {
  const PuzzleLevel({
    required this.puzzle,
    required this.index,
    required this.solved,
    required this.unlocked,
  });

  final Puzzle puzzle;

  /// 0-based position in the ladder.
  final int index;
  final bool solved;

  /// True when the player may play it now.
  final bool unlocked;

  /// 1-based label for display ("Level 3").
  int get levelNumber => index + 1;
}

/// Orders playable puzzles into the level ladder: by difficulty ascending, ties
/// broken by original order (stable). Coming-soon puzzles are excluded here —
/// they are surfaced separately as locked extras.
List<Puzzle> orderPuzzles(List<Puzzle> puzzles) {
  final playable = <Puzzle>[];
  for (final p in puzzles) {
    if (!p.comingSoon) playable.add(p);
  }
  // Stable sort by difficulty (List.sort isn't stable, so carry the index).
  final indexed = [
    for (var i = 0; i < playable.length; i++) (i, playable[i]),
  ];
  indexed.sort((a, b) {
    final byDifficulty = a.$2.difficulty.compareTo(b.$2.difficulty);
    return byDifficulty != 0 ? byDifficulty : a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}

/// How many levels beyond your solved count stay open at once. With a window,
/// a single brutal puzzle can never wall you — you can skip ahead and come back.
const int kUnlockAhead = 3;

/// Builds the level ladder from [puzzles] and the player's [solvedIds].
///
/// LENIENT unlock rule (deliberately robust to pack changes / refetches):
///   - a rolling window is always open: level `i` is unlocked when
///     `i <= solvedCount + kUnlockAhead` (so ~[kUnlockAhead]+1 are playable and
///     you may SKIP a fiendish one and try the next);
///   - a level that is ALREADY solved stays unlocked no matter what.
/// Because it keys off stable puzzle ids (not fixed positions), solving state is
/// never lost when the remote pack reorders or adds puzzles.
List<PuzzleLevel> buildLevels(List<Puzzle> puzzles, Set<String> solvedIds) {
  final ordered = orderPuzzles(puzzles);
  final solvedCount =
      ordered.where((p) => solvedIds.contains(p.id)).length;
  final levels = <PuzzleLevel>[];
  for (var i = 0; i < ordered.length; i++) {
    final solved = solvedIds.contains(ordered[i].id);
    levels.add(PuzzleLevel(
      puzzle: ordered[i],
      index: i,
      solved: solved,
      unlocked: solved || i <= solvedCount + kUnlockAhead,
    ));
  }
  return levels;
}

/// The level the player is currently on (1-based): the first unlocked, unsolved
/// rung, or the total count once everything is solved. 0 when there are none.
int currentLevelNumber(List<PuzzleLevel> levels) {
  for (final level in levels) {
    if (level.unlocked && !level.solved) return level.levelNumber;
  }
  return levels.length;
}
