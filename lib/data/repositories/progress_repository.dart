import 'package:shared_preferences/shared_preferences.dart';

import '../models/puzzle_progress.dart';

/// Persists [PuzzleProgress] to [SharedPreferences]. Agent C (data &
/// persistence) owns this file. Keys and method signatures below are the
/// contract other agents rely on.
class ProgressRepository {
  ProgressRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kSolved = 'mindshift.solvedIds';
  static const _kStreak = 'mindshift.streak';
  static const _kLastDay = 'mindshift.lastSolvedDay';

  /// Reads the persisted progress. Missing keys degrade gracefully to an empty
  /// [PuzzleProgress] (no solves, streak 0, no last-solved day).
  PuzzleProgress load() {
    return PuzzleProgress(
      solvedIds: (_prefs.getStringList(_kSolved) ?? const <String>[]).toSet(),
      streak: _prefs.getInt(_kStreak) ?? 0,
      lastSolvedDay: _prefs.getInt(_kLastDay),
    );
  }

  /// Persists [progress]. When [PuzzleProgress.lastSolvedDay] is null the stored
  /// key is removed so a cleared value never lingers, keeping [load] a faithful
  /// round-trip.
  Future<void> save(PuzzleProgress progress) async {
    await _prefs.setStringList(_kSolved, progress.solvedIds.toList());
    await _prefs.setInt(_kStreak, progress.streak);
    final lastSolvedDay = progress.lastSolvedDay;
    if (lastSolvedDay != null) {
      await _prefs.setInt(_kLastDay, lastSolvedDay);
    } else {
      await _prefs.remove(_kLastDay);
    }
  }
}
