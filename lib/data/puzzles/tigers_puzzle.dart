import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// ============================================================================
/// "Tigers & Sheep" — pure logic + pure data.
///
/// The rule of the puzzle lives in ONE place: [sheepSurvives]. Nothing in the
/// player-facing data (prompt, rules, hints) states the parity rule or walks
/// through a base case. The reasoning is revealed only via [Puzzle.whyExplanation],
/// which the host screen shows AFTER the player has solved it.
/// ============================================================================

/// Whether the sheep survives with [tigers] perfectly-logical tigers present.
///
/// This is the single source of truth for the puzzle's correctness. It is pure
/// and testable, and is deliberately terse so the reasoning is NOT spelled out
/// anywhere the player can read before solving.
bool sheepSurvives(int tigers) => tigers.isEven;

/// Convenience inverse of [sheepSurvives].
bool sheepEaten(int tigers) => tigers.isOdd;

/// The flagship puzzle definition. Pure data — no reasoning leaks into the
/// prompt, rules, or hints.
final Puzzle tigersPuzzle = Puzzle(
  id: 'tigers-and-sheep',
  title: 'Tigers & Sheep',
  tagline: '100 hungry, flawless logicians and one very nervous sheep.',
  category: PuzzleCategory.gameTheory,
  difficulty: 3,
  prompt:
      'On an island live 100 tigers and 1 sheep. Any tiger may eat the sheep — '
      'but the moment a tiger eats it, that tiger turns into a sheep, and can '
      'then be eaten by another tiger.\n\n'
      'Every tiger is perfectly logical and, above all else, wants to stay '
      'alive. No tiger will make a move that gets itself eaten.\n\n'
      'With 100 tigers, does the sheep get eaten, or is it safe?',
  rules: const [
    'Any tiger may eat the sheep — but eating it turns the eater into a sheep.',
    'A newly-made sheep can then be eaten by any remaining tiger.',
    'Every tiger is perfectly logical and reasons flawlessly.',
    'Above all, each tiger wants to survive; it never makes a move that leaves '
        'it exposed to being eaten.',
  ],
  sandbox: const TigersSandboxSpec(
    minTigers: 1,
    maxTigers: 12,
    questionTigers: 100,
  ),
  answer: BinaryAnswerSpec(
    question: 'With 100 tigers, is the sheep…',
    optionA: 'Safe',
    optionB: 'Eaten',
    correctIsA: sheepSurvives(100),
  ),
  hints: const [
    'What happens with just 1 tiger? Then try 2. What changed?',
    'When a tiger decides whether to eat, what does it need to be true about '
        'the world it wakes up in afterwards?',
    'After a tiger eats, how many tigers are left facing the new sheep?',
    'Line up the cases from small to large. What splits the safe outcomes from '
        'the eaten ones?',
  ],
  whyExplanation:
      'Think about it from the smallest case up.\n\n'
      'With 1 tiger, there is nothing to fear: that tiger eats the sheep and '
      'stays safe, because no other tiger is left to eat it. So 1 tiger → the '
      'sheep is eaten.\n\n'
      'With 2 tigers, each tiger thinks: "If I eat the sheep, I become a sheep — '
      'and then the other tiger is exactly in the 1-tiger situation, where '
      'eating is safe. It would eat me." So neither dares. 2 tigers → the sheep '
      'is safe.\n\n'
      'With 3 tigers, a tiger reasons: "If I eat, I become the sheep in a '
      '2-tiger world — and we just saw the sheep is safe there. So I would '
      'survive." One of them eats. 3 tigers → eaten.\n\n'
      'The pattern chains all the way up: a tiger eats only if, after it becomes '
      'the sheep, the remaining tigers form a "sheep is safe" situation. That '
      'flips with every added tiger. So the sheep is eaten when the number of '
      'tigers is ODD, and safe when it is EVEN.\n\n'
      '100 is even — so the sheep is safe. All 100 tigers, each perfectly '
      'logical, hold back, because each knows that eating would only hand itself '
      'to the next tiger in line.',
);
