import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// Hard probability puzzles — famous counterintuitive results. Each is a
/// pure-reasoning puzzle: the sandbox is a calm scratchpad, the human does all
/// the thinking, and the "why" is revealed only after the player commits.
final List<Puzzle> probabilityPuzzles = <Puzzle>[
  Puzzle(
    id: 'monty-hall',
    title: 'The Monty Hall Problem',
    tagline: 'One car, two goats, and a host who knows.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You are on a game show facing three closed doors. Behind one door is '
        'a car; behind each of the other two is a goat. You pick a door — say, '
        'Door 1 — but it stays closed. The host, who knows what is behind every '
        'door, opens one of the other two doors and always reveals a goat. He '
        'then offers you the choice to stay with your original door or switch to '
        'the one remaining closed door. If you always switch, what is your '
        'chance of winning the car?',
    rules: const [
      'Behind the three doors: 1 car and 2 goats, placed at random.',
      'You pick one door first; it is not opened.',
      'The host always opens a different door and always reveals a goat.',
      'You then choose to stay or switch to the last closed door.',
    ],
    hints: const [
      'How likely was your very first pick to be the car, before any door '
          'opened?',
      'Does the host — who never reveals the car — give you real information '
          'about the doors you did not pick?',
      'If your first pick is a goat (the more common case), where must the car '
          'be after a goat is revealed?',
    ],
    whyExplanation:
        'Your first pick is the car only 1/3 of the time and a goat 2/3 of the '
        'time. Whenever you first picked a goat — 2 times out of 3 — the host '
        'is forced to reveal the other goat, so the remaining closed door hides '
        'the car. Switching therefore wins exactly when your first pick was a '
        'goat: 2/3 of the time. Staying wins only the 1/3 of cases where you '
        'had already landed on the car.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'If you always switch, what is your chance of winning the car?',
      options: ['1/2', '2/3', '1/3', '3/4'],
      correctIndex: 1,
    ),
  ),
  Puzzle(
    id: 'boy-tuesday',
    title: 'The Tuesday Birthday Boy',
    tagline: 'Two kids, and one very specific clue.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A parent has exactly two children. Each child is independently a boy '
        'or a girl with equal probability, and is equally likely to have been '
        'born on any of the seven days of the week. You are told just one fact: '
        'at least one of the two children is a boy born on a Tuesday. Given '
        'only this, what is the probability that both children are boys?',
    rules: const [
      'There are exactly two children.',
      'Each child is a boy or a girl, each with probability 1/2.',
      'Each child is equally likely to be born on any of the 7 days, '
          'independently of sex and of the other child.',
      'You know only that at least one child is a boy born on a Tuesday.',
    ],
    hints: const [
      'Describe each child by both sex and day of birth — how many equally '
          'likely combinations does that give for one child, and for the pair?',
      'Which of those pair-combinations actually contain a boy born on a '
          'Tuesday?',
      'Among only those matching pairs, in how many are both children boys — '
          'and how do you avoid double-counting the two-Tuesday-boys case?',
    ],
    whyExplanation:
        'Tag each child by sex and weekday: 14 equally likely states per child, '
        'so 14 × 14 = 196 for the pair. Count pairs containing at least one '
        'Tuesday-boy: a Tuesday-boy as the first child pairs with 14 states for '
        'the second, and as the second child with 14 for the first — that is '
        '28, but the both-are-Tuesday-boys pair is counted twice, leaving 27 '
        'matching pairs. Of these, both children are boys in 13 (a Tuesday-boy '
        'paired with any of 7 boy-days in either order, minus the one '
        'double-count). So the probability is 13/27 — close to 1/2 because the '
        'specific day makes the overlap rare.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'What is the probability that both children are boys?',
      options: ['1/2', '1/3', '13/27', '14/27'],
      correctIndex: 2,
    ),
  ),
  Puzzle(
    id: 'bertrand-box',
    title: 'The Three Cards',
    tagline: 'Three cards, and one glimpse of red.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A hat holds three cards. One card is red on both sides. One is black '
        'on both sides. One is red on one side and black on the other. You '
        'shake the hat, draw a card at random, and lay it flat without looking '
        'at the underside. The face you see is red. What is the probability '
        'that the other side is also red?',
    rules: const [
      'The three cards are: red/red, black/black, and red/black.',
      'You draw one card uniformly at random and lay it flat.',
      'The side facing up is equally likely to be either side of that card.',
      'The face you see happens to be red.',
    ],
    hints: const [
      'How many red faces are there in total across all three cards?',
      'A red face you are seeing could belong to which cards — and how many red '
          'faces does each of those cards contribute?',
      'Given you are looking at a red face, is every red face equally likely to '
          'be the one showing?',
    ],
    whyExplanation:
        'There are three red faces in the hat: two on the red/red card and one '
        'on the red/black card. Seeing a red face, each of those three red '
        'faces was equally likely to be the one showing. Two of the three '
        'belong to the red/red card, whose hidden side is also red; only one '
        'belongs to the red/black card. So the other side is red in 2 of 3 '
        'equally likely cases: 2/3. The tempting "1/2" wrongly counts cards '
        'instead of faces.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'What is the probability the other side is also red?',
      options: ['1/2', '2/3', '1/3', '3/4'],
      correctIndex: 1,
    ),
  ),
  Puzzle(
    id: 'airplane-seating',
    title: 'The Absent-Minded Passenger',
    tagline: 'One lost boarding pass, ninety-nine nervous flyers.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A full flight has 100 seats and 100 passengers, each with a specific '
        'assigned seat. The first passenger has lost their boarding pass and '
        'simply sits in a seat chosen uniformly at random. Every other '
        'passenger then boards in order: each takes their own assigned seat if '
        'it is free, and otherwise sits in an empty seat chosen uniformly at '
        'random. What is the probability that the 100th passenger ends up in '
        'their own assigned seat?',
    rules: const [
      'There are 100 passengers and 100 seats; the plane ends up full.',
      'Passengers board one at a time in a fixed order.',
      'Passenger 1 sits in a uniformly random seat.',
      'Each later passenger takes their own seat if free, else a uniformly '
          'random free seat.',
    ],
    hints: const [
      'By the time the last passenger boards, only one seat is left — which two '
          'seats are the only candidates it could be?',
      'Whenever a displaced passenger must choose at random, how do the chances '
          'of taking seat #1 versus seat #100 compare?',
      'Could you test the pattern by first working it out for just 2 or 3 '
          'passengers?',
    ],
    whyExplanation:
        'The only seats that can still be open for the last passenger are '
        'passenger 1\'s own seat and passenger 100\'s own seat — every other '
        'passenger would have claimed their own seat before it could cause '
        'trouble. Each time a displaced passenger picks at random, seat 1 and '
        'seat 100 are, by symmetry, equally likely to be the one taken. So the '
        'outcome reduces to a coin flip between those two seats, and the last '
        'passenger gets their own seat with probability 1/2 — no matter how '
        'many passengers there are.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question:
          'What is the probability the 100th passenger gets their own seat?',
      options: ['1/2', '1/100', '99/100', '1/e'],
      correctIndex: 0,
    ),
  ),
  Puzzle(
    id: 'st-petersburg',
    title: 'The St. Petersburg Game',
    tagline: 'A coin game whose "fair" price defies belief.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A casino offers this game. A fair coin is flipped repeatedly until it '
        'first lands heads. If the first head appears on flip number k, you are '
        'paid 2^k dollars: \$2 if heads comes on flip 1, \$4 on flip 2, \$8 on '
        'flip 3, and so on, doubling each time. A price is called "fair" when '
        'it equals the expected (average) payout of one play. What is a fair '
        'price to play?',
    rules: const [
      'A fair coin is flipped until it first shows heads.',
      'If the first head is on flip k, the payout is 2^k dollars.',
      'Flips are independent, each with heads probability 1/2.',
      'A "fair" price equals the expected payout of a single play.',
    ],
    hints: const [
      'What is the probability the first head appears exactly on flip k, and '
          'what does that outcome pay?',
      'For each possible k, how big is the product (probability × payout) that '
          'it contributes to the average?',
      'When you add up those contributions over all possible values of k, does '
          'the total settle on a finite number?',
    ],
    whyExplanation:
        'The first head lands on flip k with probability (1/2)^k, and that '
        'outcome pays 2^k dollars. Each term of the expected value is therefore '
        '(1/2)^k × 2^k = 1 dollar. Summing over k = 1, 2, 3, … gives '
        '1 + 1 + 1 + … , which grows without bound. The mathematical expected '
        'payout is infinite, so no finite price is "fair" by that measure — the '
        'paradox being that almost every real play pays only a few dollars.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'What is a fair price to play?',
      options: ['\$4', '\$20', '\$100', 'Infinite'],
      correctIndex: 3,
    ),
  ),
  Puzzle(
    id: 'random-walk',
    title: "The Drunkard's Walk",
    tagline: 'A wanderer with no memory and no destination.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A person stands at a marked point on an endless straight line. Every '
        'step they move exactly one unit left or one unit right, each with '
        'probability 1/2, independently of all previous steps, and they never '
        'stop stepping. Is the drunkard certain to eventually return to the '
        'starting point?',
    rules: const [
      'The path is an infinite straight line, endless in both directions.',
      'Each step is left or right, each with probability 1/2.',
      'Steps are independent, and the walk goes on forever.',
      '"Return" means landing back exactly on the start at some later step.',
    ],
    hints: const [
      'Over many steps, does a perfectly symmetric walk drift steadily away or '
          'keep hovering around where it began?',
      'How does the chance of sitting exactly on the origin after 2n steps '
          'shrink as n grows — fast enough to escape for good, or not?',
      'Would your answer change if the walker wandered an infinite 2-D grid, or '
          'a 3-D lattice?',
    ],
    whyExplanation:
        'A one-dimensional symmetric random walk is recurrent: with probability '
        '1 it returns to its starting point — in fact infinitely often. Though '
        'the chance of being exactly at the origin after 2n steps shrinks like '
        '1/√(πn), these return probabilities shrink slowly enough that their '
        'sum diverges, which forces certain return. So the answer is Yes. '
        '(Remarkably, this recurrence holds in 1-D and 2-D but fails in 3-D, '
        'where the walker escapes with positive probability.)',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Is the drunkard certain to eventually return to the start?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: true,
    ),
  ),
  Puzzle(
    id: 'nontransitive-dice',
    title: 'The Unfair Dice',
    tagline: 'Pick any die you like — you will still lose.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'Two players each choose one die from a special set, then they roll; '
        'the higher number wins the round, and they play many rounds. The dice '
        'carry unusual face numbers rather than the ordinary 1–6, so "better" '
        'is not straightforward. In fact such a set can be built so that die A '
        'beats die B more than half the time, die B beats die C more than half '
        'the time, yet die C beats die A more than half the time. The first '
        'player chooses their die first, then the second player chooses. Can '
        'the second player always pick a die that beats the first player\'s?',
    rules: const [
      'The players pick from a special set of dice with unusual face numbers.',
      'In each round the higher roll wins; they play many rounds.',
      'The set is non-transitive: A beats B, B beats C, and C beats A, each '
          'more than half the time.',
      'The first player commits to a die first; the second player then chooses.',
    ],
    hints: const [
      'If the "beats" relationships form a loop A → B → C → A, is there any '
          'single strongest die?',
      'For whichever die the first player commits to, is there always another '
          'die in the loop that beats it more than half the time?',
      'Does choosing second — with full knowledge of the opponent\'s die — help '
          'or hurt?',
    ],
    whyExplanation:
        'Because the dice are non-transitive, the "beats" relation forms a '
        'cycle with no strongest die: for every die there is another that beats '
        'it more than half the time. The second player, choosing after the '
        'first has committed, can always answer with the die that beats the '
        'opponent\'s choice. So the answer is Yes — going second is a genuine '
        'advantage here. Efron\'s dice are a classic example of such a set.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question:
          'Can the second player always pick a die that beats the first '
          'player\'s?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: true,
    ),
  ),
  Puzzle(
    id: 'two-envelopes',
    title: 'The Two Envelopes',
    tagline: 'The argument that says: always switch. It is wrong.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'Two sealed envelopes each contain money; one holds exactly twice as '
        'much as the other. You pick one at random and may keep it or swap for '
        'the other. A tempting argument says: let your envelope hold X; the '
        'other then holds 2X or X/2 with equal chance, so its expected value is '
        '(1/2)(2X) + (1/2)(X/2) = 1.25X — more than X — so you should always '
        'switch. Does this switching argument give a genuine advantage?',
    rules: const [
      'There are two envelopes; one contains exactly twice the amount of the '
          'other.',
      'You choose one envelope at random, then may switch to the other.',
      'The "1.25X" argument treats your envelope\'s amount X as fixed while the '
          'other envelope varies.',
      'The question is whether that reasoning truly makes switching better.',
    ],
    hints: const [
      'Does the symbol "X" refer to the same amount of money in the "2X" branch '
          'as in the "X/2" branch?',
      'By the very same logic, would the person holding the other envelope also '
          'compute a 1.25× gain from switching to yours?',
      'If switching were always strictly better, what would that imply about '
          'switching again, and again?',
    ],
    whyExplanation:
        'The argument is flawed, so the answer is No. It quietly lets "X" mean '
        'two different things: in the "2X" case your envelope is the smaller '
        'amount, but in the "X/2" case it is the larger — you cannot hold one '
        'fixed X while both branches are true. Naming the two amounts honestly '
        '(say A and 2A), switching and staying each average the same 1.5A. '
        'Symmetry clinches it: if switching always helped, both players would '
        'want to switch, which is impossible. There is no genuine advantage.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Does the switching argument give a genuine advantage?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: false,
    ),
  ),
  Puzzle(
    id: 'coupon-collector',
    title: 'The Coupon Collector',
    tagline: 'How long until a die has shown every face?',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You roll a fair six-sided die over and over, keeping track of which of '
        'the six faces you have seen so far. You stop the instant all six '
        'different faces have each appeared at least once. On average, how many '
        'rolls does it take to see all six faces at least once?',
    rules: const [
      'The die is fair; each of the six faces is equally likely on every roll.',
      'Rolls are independent of one another.',
      'You keep rolling until all six distinct faces have appeared.',
      '"On average" means the expected number of rolls over many repetitions.',
    ],
    hints: const [
      'Once you have already seen j different faces, what is the probability '
          'that a single roll shows a brand-new one?',
      'If some success has probability p per try, how many tries on average '
          'until it first happens?',
      'How do the waiting times for the 1st, 2nd, …, 6th new face combine into '
          'the total?',
    ],
    whyExplanation:
        'Collect the faces one new kind at a time. When you already have j '
        'distinct faces, a roll reveals a new face with probability (6 − j)/6, '
        'so the average wait for the next new face is 6/(6 − j). Summing from '
        'j = 0 to 5 gives 6 · (1/6 + 1/5 + 1/4 + 1/3 + 1/2 + 1/1) = '
        '6 · (1 + 1/2 + 1/3 + 1/4 + 1/5 + 1/6) ≈ 14.7 rolls.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question:
          'On average, how many rolls to see all six faces at least once?',
      options: ['6', 'About 9.8', 'About 14.7', 'About 21'],
      correctIndex: 2,
    ),
  ),
  Puzzle(
    id: 'base-rate',
    title: 'The Positive Test',
    tagline: 'A 99%-accurate test, and a positive result.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A certain disease affects 1 in 1000 people at random. A screening test '
        'is 99% accurate in both directions: if you have the disease it comes '
        'back positive 99% of the time, and if you do not have it it comes back '
        'negative 99% of the time. With no symptoms or other risk factors, you '
        'take the test and it comes back positive. Given this positive result, '
        'what is the chance you actually have the disease?',
    rules: const [
      'The disease affects 1 in 1000 people (a base rate of 0.1%).',
      'True-positive rate: 99% (positive when you do have the disease).',
      'True-negative rate: 99% (negative when you do not have it).',
      'You tested positive, with no other information about you.',
    ],
    hints: const [
      'In a large group of, say, 100,000 similar people, how many truly have '
          'the disease and how many do not?',
      'How many true positives versus false positives would the test produce '
          'across that whole group?',
      'Among everyone who tests positive, what fraction are the people who '
          'truly have the disease?',
    ],
    whyExplanation:
        'Picture 100,000 people. About 100 have the disease, and of them 99 '
        'test positive (true positives). The other 99,900 are healthy, but 1% '
        'of them — about 999 — test positive anyway (false positives). A '
        'positive result puts you among 99 + 999 ≈ 1098 positives, of whom only '
        '99 truly have the disease: 99/1098 ≈ 9%. The rare base rate means most '
        'positives are false alarms — exactly Bayes\' theorem: '
        '(0.99 × 0.001) / (0.99 × 0.001 + 0.01 × 0.999) ≈ 0.09.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question:
          'Given a positive result, what is the chance you actually have the '
          'disease?',
      options: ['About 99%', 'About 50%', 'About 9%', 'About 1%'],
      correctIndex: 2,
    ),
  ),
];
