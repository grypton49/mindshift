import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import 'models/puzzle.dart';
import 'models/puzzle_progress.dart';
import 'puzzles/puzzle_registry.dart';
import 'repositories/progress_repository.dart';
import 'repositories/puzzle_cache.dart';
import 'repositories/puzzle_remote_source.dart';
import 'repositories/puzzle_repository.dart';

/// Riverpod wiring. Agent C (data & persistence) owns this file. The provider
/// NAMES and types here are the contract other features import — keep them
/// stable.

/// Overridden in `main.dart` with the resolved [SharedPreferences] instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(ref.watch(sharedPreferencesProvider)),
);

/// Remote source for the hosted puzzle pack (GitHub raw JSON). Its own provider
/// so tests can override it with a fake — and so the app makes zero network
/// calls until a URL is configured in [AppConfig].
final puzzleRemoteSourceProvider = Provider<PuzzleRemoteSource>(
  (ref) => PuzzleRemoteSource(
    url: AppConfig.puzzlePackUrl,
    timeout: AppConfig.remoteFetchTimeout,
  ),
);

final puzzleCacheProvider = Provider<PuzzleCache>(
  (ref) => PuzzleCache(ref.watch(sharedPreferencesProvider)),
);

final puzzleRepositoryProvider = Provider<PuzzleRepository>(
  (ref) => PuzzleRepository(
    remoteSource: ref.watch(puzzleRemoteSourceProvider),
    cache: ref.watch(puzzleCacheProvider),
    fallback: puzzleRegistry,
  ),
);

/// All puzzles. Backed by [PuzzleController]: starts with the best locally
/// available content (cache, else bundled fallback) for an instant first paint,
/// then refreshes from the remote pack in the background. The exposed VALUE is
/// still a `List<Puzzle>`, so every existing reader is unchanged.
final puzzleRegistryProvider =
    StateNotifierProvider<PuzzleController, List<Puzzle>>(
      (ref) => PuzzleController(ref.watch(puzzleRepositoryProvider)),
    );

class PuzzleController extends StateNotifier<List<Puzzle>> {
  PuzzleController(this._repo) : super(_repo.initial()) {
    refresh();
  }

  final PuzzleRepository _repo;

  /// Pulls the latest remote pack; updates state only if the fetch succeeds.
  Future<void> refresh() async {
    final latest = await _repo.refresh();
    if (latest != null && mounted) state = latest;
  }
}

/// Look up a single puzzle by id (null if absent).
final puzzleByIdProvider = Provider.family<Puzzle?, String>((ref, id) {
  for (final p in ref.watch(puzzleRegistryProvider)) {
    if (p.id == id) return p;
  }
  return null;
});

/// Player progress (solved set + streak). Call `.markSolved(id)` on solve.
final progressProvider =
    StateNotifierProvider<ProgressController, PuzzleProgress>(
      (ref) => ProgressController(ref.watch(progressRepositoryProvider)),
    );

/// Day-of-epoch (days since 1970-01-01 UTC) for [when], date-only. Extracted so
/// the streak math elsewhere stays independent of wall-clock time in tests.
int dayOfEpoch(DateTime when) {
  final utc = when.toUtc();
  final dateOnly = DateTime.utc(utc.year, utc.month, utc.day);
  return dateOnly.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
}

/// Pure streak advancement, no clock. Given the previously stored
/// [lastSolvedDay] (null when nothing has been solved yet), [today]'s
/// day-of-epoch, and the [currentStreak], returns the streak after a solve
/// registered today:
///
///  - same day as last solve      -> unchanged
///  - the day right after         -> +1
///  - a gap, or the first ever    -> reset to 1
int nextStreak({
  required int? lastSolvedDay,
  required int today,
  required int currentStreak,
}) {
  if (lastSolvedDay == today) return currentStreak;
  if (lastSolvedDay == today - 1) return currentStreak + 1;
  return 1;
}

class ProgressController extends StateNotifier<PuzzleProgress> {
  ProgressController(this._repo) : super(_repo.load());

  final ProgressRepository _repo;

  /// Marks [puzzleId] solved, advances the day streak, and persists.
  ///
  /// Idempotent: if the puzzle is already solved this is a no-op — no double
  /// counting and no streak bump. Otherwise the streak advances per
  /// [nextStreak] against today's day-of-epoch and `lastSolvedDay` is set to
  /// today.
  Future<void> markSolved(String puzzleId) async {
    if (state.isSolved(puzzleId)) return;

    final today = dayOfEpoch(DateTime.now());
    state = state.copyWith(
      solvedIds: {...state.solvedIds, puzzleId},
      streak: nextStreak(
        lastSolvedDay: state.lastSolvedDay,
        today: today,
        currentStreak: state.streak,
      ),
      lastSolvedDay: today,
    );
    await _repo.save(state);
  }
}
