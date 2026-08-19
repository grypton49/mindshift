import '../models/puzzle.dart';
import '../models/puzzle_category.dart';
import 'nim_logic.dart';

/// A game-theory puzzle on a NEW mechanic: the single-pile take-away game.
/// The player plays against a perfect opponent and discovers, by experimenting,
/// whether the first mover can force a win — and the strategy behind it.
final Puzzle lastStonePuzzle = Puzzle(
  id: 'last-stone',
  title: 'The Last Stone',
  tagline: 'Take 1–3 stones, alternate turns. Can you always win?',
  category: PuzzleCategory.gameTheory,
  difficulty: 5,
  prompt:
      'There are 13 stones. You and your opponent take turns removing 1, 2, or 3 '
      'stones. You go first. Whoever takes the very last stone wins.\n\n'
      'Playing perfectly against a perfect opponent, can the first player always '
      'force a win?',
  rules: const [
    'On your turn, remove 1, 2, or 3 stones.',
    'You move first; the opponent then plays perfectly.',
    'Taking the last stone wins the game.',
  ],
  sandbox: const NimSandboxSpec(stones: 13, maxTake: 3, lastTakeWins: true),
  answer: BinaryAnswerSpec(
    question: 'Going first, can you always force a win?',
    optionA: 'Yes',
    optionB: 'No',
    correctIsA: nimFirstPlayerWins(
      stones: 13,
      maxTake: 3,
      lastTakeWins: true,
    ),
  ),
  hints: const [
    'After both of you move once, how many stones can disappear in a full round?',
    'Is there a "safe" number of stones you always want to hand back to your opponent?',
  ],
  whyExplanation:
      'The magic number is 4 (one more than the most you can take). If you always '
      'leave a multiple of 4 stones for your opponent — 12, then 8, then 4 — they '
      'can never escape it: whatever they take (1–3), you take the rest of that '
      'round back to the next multiple of 4. From 13 you take 1 to leave 12, and '
      'you win every time. So yes, the first player can always force a win here.',
);

/// A misère twist: taking the last stone now LOSES. Reuses the same Nim mechanic,
/// so it can ship purely as content — the strategy shifts subtly.
final Puzzle lastStoneReversedPuzzle = Puzzle(
  id: 'last-stone-reversed',
  title: 'The Last Stone: Reversed',
  tagline: 'Same game, flipped rule — now taking the last stone LOSES.',
  category: PuzzleCategory.gameTheory,
  difficulty: 4,
  prompt:
      'There are 10 stones. You and your opponent take turns removing 1, 2, or 3 '
      'stones. You go first. This time, whoever takes the very last stone LOSES.\n\n'
      'Playing perfectly against a perfect opponent, can the first player always '
      'force a win?',
  rules: const [
    'On your turn, remove 1, 2, or 3 stones.',
    'You move first; the opponent then plays perfectly.',
    'Whoever is forced to take the last stone loses.',
  ],
  sandbox: const NimSandboxSpec(stones: 10, maxTake: 3, lastTakeWins: false),
  answer: BinaryAnswerSpec(
    question: 'Going first, can you always force a win?',
    optionA: 'Yes',
    optionB: 'No',
    correctIsA: nimFirstPlayerWins(
      stones: 10,
      maxTake: 3,
      lastTakeWins: false,
    ),
  ),
  hints: const [
    'What is the WORST pile size to be handed now — the one you are desperate to avoid?',
    'You wanted multiples of 4 before. Where does that safe target shift when the last stone is poison?',
  ],
  whyExplanation:
      'Now the poison is the last stone, so you want to hand your opponent '
      'exactly 1 (they must take it and lose). Working back, the safe numbers to '
      'leave are 1, 5, 9, 13, … — one more than a multiple of 4. From 10 you take '
      '1 to leave 9, then keep returning to 5 and then 1. So yes, the first '
      'player can still force a win — the target just shifts by one.',
);
