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

List<Puzzle> _ladder(int n) => [for (var i = 0; i < n; i++) _p('p$i', 5)];

void main() {
  test('with no progress, only the first rung is PLAYABLE (rest readable)', () {
    final levels = buildLevels(_ladder(10), {});
    expect(levels[0].unlocked, isTrue);
    for (var i = 1; i < levels.length; i++) {
      expect(levels[i].unlocked, isFalse, reason: 'level $i playable?');
    }
    expect(currentLevelNumber(levels), 1);
  });

  test('solving the current rung makes the next one playable', () {
    final levels = buildLevels(_ladder(10), {'p0'});
    expect(levels[0].solved, isTrue);
    expect(levels[0].unlocked, isTrue); // solved stays playable (replayable)
    expect(levels[1].unlocked, isTrue); // new frontier
    expect(levels[2].unlocked, isFalse);
    expect(currentLevelNumber(levels), 2);
  });

  test('every earlier rung stays playable', () {
    final levels = buildLevels(_ladder(10), {'p0', 'p1', 'p2'});
    for (var i = 0; i <= 3; i++) {
      expect(levels[i].unlocked, isTrue, reason: 'level $i');
    }
    expect(levels[4].unlocked, isFalse);
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
    test('solved puzzles stay solved & playable when new puzzles are added', () {
      final solved = {'a', 'b'};
      final after = [_p('d', 4), _p('a', 1), _p('c', 3), _p('b', 2)];
      final levels = buildLevels(after, solved);
      final byId = {for (final l in levels) l.puzzle.id: l};
      expect(byId['a']!.solved, isTrue);
      expect(byId['a']!.unlocked, isTrue);
      expect(byId['b']!.solved, isTrue);
      expect(byId['b']!.unlocked, isTrue);
      expect(byId['c']!.unlocked, isTrue); // frontier
      expect(levels.where((l) => l.solved).length, 2);
      expect(levels.map((l) => l.puzzle.id), ['a', 'b', 'c', 'd']);
    });
  });
}
