// Perfect-play analysis of the single-pile take-away game (Nim).
//
// Kept separate + pure so it's unit-testable and shared by (a) the puzzle's
// answer (can the first player force a win?) and (b) the sandbox's perfect
// opponent. It never leaks strategy into the UI — the opponent simply plays
// optimally, and the player discovers "why" by experimenting.

/// Whether the player to move from [stones] can force a win with optimal play,
/// removing 1..[maxTake] per turn.
bool nimFirstPlayerWins({
  required int stones,
  required int maxTake,
  required bool lastTakeWins,
}) {
  if (stones <= 0) {
    // No stones to take: in normal play the mover has already lost (previous
    // player took the last stone and won); in misère the mover "wins".
    return !lastTakeWins;
  }
  final period = maxTake + 1;
  if (lastTakeWins) {
    return stones % period != 0;
  }
  // Misère: being left with exactly 1 stone is the losing spot.
  return (stones - 1) % period != 0;
}

/// The optimal number of stones for the current mover to remove from [stones].
/// Brute-forces against [nimFirstPlayerWins] so it is always consistent with the
/// win/lose analysis. Falls back to taking 1 from a losing position.
int nimOptimalTake({
  required int stones,
  required int maxTake,
  required bool lastTakeWins,
}) {
  final upper = stones < maxTake ? stones : maxTake;
  if (upper <= 0) return 0;

  int? forcedLastMisere;
  for (var take = 1; take <= upper; take++) {
    final remaining = stones - take;
    if (remaining == 0) {
      // Taking the last stone: great in normal play, fatal in misère.
      if (lastTakeWins) return take;
      forcedLastMisere = take;
      continue;
    }
    // Leave the opponent in a losing position.
    if (!nimFirstPlayerWins(
      stones: remaining,
      maxTake: maxTake,
      lastTakeWins: lastTakeWins,
    )) {
      return take;
    }
  }
  // No winning move — take the smallest legal amount that isn't self-defeating.
  return upper > 1 ? 1 : (forcedLastMisere ?? 1);
}
