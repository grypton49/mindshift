import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// A physics-intuition puzzle proving the framework hosts a live simulation +
/// goal answer (balance the beam). The beam tilts truthfully from real torque;
/// the player discovers WHERE to place the weight — the app never says "balanced".
///
/// Left side: weight 4 at distance 3 -> torque 12. Right weight is 3, so it
/// balances at distance 4 (3 x 4 = 12), which is within maxDistance.
final Puzzle willItBalancePuzzle = Puzzle(
  id: 'will-it-balance',
  title: 'Will It Balance?',
  tagline: 'Slide the weight to find the balance point.',
  category: PuzzleCategory.physics,
  difficulty: 2,
  prompt:
      'A weight sits on the left of a balance beam. Slide the weight on the '
      'right until the beam settles level.',
  rules: const [
    'Drag the right-hand weight along the beam to change its distance.',
    'The beam tips according to real weight and distance — feel your way to level.',
  ],
  sandbox: const LeverSandboxSpec(
    leftWeight: 4,
    leftDistance: 3,
    rightWeight: 3,
    maxDistance: 5,
  ),
  answer: const GoalAnswerSpec(goalLabel: 'Balance the beam'),
  hints: const [
    'What makes one side dip — is it the weight, the distance, or both together?',
    'The left side is heavier but closer in. How could a lighter weight match it?',
  ],
  whyExplanation:
      'A beam balances when the turning effect (torque) is equal on both sides, '
      'and torque = weight x distance from the pivot. The left gives 4 x 3 = 12, '
      'so the lighter right weight of 3 must sit at distance 4 (3 x 4 = 12). A '
      'smaller weight can balance a larger one simply by sitting farther out.',
);
