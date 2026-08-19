import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// A gentle math playground proving the framework hosts a different category +
/// mechanic (number tiles + reach-target answer). The sandbox only shows the
/// running total; the player works out which tiles reach the target themselves.
final Puzzle makeTheTargetPuzzle = Puzzle(
  id: 'make-the-target',
  title: 'Make the Target',
  tagline: 'Pick the right tiles to land exactly on the number.',
  category: PuzzleCategory.math,
  difficulty: 1,
  prompt:
      'You have a handful of number tiles. Add some of them together so the '
      'total lands exactly on the target. Each tile can be used at most once.',
  rules: const [
    'Tap a tile to move it in or out of the tray.',
    'The running total updates as you go — reach the target exactly.',
  ],
  sandbox: const NumberTilesSandboxSpec(
    tiles: [2, 3, 5, 7, 9],
    target: 17,
  ),
  answer: const ReachTargetAnswerSpec(target: 17),
  hints: const [
    'Which single tile gets you closest to 17 without going over?',
    'If you start from the largest tile, how much is left to make up?',
  ],
  whyExplanation:
      'Reaching an exact total is a small taste of the "subset sum" problem: '
      'from a set of numbers, find a group that adds to a goal. Here, 3 + 5 + 9 '
      '= 17. With only a few tiles you can reason it out by hand; with hundreds, '
      'it becomes one of computer science\'s famously hard problems.',
);
