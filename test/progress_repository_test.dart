import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/models/puzzle_progress.dart';
import 'package:mindshift/data/providers.dart';
import 'package:mindshift/data/repositories/progress_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProgressRepository', () {
    test('fresh load returns empty progress', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ProgressRepository(prefs);

      final progress = repo.load();

      expect(progress.solvedIds, isEmpty);
      expect(progress.streak, 0);
      expect(progress.lastSolvedDay, isNull);
      expect(progress.solvedCount, 0);
    });

    test(
      'save then load round-trips solvedIds, streak and lastSolvedDay',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final repo = ProgressRepository(prefs);

        const saved = PuzzleProgress(
          solvedIds: {'a', 'b', 'c'},
          streak: 4,
          lastSolvedDay: 20000,
        );
        await repo.save(saved);

        // Load through a second repository over the same backing store to prove
        // the values were actually persisted, not just held in memory.
        final loaded = ProgressRepository(prefs).load();

        expect(loaded.solvedIds, {'a', 'b', 'c'});
        expect(loaded.streak, 4);
        expect(loaded.lastSolvedDay, 20000);
      },
    );

    test(
      'saving a null lastSolvedDay clears any previously stored value',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final repo = ProgressRepository(prefs);

        await repo.save(
          const PuzzleProgress(solvedIds: {'a'}, streak: 2, lastSolvedDay: 123),
        );
        await repo.save(const PuzzleProgress(solvedIds: {'a'}, streak: 2));

        final loaded = repo.load();
        expect(loaded.lastSolvedDay, isNull);
        expect(loaded.solvedIds, {'a'});
        expect(loaded.streak, 2);
      },
    );
  });

  group('nextStreak', () {
    test('same day keeps the streak unchanged', () {
      expect(nextStreak(lastSolvedDay: 100, today: 100, currentStreak: 5), 5);
    });

    test('a consecutive day advances the streak by one', () {
      expect(nextStreak(lastSolvedDay: 99, today: 100, currentStreak: 5), 6);
    });

    test('a gap resets the streak to one', () {
      expect(nextStreak(lastSolvedDay: 90, today: 100, currentStreak: 5), 1);
    });

    test('the first ever solve starts the streak at one', () {
      expect(nextStreak(lastSolvedDay: null, today: 100, currentStreak: 0), 1);
    });
  });

  group('dayOfEpoch', () {
    test('is date-only: two times on the same UTC day are equal', () {
      final morning = DateTime.utc(2026, 8, 19, 1, 2, 3);
      final evening = DateTime.utc(2026, 8, 19, 23, 59, 59);
      expect(dayOfEpoch(morning), dayOfEpoch(evening));
    });

    test('consecutive UTC days differ by exactly one', () {
      final day1 = DateTime.utc(2026, 8, 19, 8);
      final day2 = DateTime.utc(2026, 8, 20, 8);
      expect(dayOfEpoch(day2) - dayOfEpoch(day1), 1);
    });
  });
}
