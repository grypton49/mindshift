import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/models/puzzle_category.dart';
import 'package:mindshift/data/progression.dart';

Puzzle _p(String id, int difficulty, {bool comingSoon = false}) => Puzzle(
      id: id,
      title: id,
      tagline: '',
      category: PuzzleCategory.math,
      difficulty: difficulty,
      prompt: '',
      sandbox: const ReasoningSandboxSpec(),
      answer: const NumberEntryAnswerSpec(answer: 1),
      comingSoon: comingSoon,
    );

List<Puzzle> _ladder(int n) =>
    [for (var i = 0; i < n; i++) _p('p$i', 5)];

void main() {
  test('a rolling window is open from the start (lenient unlock)', () {
    final levels = buildLevels(_ladder(10), {});
    for (var i = 0; i < levels.length; i++) {
      expect(levels[i].unlocked, i <= kUnlockAhead,
          reason: 'level $i unlocked?');
    }
    expect(currentLevelNumber(levels), 1);
  });

  test('solving advances the window; solved levels stay unlocked', () {
    final levels = buildLevels(_ladder(10), {'p0'});
    expect(levels[0].solved, isTrue);
    // solvedCount = 1 → indices 0..(1+kUnlockAhead) unlocked.
    for (var i = 0; i < levels.length; i++) {
      expect(levels[i].unlocked, i <= 1 + kUnlockAhead);
    }
    expect(currentLevelNumber(levels), 2);
  });

  test('a fiendish level can be SKIPPED (unlock is not consecutive)', () {
    // Solve p2 without solving p0/p1: the window still advances by count.
    final levels = buildLevels(_ladder(10), {'p2'});
    expect(levels[2].solved, isTrue);
    expect(levels[2].unlocked, isTrue);
    // Unsolved neighbours inside the window remain playable.
    expect(levels[0].unlocked, isTrue);
    expect(levels[1].unlocked, isTrue);
  });

  test('levels are ordered by difficulty then input order', () {
    final levels = buildLevels([_p('hard', 5), _p('easy', 1), _p('mid', 3)], {});
    expect(levels.map((l) => l.puzzle.id), ['easy', 'mid', 'hard']);
  });

  test('coming-soon puzzles are excluded from the ladder', () {
    final levels =
        buildLevels([_p('a', 1), _p('soon', 2, comingSoon: true)], {});
    expect(levels.map((l) => l.puzzle.id), ['a']);
  });

  group('DATA SAFETY: a pack refetch never loses progress', () {
    test('solved puzzles stay solved & unlocked when new puzzles are added', () {
      final solved = {'a', 'b'};
      // A refetch that adds harder puzzles + reorders.
      final after = [_p('d', 4), _p('a', 1), _p('c', 3), _p('b', 2)];
      final levels = buildLevels(after, solved);
      final byId = {for (final l in levels) l.puzzle.id: l};
      expect(byId['a']!.solved, isTrue);
      expect(byId['a']!.unlocked, isTrue);
      expect(byId['b']!.solved, isTrue);
      expect(byId['b']!.unlocked, isTrue);
      expect(levels.where((l) => l.solved).length, 2);
      expect(levels.map((l) => l.puzzle.id), ['a', 'b', 'c', 'd']);
    });
  });
}
