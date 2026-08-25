import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// The Math pack: ten hard optimization / combinatorics classics. Each is a
/// pure-reasoning puzzle — the player works in a private scratchpad and commits
/// a single whole number. Prompts state the full scenario and the question only;
/// they never suggest a method or reveal the answer. Hints are questions;
/// [whyExplanation] is shown only after the puzzle is solved.
final List<Puzzle> mathPuzzles = <Puzzle>[
  Puzzle(
    id: 'egg-drop',
    title: 'Two Eggs, One Hundred Floors',
    tagline: 'Find the breaking floor with two eggs and the fewest drops.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You are standing in a building with 100 floors and you have 2 '
        'identical eggs. There is some unknown floor such that an egg dropped '
        'from at or above it always breaks, while an egg dropped from any floor '
        'below it always survives. A broken egg cannot be used again. You want '
        'to determine exactly which floor that is.\n\n'
        'Using the best possible strategy, what is the smallest number of drops '
        'that is guaranteed to find the floor no matter where it turns out to '
        'be?',
    rules: const [
      'You have exactly 2 eggs to work with.',
      'An egg breaks if and only if dropped from at or above the unknown floor.',
      'A broken egg is gone; a survived egg may be dropped again.',
      'The building has 100 floors, and you want the worst-case guarantee.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 14, unit: 'drops'),
    hints: const [
      'If you had only one egg, how would you be forced to search, and how many '
          'drops could that cost you in the worst case?',
      'Once your first egg breaks, what are you forced to do with the second '
          'egg, and how does that limit where you dare to drop the first?',
      'If your first drop is at floor f and it breaks, how many floors must the '
          'second egg then check one at a time?',
      'What if each successive jump for the first egg were one floor smaller '
          'than the last — how far up could you reach in a fixed number of '
          'drops?',
    ],
    whyExplanation:
        'The trick is to keep the worst case constant. Say your first drop is '
        'at floor f. If it breaks, the second egg must be tested one floor at a '
        'time from 1 up to f - 1, so that branch costs up to f drops in total. '
        'To keep the worst case the same after the first egg survives, your next '
        'jump should be one floor smaller: f, then f + (f - 1), then '
        'f + (f - 1) + (f - 2), and so on. Starting with a jump of n, you can '
        'cover n + (n - 1) + ... + 1 = n(n + 1) / 2 floors. You need '
        'n(n + 1) / 2 >= 100; n = 13 covers only 91, but n = 14 covers '
        '14 x 15 / 2 = 105. So start at floor 14, then 27, then 39, and so on — '
        '14 drops always suffice.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'tower-of-hanoi',
    title: 'The Tower of Hanoi',
    tagline: 'Move a 20-disk tower between pegs in the fewest moves.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You have three pegs and a stack of 20 disks of different sizes resting '
        'on the first peg, arranged largest at the bottom up to smallest at the '
        'top. You must move the entire stack onto another peg. You may move only '
        'one disk at a time — always the top disk of some peg — and you may '
        'never place a larger disk on top of a smaller one.\n\n'
        'What is the minimum number of single-disk moves needed to move all 20 '
        'disks onto another peg?',
    rules: const [
      'There are three pegs in total.',
      'Each move takes the top disk of one peg and places it on another peg.',
      'A larger disk may never rest on top of a smaller disk.',
      'You start with 20 disks stacked in size order.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 1048575, unit: 'moves'),
    hints: const [
      'Before the single largest disk can ever move, where must all the disks '
          'above it be sitting — and how many disks is that?',
      'If you already knew the fewest moves for a stack of one less disk, how '
          'many moves does adding one more disk cost you?',
      'How does the count grow for a stack of 1, then 2, then 3 disks? What '
          'kind of pattern is that?',
    ],
    whyExplanation:
        'To move the biggest disk, all 19 disks above it must first be stacked '
        'out of the way on the spare peg — a full 19-disk transfer. Then the '
        'big disk moves once, and finally the 19-disk stack is moved on top of '
        'it — another full 19-disk transfer. So if T(n) is the minimum for n '
        'disks, T(n) = 2 x T(n - 1) + 1 with T(1) = 1. Solving this gives '
        'T(n) = 2^n - 1. For 20 disks that is 2^20 - 1 = 1,048,575 moves.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'hundred-lockers',
    title: 'The Hundred Lockers',
    tagline: 'A hundred lockers, a hundred togglers — how many end open?',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'A hallway has 100 lockers, numbered 1 to 100, and every locker starts '
        'closed. Then 100 people walk down the hallway in turn. Person 1 '
        'toggles every locker (opening each closed one and closing each open '
        'one). Person 2 toggles every 2nd locker: 2, 4, 6, and so on. Person 3 '
        'toggles every 3rd locker: 3, 6, 9, and so on. This continues up to '
        'person 100, who toggles only locker 100.\n\n'
        'After all 100 people have passed, how many lockers are open?',
    rules: const [
      'All 100 lockers begin closed.',
      'Person k toggles lockers k, 2k, 3k, ... up to 100.',
      'Toggling flips a locker: closed becomes open, open becomes closed.',
      'You want the count of open lockers after all 100 people have passed.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 10, unit: 'lockers'),
    hints: const [
      'Which people, exactly, touch a particular locker — say locker 12? What '
          'do their numbers have in common with 12?',
      'A locker ends open only if it is toggled an odd number of times. When '
          'does a number have an odd number of divisors?',
      'Try listing the divisors of a few numbers. Which numbers have a divisor '
          'that is not part of a matching pair?',
    ],
    whyExplanation:
        'Locker n is toggled once by each person whose number divides n — that '
        'is, once for every divisor of n. Since a locker starts closed, it ends '
        'open only if it is toggled an odd number of times. Divisors normally '
        'come in pairs (d and n / d), which is an even count — except when '
        'd = n / d, i.e. when n is a perfect square and its square root is '
        'unpaired. So only the perfect-square lockers stay open: '
        '1, 4, 9, 16, 25, 36, 49, 64, 81, 100 — exactly 10 lockers.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'bridge-crossing',
    title: 'The Midnight Bridge',
    tagline:
        'Four people, one torch, a fragile bridge — cross in the least time.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'Four people must cross a rickety bridge in the dark. They share a '
        'single torch, and the bridge can hold at most two people at a time. '
        'Anyone on the bridge must be carrying the torch, so after each crossing '
        'it has to be walked back for the others. The four walk at different '
        'speeds and take 1, 2, 5, and 10 minutes to cross; when two cross '
        'together, they move at the pace of the slower one.\n\n'
        'What is the least total time for all four to get across?',
    rules: const [
      'At most two people may be on the bridge at once.',
      'Whoever crosses must carry the one torch, so it must be walked back.',
      'A crossing pair takes as long as its slower member.',
      'Individual crossing times are 1, 2, 5, and 10 minutes.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 17, unit: 'minutes'),
    hints: const [
      'The torch must return after every crossing except the last. Who should '
          'carry it back to waste the least time?',
      'The two slowest walkers each take a long time on their own. Is there a '
          'way to make them cross at the same time?',
      'Does the fastest person really have to be the one shuttling the torch on '
          'every single trip?',
    ],
    whyExplanation:
        'The tempting plan is to let the fastest person escort everyone: 1 '
        'walks each of 2, 5, and 10 across and runs back each time, costing '
        '1 + 2 + 1 + 5 + 1 + 10 = 20 minutes. The better idea is to make the '
        'two slowest cross together so you only pay for the slow trip once. '
        'Send 1 and 2 over (2 minutes), send 1 back (1), send 5 and 10 over '
        'together (10), send 2 back (2), then send 1 and 2 over (2): total '
        '2 + 1 + 10 + 2 + 2 = 17 minutes.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'wolf-goat-cabbage',
    title: 'The River Crossing',
    tagline: 'Ferry a wolf, a goat, and a cabbage across — nothing eaten.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'A farmer must ferry a wolf, a goat, and a cabbage across a river. The '
        'boat is small: it carries the farmer plus at most one of the three. If '
        'they are left together without the farmer, the wolf will eat the goat, '
        'and the goat will eat the cabbage. The farmer needs to get all three '
        'safely to the far bank.\n\n'
        'Counting every trip the boat makes across the river, in either '
        'direction, as one crossing, what is the fewest crossings needed?',
    rules: const [
      'The boat carries the farmer plus at most one item.',
      'The wolf and goat must never be left together without the farmer.',
      'The goat and cabbage must never be left together without the farmer.',
      'Each trip across the river, in either direction, counts as one crossing.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 7, unit: 'crossings'),
    hints: const [
      'Which single item cannot safely be left with either of the other two? '
          'Where should it go first?',
      'Is a trip ever wasted, or could carrying something back across actually '
          'be part of the solution?',
      'Once the goat is on the far bank, how do you deliver the wolf without '
          'ever leaving it alone with the goat?',
    ],
    whyExplanation:
        'The goat is the troublemaker — it can be left with neither the wolf '
        'nor the cabbage. So take the goat over first (1) and return empty (2). '
        'Take the wolf over (3), but bring the goat back (4) so it is not left '
        'with the wolf. Drop the goat, take the cabbage over (5) — now the wolf '
        'and cabbage sit safely together — and return empty (6). Finally take '
        'the goat over (7). The key move is ferrying the goat back on the '
        'fourth trip; that is what makes 7 crossings enough.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'water-jugs',
    title: 'The Die Hard Jugs',
    tagline: 'Measure exactly four gallons with a 3 and a 5.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You have two jugs — one holds exactly 3 gallons and the other exactly '
        '5 gallons — both empty, plus a tap with unlimited water. Neither jug '
        'has any markings, so the only things you can do are fill a jug '
        'completely, empty a jug entirely, or pour from one jug into the other '
        'until either the first jug is empty or the second jug is full. You need '
        'to end up with exactly 4 gallons of water measured out.\n\n'
        'Counting each fill, each empty, and each pour as one step, what is the '
        'fewest steps to measure exactly 4 gallons?',
    rules: const [
      'A jug can only be filled to the top, emptied completely, or poured into '
          'the other.',
      'A pour stops when the source jug is empty or the destination jug is '
          'full.',
      'The jugs have no intermediate markings.',
      'Each fill, empty, or pour counts as one step.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 6, unit: 'steps'),
    hints: const [
      'The jugs are 3 and 5. Besides 3 or 5, what amounts can you be left with '
          'in a jug after a single pour?',
      'If you pour the full 5-gallon jug into the empty 3-gallon jug, how much '
          'is stranded behind in the big jug?',
      'Could a small leftover amount sitting in the 3-gallon jug be used to '
          'block off most of a fresh 5-gallon fill?',
    ],
    whyExplanation:
        'Fill the 5-gallon jug (1). Pour it into the 3-gallon jug until that is '
        'full — 2 gallons remain in the 5 (2). Empty the 3-gallon jug (3). Pour '
        'those 2 gallons into the 3-gallon jug (4); it now holds 2 with room '
        'for just 1 more. Fill the 5-gallon jug again (5). Pour from the 5 into '
        'the 3 until the 3 is full — that takes exactly 1 gallon, leaving 4 '
        'gallons behind in the 5-gallon jug (6). Six steps, and the big jug '
        'holds exactly 4.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'camel-bananas',
    title: 'The Camel and the Bananas',
    tagline: 'Shuttle 3000 bananas 1000 miles — how many survive the trip?',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You have 3000 bananas, a camel, and a market that is 1000 miles away. '
        'The camel can carry at most 1000 bananas at a time, and it eats 1 '
        'banana for every mile it walks — whether it is heading toward the '
        'market or back. Because it can carry only 1000 at once, you will have '
        'to move the bananas forward in stages, shuttling back and forth and '
        'leaving piles along the way to pick up later.\n\n'
        'Playing this as cleverly as possible, what is the greatest number of '
        'bananas you can get all the way to the market?',
    rules: const [
      'The camel carries at most 1000 bananas per trip.',
      'The camel eats 1 banana for each mile it walks, in either direction.',
      'You may drop bananas at any point and collect them later.',
      'You start with 3000 bananas and the market is 1000 miles away.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 533, unit: 'bananas'),
    hints: const [
      'With 3000 bananas you cannot carry them all at once — while a pile is '
          'still above 1000, how many loaded trips forward must you make?',
      'To advance the whole hoard one mile while making several passes over it, '
          'how many bananas does each mile cost — and when does that cost drop?',
      'At which pile sizes does the number of trips step down, and how far can '
          'you push the hoard before each of those drops?',
    ],
    whyExplanation:
        'While you hold more than 2000 bananas you need 3 loads forward plus 2 '
        'returns = 5 trips per mile, burning 5 bananas per mile. It takes 200 '
        'miles to eat 1000 and drop to 2000 (cost 5 x 200 = 1000). From 2000 '
        'down toward 1000 you need 2 loads forward plus 1 return = 3 trips per '
        'mile, burning 3 per mile; another 1000 bananas is eaten over 333 more '
        'miles, leaving about 1000 bananas at roughly mile 533. For the final '
        'stretch a single load carries the 1000 bananas the remaining '
        '1000 - 533 = 467 miles, eating 467. That delivers 1000 - 467 = 533 '
        'bananas.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'twelve-coins',
    title: 'The Twelve Coins',
    tagline: 'One fake coin, unknown heavy or light — find it on a balance.',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You have 12 coins that look identical. Exactly one is counterfeit and '
        'weighs slightly different from the rest — but you do not know whether '
        'the fake is heavier or lighter than a genuine coin. Your only tool is '
        'a balance scale, which compares whatever you put in its two pans and '
        'tells you which side is heavier, or that the two sides are equal. You '
        'must identify the counterfeit coin AND determine whether it is heavy or '
        'light.\n\n'
        'What is the smallest number of weighings that is guaranteed to work no '
        'matter which coin is fake?',
    rules: const [
      'Exactly one of the 12 coins is fake; the other 11 weigh the same.',
      'You do not know in advance whether the fake is heavier or lighter.',
      'Each weighing reports left-heavier, right-heavier, or balanced.',
      'You must name the fake coin and say whether it is heavy or light.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 3, unit: 'weighings'),
    hints: const [
      'Each weighing has three possible outcomes. In n weighings, how many '
          'different outcome sequences are there?',
      'There are 12 coins, and for each there are two possibilities — heavy or '
          'light. How many total cases must your plan tell apart?',
      'How could you choose the first weighing so that every one of its three '
          'outcomes leaves a case you can still finish in the weighings that '
          'remain?',
    ],
    whyExplanation:
        'Each weighing has 3 outcomes — left down, right down, or balanced — so '
        'n weighings can distinguish at most 3^n cases. You must pin down which '
        'of 12 coins is fake and whether it is heavy or light, which is 24 '
        'possibilities. Since 3^2 = 9 is less than 24 but 3^3 = 27 is at least '
        '24, two weighings cannot guarantee an answer while three can. A '
        'careful scheme (start 4 coins against 4, then regroup while tracking '
        'which coins are "suspected heavy" versus "suspected light") always '
        'isolates the fake and its direction in exactly 3 weighings.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'secretary-problem',
    title: 'The Secretary Problem',
    tagline: 'Interview in random order — when should you stop looking?',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You must hire one assistant from 100 applicants. You interview them '
        'one at a time in a completely random order. Right after each interview '
        'you must decide on the spot: hire this person and stop, or reject them '
        'forever with no way to call them back. You can only rank the people you '
        'have already interviewed against one another, and your single goal is '
        'to end up hiring the very best applicant of all 100. The strategy is to '
        'automatically reject a first batch of candidates, no matter how strong '
        'they seem, and then hire the first later candidate who is better than '
        'everyone seen so far.\n\n'
        'How many candidates should you reject in that first batch to give '
        'yourself the best possible chance of landing the single best applicant?',
    rules: const [
      'All 100 are interviewed one at a time in a uniformly random order.',
      'After each interview you must immediately hire and stop, or reject '
          'forever.',
      'You can only rank candidates against those already interviewed.',
      'Success means hiring the single best of all 100.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 37, unit: 'candidates'),
    hints: const [
      'Reject too few and you have little to compare against; reject too many '
          'and the best may already be gone. What are you trading off?',
      'If you reject the first r and then take the next record-breaker, the '
          'best is caught only when the best of the sample sits somewhere in '
          'those first r. How does the chance of winning depend on r?',
      'As the number of candidates grows large, what famous mathematical '
          'constant does the ideal fraction to reject approach?',
    ],
    whyExplanation:
        'This is the classic "look, then leap" strategy. You spend the first '
        'group purely gathering information — rejecting everyone but remembering '
        'the best so far — then hire the first candidate who beats that '
        'benchmark. If you reject the first r of n, the probability of ending '
        'up with the very best is (r / n) x (1 / r + 1 / (r + 1) + ... + '
        '1 / (n - 1)). Maximizing over r, the optimal cutoff approaches n / e '
        'as n grows, and the best-case success probability approaches '
        '1 / e, about 37%. For n = 100 the optimum is to reject the first 37 '
        '(since 100 / e is about 36.8), then take the next candidate better '
        'than all 37.',
    comingSoon: false,
  ),
  Puzzle(
    id: 'handshake-couples',
    title: 'The Handshake Party',
    tagline: 'Nine different handshake counts — how many did your spouse make?',
    category: PuzzleCategory.math,
    difficulty: 5,
    prompt:
        'You and your spouse attend a party along with four other couples — ten '
        'people in all. During the party people shake hands, but nobody shakes '
        'their own hand or their spouse\'s hand, and no two people shake hands '
        'with each other more than once. Afterward you ask each of the other '
        'nine people — everyone except yourself — how many hands they shook. '
        'Remarkably, all nine give you a different number.\n\n'
        'Given that, how many hands did your spouse shake?',
    rules: const [
      'There are five couples: you and your spouse plus four other couples, ten '
          'people in all.',
      'No one shakes their own or their spouse\'s hand.',
      'No pair of people shakes hands more than once.',
      'The nine people you asked all reported different counts.',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 4, unit: 'handshakes'),
    hints: const [
      'What is the full range of hands one person could possibly shake here? '
          'Since the nine answers are all different, what must those nine '
          'numbers be?',
      'Think about the person who shook the most hands and the person who shook '
          'the fewest. Who must be married to whom, and why?',
      'If you keep pairing the highest remaining count with the lowest into '
          'couples, where do you and your spouse end up?',
    ],
    whyExplanation:
        'Each person can shake between 0 and 8 hands (everyone except '
        'themselves and their spouse), so the nine different answers must be '
        'exactly 0, 1, 2, 3, 4, 5, 6, 7, and 8. The person who shook 8 shook '
        'everyone they possibly could, so everyone except their spouse shook '
        'that person\'s hand — which forces the person who shook 0 to be the '
        '8-shaker\'s spouse. Peeling that couple away, the 7-shaker and the '
        '1-shaker must likewise be married, then 6 with 2, and 5 with 3. That '
        'leaves the person who shook 4 as the only one of the nine not in such '
        'a high-low pair, so their partner is you. Your spouse shook 4 hands.',
    comingSoon: false,
  ),
];
