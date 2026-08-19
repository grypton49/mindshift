import '../models/puzzle.dart';
import '../models/puzzle_category.dart';
import 'tigers_puzzle.dart' show sheepSurvives;

/// Additional, harder puzzles that reuse the existing sandbox mechanics — so
/// they ship purely as data (and can also be added later via the remote pack).

/// Harder subset-sum: a bigger set, a target with fewer obvious combinations.
final Puzzle makeTheTargetTwo = Puzzle(
  id: 'make-the-target-2',
  title: 'Make the Target II',
  tagline: 'A trickier total — more tiles, fewer obvious paths.',
  category: PuzzleCategory.math,
  difficulty: 3,
  prompt:
      'Add some of the tiles so the total lands exactly on the target. Each tile '
      'can be used at most once.',
  rules: const [
    'Tap a tile to move it in or out of the tray.',
    'The running total updates as you go — reach the target exactly.',
  ],
  sandbox: const NumberTilesSandboxSpec(
    tiles: [4, 6, 9, 13, 17],
    target: 30,
  ),
  answer: const ReachTargetAnswerSpec(target: 30),
  hints: const [
    'Which pair of the larger tiles gets you close?',
    'If you commit to the biggest tile, what exact amount is left to make?',
  ],
  whyExplanation:
      'One clean route is 13 + 17 = 30; another is 4 + 9 + 17 = 30. As the set '
      'grows, the number of possible combinations explodes — which is exactly why '
      '"subset sum" is hard for computers at scale, even though a few tiles are '
      'easy for a person to eyeball.',
);

/// Hardest subset-sum in the ladder: six tiles, a target needing three of them.
final Puzzle makeTheTargetThree = Puzzle(
  id: 'make-the-target-3',
  title: 'Make the Target III',
  tagline: 'Six tiles, one exact total. Find the trio.',
  category: PuzzleCategory.math,
  difficulty: 5,
  prompt:
      'Add some of the tiles so the total lands exactly on the target. Each tile '
      'can be used at most once.',
  rules: const [
    'Tap a tile to move it in or out of the tray.',
    'The running total updates as you go — reach the target exactly.',
  ],
  sandbox: const NumberTilesSandboxSpec(
    tiles: [3, 7, 12, 19, 26, 34],
    target: 52,
  ),
  answer: const ReachTargetAnswerSpec(target: 52),
  hints: const [
    'Is the target closer to two big tiles or three medium ones?',
    'Try fixing the largest tile you might use, then solve what remains.',
  ],
  whyExplanation:
      'For example 7 + 19 + 26 = 52. With six tiles there are dozens of subsets '
      'to consider — a person prunes them with intuition, but a computer may have '
      'to check exponentially many. That gap is the whole point of the puzzle.',
);

/// Harder balance: a heavier, closer-in left side that needs the light weight
/// pushed right out to the end.
final Puzzle willItBalanceTwo = Puzzle(
  id: 'will-it-balance-2',
  title: 'Balance II',
  tagline: 'Heavier on the left — how far out must the light weight go?',
  category: PuzzleCategory.physics,
  difficulty: 4,
  prompt:
      'A heavier weight sits close to the pivot on the left. Slide the lighter '
      'weight on the right until the beam settles level.',
  rules: const [
    'Drag the right-hand weight along the beam to change its distance.',
    'The beam tips according to real weight and distance — feel your way to level.',
  ],
  sandbox: const LeverSandboxSpec(
    leftWeight: 5,
    leftDistance: 3,
    rightWeight: 3,
    maxDistance: 6,
  ),
  answer: const GoalAnswerSpec(goalLabel: 'Balance the beam'),
  hints: const [
    'The left turning effect is weight times distance. What number is that?',
    'The right weight is smaller — so its distance has to be correspondingly larger.',
  ],
  whyExplanation:
      'Torque = weight x distance. The left side is 5 x 3 = 15, so the right '
      'weight of 3 must sit at distance 5 (3 x 5 = 15). The lighter the weight, '
      'the farther out it must go to match.',
);

/// A twist on the flagship: does the parity conclusion flip for 99 tigers?
final Puzzle tigersNinetyNine = Puzzle(
  id: 'tigers-and-sheep-99',
  title: 'Tigers & Sheep: 99',
  tagline: 'Same island, one fewer tiger. Does the answer flip?',
  category: PuzzleCategory.gameTheory,
  difficulty: 4,
  prompt:
      'Same rules as before — a tiger that eats the sheep becomes a sheep, and '
      'every tiger is perfectly logical and wants to survive.\n\n'
      'This time there are 99 tigers. Is the sheep safe, or eaten?',
  rules: const [
    'Any tiger may eat the sheep — but eating it turns the eater into a sheep.',
    'A newly-made sheep can then be eaten by any remaining tiger.',
    'Every tiger reasons flawlessly and, above all, wants to survive.',
  ],
  sandbox: const TigersSandboxSpec(
    minTigers: 1,
    maxTigers: 12,
    questionTigers: 99,
  ),
  answer: BinaryAnswerSpec(
    question: 'With 99 tigers, is the sheep…',
    optionA: 'Safe',
    optionB: 'Eaten',
    correctIsA: sheepSurvives(99),
  ),
  hints: const [
    'You found the rule for 100. What was it about the number that mattered?',
    'Is 99 the same kind of number as 100, or the opposite?',
  ],
  whyExplanation:
      'The sheep is safe exactly when the number of tigers is even, because each '
      'tiger only eats if doing so leaves the remaining tigers in a "sheep is '
      'safe" position. 99 is odd — so one tiger safely eats, and the sheep is '
      'eaten. Dropping a single tiger flips the outcome.',
);
