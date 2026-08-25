import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// Hard number-theory & counting puzzles for MindShift.
///
/// Every puzzle here is pure data: the [prompt] states the full problem and ends
/// on the question with no method or answer leaked; [hints] are opt-in questions;
/// [whyExplanation] is revealed only after the player has solved it themselves.
final List<Puzzle> numberPuzzles = <Puzzle>[
  Puzzle(
    id: 'trailing-zeros',
    title: 'Zeros at the End of 100!',
    tagline: 'A tower of zeros hides at the tail of a huge number.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'The number 100! (100 factorial) means 100 × 99 × 98 × … × 3 × 2 × 1, '
        'the product of every whole number from 1 up to 100. Written out in '
        'full, it is a gigantic number that ends in a run of zeros.\n\n'
        'How many zeros does 100! end in?',
    rules: const [
      '100! is the product of all integers from 1 through 100.',
      'Count only the consecutive zeros at the very end of the number.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 24, unit: 'zeros'),
    hints: const [
      'A trailing zero appears each time the product picks up a factor of 10 — '
          'so what pair of primes must multiply together to make each 10?',
      'There are far more even numbers than multiples of 5 in 1…100, so which '
          'of the two primes is the scarce one that limits the count?',
      'How many multiples of 5 are there up to 100 — and do any numbers, like '
          '25, 50, 75 and 100, secretly contribute more than one 5?',
    ],
    whyExplanation:
        'Each trailing zero comes from a factor of 10 = 2 × 5. Factors of 2 are '
        'plentiful, so the number of trailing zeros equals the number of factors '
        'of 5 in 100!. Count them: ⌊100 ÷ 5⌋ = 20 numbers contribute a 5 (5, 10, '
        '15, …, 100), and ⌊100 ÷ 25⌋ = 4 of those (25, 50, 75, 100) contribute a '
        'second 5. That gives 20 + 4 = 24 factors of 5, so 100! ends in exactly '
        '24 zeros.',
  ),
  Puzzle(
    id: 'send-more-money',
    title: 'SEND + MORE = MONEY',
    tagline: 'Turn the letters back into the digits they stand for.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'In this famous cryptarithm each letter stands for a single digit from '
        '0 to 9. Different letters stand for different digits, the same letter '
        'always stands for the same digit, and no number may begin with 0.\n\n'
        '    S E N D\n'
        '  + M O R E\n'
        '  ---------\n'
        '  M O N E Y\n\n'
        'There is exactly one solution. What number does MONEY stand for?',
    rules: const [
      'Each letter is a distinct digit 0–9; equal letters share the same digit.',
      'Neither SEND, MORE, nor MONEY may have a leading zero.',
      'SEND + MORE must equal MONEY exactly.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 10652),
    hints: const [
      'MONEY has five digits but comes from adding two four-digit numbers — so '
          'what is the only value its leading letter M can possibly take?',
      'Once M is fixed, the sum S + M (plus any carry) has to spill into that '
          'leading digit — what does that force the letter O to be?',
      'Work the columns from the right, tracking each carry: what must D + E end '
          'in to produce Y, and which digits are still free to use?',
    ],
    whyExplanation:
        'Adding two four-digit numbers can produce at most a leading 1, so M = 1. '
        'The thousands column then forces S + M to carry, which pins O = 0. '
        'Carrying carefully through each column from the right gives the unique '
        'assignment S=9, E=5, N=6, D=7, M=1, O=0, R=8, Y=2. Checking: SEND = 9567 '
        'and MORE = 1085, and 9567 + 1085 = 10652 = MONEY. So MONEY = 10652.',
  ),
  Puzzle(
    id: 'eight-queens',
    title: 'The Eight Queens',
    tagline: 'Fit eight queens on the board with no one under threat.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'A chess queen attacks any square in the same row, the same column, or '
        'along either diagonal. You must place 8 queens on a standard 8×8 '
        'chessboard so that no two queens attack each other.\n\n'
        'In how many distinct arrangements can all 8 queens be placed?',
    rules: const [
      'The board is 8×8 and you place exactly 8 queens.',
      'No two queens may share a row, a column, or a diagonal.',
      'Count every distinct valid arrangement of the queens.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 92, unit: 'arrangements'),
    hints: const [
      'If no two queens share a row and no two share a column, how many queens '
          'must end up in each row and in each column?',
      'That means each solution is really a way of choosing one column per row — '
          'so which extra rule still rules many of those choices out?',
      'Could you build solutions row by row, placing a queen and backtracking '
          'whenever a diagonal clashes — what happens if you try a smaller board '
          'first to see the pattern?',
    ],
    whyExplanation:
        'Because no two queens share a row or column, every solution places '
        'exactly one queen in each row and each column — it is a permutation of '
        'the columns. The diagonal rule eliminates most permutations. Placing '
        'queens row by row and backtracking whenever two land on a common '
        'diagonal, the search finds exactly 92 valid arrangements (of which 12 '
        'are unique up to rotation and reflection). So the answer is 92.',
  ),
  Puzzle(
    id: 'climb-stairs',
    title: 'Climbing the Staircase',
    tagline: 'Every trip up the stairs can be taken a different way.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'A staircase has 10 steps. On each move you may climb either 1 step or '
        '2 steps. You start at the bottom and finish exactly on the top step.\n\n'
        'How many distinct sequences of moves reach the top?',
    rules: const [
      'The staircase has exactly 10 steps.',
      'Each move goes up either 1 or 2 steps.',
      'Two climbs differ if their sequence of 1s and 2s differs.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 89, unit: 'ways'),
    hints: const [
      'To land on the very top step, what was the size of your last move — and '
          'which step did you have to be standing on just before it?',
      'That means the ways to reach step 10 split cleanly into two groups: how '
          'do they relate to the ways to reach steps 9 and 8?',
      'If you tally the number of ways for 1 step, then 2 steps, then 3, does a '
          'familiar sequence start to appear as you climb higher?',
    ],
    whyExplanation:
        'The last move onto step 10 was either a 1-step (from step 9) or a '
        '2-step (from step 8), so ways(10) = ways(9) + ways(8). This is the '
        'Fibonacci recurrence. Starting from ways(1) = 1 and ways(2) = 2, the '
        'counts run 1, 2, 3, 5, 8, 13, 21, 34, 55, 89. The tenth value is 89, so '
        'there are 89 distinct ways to climb the staircase.',
  ),
  Puzzle(
    id: 'parentheses',
    title: 'Balanced Parentheses',
    tagline: 'Some strings of brackets close cleanly — count only those.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You have 4 opening brackets "(" and 4 closing brackets ")", eight '
        'symbols in all. Arrange them in a row so the result is correctly '
        'balanced: reading left to right, no closing bracket ever appears '
        'without a matching opening bracket still waiting, and every bracket is '
        'paired by the end.\n\n'
        'How many correctly balanced arrangements are there?',
    rules: const [
      'Use exactly 4 "(" and 4 ")" symbols, arranged in a single row.',
      'At every point, closing brackets so far may not exceed opening brackets.',
      'By the end all 8 brackets must be matched.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 14, unit: 'ways'),
    hints: const [
      'Scanning left to right, if you score +1 for "(" and −1 for ")", what must '
          'the running total never do, and where must it end?',
      'Consider the opening bracket that matches the very first "(" — how does '
          'the position of its partner split the whole string into two smaller '
          'balanced pieces?',
      'If you count the balanced arrangements for 1 pair, then 2 pairs, then 3, '
          'does the growing sequence of counts look familiar?',
    ],
    whyExplanation:
        'The number of ways to balance n pairs of parentheses is the nth Catalan '
        'number. Matching the first "(" with one of the later ")" splits every '
        'valid string into two smaller balanced strings, which gives the Catalan '
        'recurrence. The counts run 1, 2, 5, 14, … for 1, 2, 3, 4 pairs. For 4 '
        'pairs the Catalan number is C₄ = 14, so there are 14 balanced '
        'arrangements.',
  ),
  Puzzle(
    id: 'clock-overlaps',
    title: 'When the Hands Meet',
    tagline: 'The two hands chase each other around the dial all day.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'On an ordinary analog clock the minute hand sweeps around the face once '
        'every hour, while the hour hand creeps around once every 12 hours. Both '
        'move smoothly and continuously. Consider a full 12-hour period, from '
        '12:00 up to (but not repeating) the next 12:00.\n\n'
        'How many times do the hour and minute hands exactly overlap during '
        'those 12 hours?',
    rules: const [
      'Both hands move continuously, not in ticks.',
      'The minute hand completes a lap every 60 minutes; the hour hand every 12 '
          'hours.',
      'Count an overlap each time the two hands point in exactly the same '
          'direction within the 12-hour span.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 11, unit: 'times'),
    hints: const [
      'In 12 hours, how many full laps does the minute hand make, and how many '
          'does the hour hand make?',
      'An overlap happens each time the faster hand gains exactly one whole lap '
          'on the slower one — so how many laps does the minute hand gain over '
          'the hour hand across the whole period?',
      'Starting from the shared position at 12:00, if the hands next meet every '
          '12/11 of an hour, how many such meetings fit into 12 hours?',
    ],
    whyExplanation:
        'Overlaps happen whenever the minute hand gains a full lap on the hour '
        'hand. In 12 hours the minute hand completes 12 laps and the hour hand '
        'completes 1, so the minute hand gains 12 − 1 = 11 laps — one overlap per '
        'lap gained. Equivalently the hands coincide every 12/11 of an hour '
        '(about every 65.45 minutes), which happens 11 times in 12 hours. So the '
        'hands overlap 11 times.',
  ),
  Puzzle(
    id: 'power-last-digits',
    title: 'The Last Two Digits',
    tagline: 'A colossal power still shows its final two digits.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'Consider 3 raised to the power 2023 — that is, 3 multiplied by itself '
        '2023 times. Written out, it is an enormous number, but you only care '
        'about how it ends.\n\n'
        'What are the last two digits of 3^2023? Enter them as a two-digit '
        'number (for example, an ending of "05" would be entered as 5).',
    rules: const [
      'The last two digits mean the number modulo 100.',
      'Enter the two-digit ending as a number (a leading zero is dropped).',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 27),
    hints: const [
      'Only the last two digits matter, so what happens if you multiply by 3 '
          'each step and keep just the final two digits every time?',
      'Do those endings eventually repeat? If they cycle, how long is one full '
          'cycle before the pattern starts over?',
      'Once you know the cycle length, what does 2023 leave as a remainder when '
          'divided by it, and which power does that remainder point to?',
    ],
    whyExplanation:
        'Keeping only the last two digits means working modulo 100. The endings '
        'of successive powers of 3 repeat with a cycle length of 20: 3, 9, 27, '
        '81, 43, … and back around. Since 2023 = 20 × 101 + 3, the exponent 2023 '
        'lands at the same place in the cycle as exponent 3. Because 3^3 = 27, the '
        'last two digits of 3^2023 are 27.',
  ),
  Puzzle(
    id: 'mcnugget',
    title: 'The Unreachable Total',
    tagline: 'Fixed pack sizes leave a few totals forever out of reach.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'A shop sells one item only in sealed packs of 6, 9, or 20. You may buy '
        'any number of packs of each size, but you can never split a pack. Some '
        'exact totals can be made (for example 15 = 6 + 9), while a few small '
        'totals cannot be made at all.\n\n'
        'What is the largest total quantity that can NOT be bought exactly?',
    rules: const [
      'Packs come in sizes 6, 9, and 20 only.',
      'You may use any whole number of each pack, including none of a size.',
      'Find the greatest total that no combination of packs can add up to.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 43),
    hints: const [
      'Which small totals simply cannot be assembled from 6, 9, and 20 — try '
          'listing the impossible ones as you count upward?',
      'If you ever find 6 buildable totals in a row, why does that guarantee '
          'every larger total is reachable too?',
      'What is the last impossible total you hit before that unbroken run of '
          'reachable totals begins?',
    ],
    whyExplanation:
        'This is the Frobenius number for 6, 9, and 20 — the largest total that '
        'no non-negative combination of those sizes can form. Checking totals in '
        'order, 43 cannot be made from 6s, 9s, and 20s, but 44 = 20 + 6 × 4, '
        '45 = 9 × 5, 46 = 20 × 2 + 6, 47 = 20 + 9 × 3, 48 = 6 × 8, and '
        '49 = 20 + 9 + 20 are all possible. Once six consecutive totals are '
        'reachable, adding a 6 reaches everything beyond, so nothing above 43 is '
        'impossible. The answer is 43.',
  ),
  Puzzle(
    id: 'digits-of-power',
    title: 'How Many Digits?',
    tagline: 'Doubling a hundred times makes a number — how long is it?',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'Start at 1 and double it 100 times; the result is 2 raised to the power '
        '100. Written out in ordinary base-10 form, it is a long string of '
        'digits.\n\n'
        'How many digits long is 2^100?',
    rules: const [
      'The number is 2 multiplied by itself 100 times.',
      'Count the digits of the value written in base 10.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 31, unit: 'digits'),
    hints: const [
      'A base-10 number’s digit count is tied to which mathematical '
          'operation — what tells you the power of 10 a number sits between?',
      'Between which two powers of 10 does 2^100 fall, and how does a number’s '
          'position between 10^k and 10^(k+1) fix its digit count?',
      'If you know that log base 10 of 2 is about 0.301, what is 100 times that '
          'value, and how do you turn it into a digit count?',
    ],
    whyExplanation:
        'A positive whole number N has ⌊log₁₀ N⌋ + 1 digits, because that floor '
        'tells you the highest power of 10 that fits inside it. Here '
        'log₁₀(2^100) = 100 × log₁₀ 2 ≈ 100 × 0.30103 = 30.103. Taking the floor '
        'gives 30, so the digit count is 30 + 1 = 31. Thus 2^100 has 31 digits.',
  ),
  Puzzle(
    id: 'birthday-paradox',
    title: 'The Birthday Paradox',
    tagline: 'A surprisingly small crowd almost certainly shares a birthday.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'People enter a room one at a time. Assume every birthday is one of 365 '
        'equally likely days and ignore leap years. As the room fills, the '
        'chance that at least two people share a birthday keeps rising.\n\n'
        'What is the smallest number of people for which that chance first '
        'exceeds 50%?',
    rules: const [
      'There are 365 equally likely birthdays and no leap years.',
      'A "match" means any two or more people share the same birthday.',
      'Find the fewest people needed for the match probability to exceed 50%.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 23, unit: 'people'),
    hints: const [
      'Instead of chasing every possible match, is it easier to work out the '
          'chance that everyone’s birthday is different?',
      'As each new person arrives, how many of the 365 days are still unused, '
          'and how do you combine those shrinking fractions?',
      'You want the "all different" probability to drop below one-half — at which '
          'headcount does that product first cross below 0.5?',
    ],
    whyExplanation:
        'It is easier to track the probability that all birthdays differ. With '
        'k people that is (365/365) × (364/365) × … × ((365 − k + 1)/365), since '
        'each new person must dodge the days already taken. This product stays '
        'above 0.5 for 22 people (about 0.524, so a match chance near 47.6%) but '
        'drops to about 0.493 for 23 people, making the match probability about '
        '50.7% — just over half. So 23 people are needed.',
  ),
];
