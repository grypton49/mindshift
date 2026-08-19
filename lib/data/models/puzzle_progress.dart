/// Immutable snapshot of the player's progress. Persisted via [ProgressRepository]
/// and exposed through `progressProvider`.
class PuzzleProgress {
  const PuzzleProgress({
    this.solvedIds = const {},
    this.streak = 0,
    this.lastSolvedDay,
  });

  /// Ids of puzzles the player has solved themselves.
  final Set<String> solvedIds;

  /// Consecutive-day solve streak (simple gamification, no punishment).
  final int streak;

  /// Day-of-epoch of the last solve (days since 1970), used to advance/reset the
  /// streak. Null when nothing has been solved yet.
  final int? lastSolvedDay;

  bool isSolved(String id) => solvedIds.contains(id);

  int get solvedCount => solvedIds.length;

  PuzzleProgress copyWith({
    Set<String>? solvedIds,
    int? streak,
    int? lastSolvedDay,
  }) {
    return PuzzleProgress(
      solvedIds: solvedIds ?? this.solvedIds,
      streak: streak ?? this.streak,
      lastSolvedDay: lastSolvedDay ?? this.lastSolvedDay,
    );
  }
}
