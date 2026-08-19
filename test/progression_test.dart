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
      sandbox: const NumberTilesSandboxSpec(tiles: [1, 2], target: 3),
      answer: const ReachTargetAnswerSpec(target: 3),
      comingSoon: comingSoon,
    );

void main() {
  test('only the first level is unlocked with no progress', () {
    final levels = buildLevels([_p('a', 1), _p('b', 2), _p('c', 3)], {});
    expect(levels.map((l) => l.unlocked), [true, false, false]);
    expect(currentLevelNumber(levels), 1);
  });

  test('solving a level unlocks the next; solved levels stay unlocked', () {
    final levels = buildLevels([_p('a', 1), _p('b', 2), _p('c', 3)], {'a'});
    expect(levels[0].solved, isTrue);
    expect(levels.map((l) => l.unlocked), [true, true, false]);
    expect(currentLevelNumber(levels), 2);
  });

  test('levels are ordered by difficulty regardless of input order', () {
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

      // Simulate a refetch that adds two harder puzzles + reorders.
      final after = [_p('d', 4), _p('a', 1), _p('c', 3), _p('b', 2)];
      final levels = buildLevels(after, solved);

      final byId = {for (final l in levels) l.puzzle.id: l};
      // Previously solved levels remain solved AND unlocked.
      expect(byId['a']!.solved, isTrue);
      expect(byId['a']!.unlocked, isTrue);
      expect(byId['b']!.solved, isTrue);
      expect(byId['b']!.unlocked, isTrue);
      // A brand-new level after a solved one is unlocked (its predecessor 'b'
      // is solved), while the hardest new one waits its turn.
      expect(byId['c']!.unlocked, isTrue); // ordered right after 'b'
      // Nothing about adding content erased the two original solves.
      expect(levels.where((l) => l.solved).length, 2);

      // Order is still purely by difficulty (a<b<c<d).
      expect(levels.map((l) => l.puzzle.id), ['a', 'b', 'c', 'd']);
    });
  });
}
