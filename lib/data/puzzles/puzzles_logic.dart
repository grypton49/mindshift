import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// Hard logic & game-theory puzzles.
///
/// Pure DATA only: each entry states a scenario and a question, offers a private
/// reasoning scratchpad, and locks the correct conclusion. No prompt or hint
/// leaks the method or the answer — the human does the thinking. The
/// [Puzzle.whyExplanation] (shown only after solving) may be explicit.
final List<Puzzle> logicPuzzles = <Puzzle>[
  // 1 ------------------------------------------------------------------------
  Puzzle(
    id: 'blue-eyed-islanders',
    title: 'The Blue-Eyed Islanders',
    tagline: 'A single spoken sentence sets a silent clock ticking.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'An island holds 200 perfect logicians: 100 have blue eyes and 100 '
        'have brown eyes. Each person can see everyone else\'s eyes but never '
        'their own — there are no mirrors, no reflections, and absolutely no '
        'communication about eye colour of any kind. There is one iron rule: '
        'the instant anyone works out their own eye colour, they must leave the '
        'island that very midnight, and everyone sees who has left. One day a '
        'visitor stands before all 200 and says aloud, "At least one of you '
        'has blue eyes." Everyone hears it. On which night do all the '
        'blue-eyed islanders finally leave?',
    rules: <String>[
      'Every islander is a flawless logician and reasons about what others can '
          'and cannot deduce.',
      'Nobody may hint at, gesture about, or discuss anyone\'s eye colour.',
      'A person leaves only on a midnight after which they have logically '
          'proven their own colour — never on a guess.',
      'Count the first midnight after the announcement as night 1.',
    ],
    hints: <String>[
      'What would happen if there were only 1 blue-eyed person? On which night '
          'would they leave, and why does the announcement matter to them?',
      'Now suppose there were exactly 2 blue-eyed people. What does each one '
          'expect the other to do on night 1, and what does surviving that '
          'night tell them?',
      'If the pattern holds for 2, then 3, then 4… how does the leaving night '
          'relate to the number of blue-eyed people?',
    ],
    whyExplanation:
        'Reason by induction on the number of blue-eyed people. If there were '
        'just 1, that person would see no other blue eyes; the announcement '
        '("at least one") tells them it must be their own, so they leave on '
        'night 1. If there were 2, each sees exactly 1 other blue-eyed person '
        'and reasons: "If I am not blue, that other person is the only one and '
        'will leave on night 1." When night 1 passes with no departure, each '
        'learns they too must be blue, so both leave on night 2. The same logic '
        'extends: with k blue-eyed people, each sees k−1 others and expects '
        'them to leave on night k−1; when that night passes without anyone '
        'leaving, all k realise their own eyes are blue and leave together on '
        'night k. With 100 blue-eyed islanders, that is night 100.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 100, unit: 'nights'),
  ),

  // 2 ------------------------------------------------------------------------
  Puzzle(
    id: 'pirates-gold',
    title: 'The Pirates and the Gold',
    tagline: 'The most senior pirate is far greedier than he looks.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'Five perfectly rational, perfectly greedy pirates — ranked 1 (most '
        'senior) down to 5 (most junior) — must divide 100 gold coins. The '
        'most senior surviving pirate proposes how to split the coins, then '
        'every pirate still alive (including the proposer) votes yes or no. If '
        'at least half vote yes, the split happens and the game ends. If fewer '
        'than half vote yes, the proposer is thrown overboard and the next most '
        'senior pirate makes a new proposal, and so on. Every pirate wants, in '
        'strict priority order, first to gain as much gold as possible, then to '
        'stay alive, and finally — all else equal — to see other pirates thrown '
        'overboard. Assuming everyone reasons flawlessly, how many coins does '
        'the most senior pirate keep for himself?',
    rules: <String>[
      'A proposal passes when yes-votes are at least half of the pirates still '
          'alive (a tie counts as passing).',
      'Preferences in strict order: more gold first, then survival, then '
          'seeing others die.',
      'Every pirate knows every other pirate reasons perfectly, and coins are '
          'indivisible whole units.',
    ],
    hints: <String>[
      'What happens if only the two most junior pirates remain? How must the '
          'more senior of the two vote to survive, and why?',
      'Work backwards: once you know the outcome with 2 pirates, what is the '
          'cheapest way a proposer with 3 can buy exactly the votes he needs?',
      'To pass a proposal, whose single vote is cheapest to win — someone who '
          'would get nothing if this proposer were thrown overboard?',
    ],
    whyExplanation:
        'Solve by backward induction. With only pirates 4 and 5 left, pirate 4 '
        'proposes to keep all 100 (his own vote is half of two, so it passes); '
        'pirate 5 gets nothing. So pirate 5 dreads reaching that stage. With '
        'pirates 3, 4, 5, pirate 3 needs just one other vote: he offers pirate '
        '5 a single coin (better than the zero pirate 5 would get if 3 dies), '
        'keeping 99 (pirate 4 gets nothing). With pirates 2–5, pirate 2 needs '
        'just one vote besides his own — he buys pirate 4 with a single coin '
        '(pirate 4 would get 0 if pirate 3 ends up proposing), keeping 99. '
        'Finally, with all five, pirate 1 needs two extra votes; he gives 1 coin '
        'each to pirates 3 and 5 (who would otherwise get nothing under pirate '
        '2\'s plan), and they accept. Pirate 1 keeps 98 coins.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 98, unit: 'coins'),
  ),

  // 3 ------------------------------------------------------------------------
  Puzzle(
    id: 'prisoners-boxes',
    title: 'The 100 Prisoners and the Boxes',
    tagline: 'A hopeless-looking gamble has a startlingly good strategy.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'A hundred prisoners are numbered 1 to 100. In a room sit 100 identical '
        'boxes, and inside each box is a slip bearing one of the numbers 1 to '
        '100 — every number appears exactly once, placed at random. One at a '
        'time, each prisoner enters the room alone and may open at most 50 '
        'boxes, looking for the slip that carries their own number. Boxes are '
        'left exactly as found and no messages can be passed between prisoners. '
        'Every single prisoner must find their own number, or all 100 are '
        'executed. The prisoners may agree on a plan beforehand. With the best '
        'possible strategy, what is the chance all 100 prisoners go free?',
    rules: <String>[
      'Each prisoner opens at most 50 of the 100 boxes and cannot rearrange or '
          'mark anything.',
      'Prisoners cannot communicate once the searching begins.',
      'They all go free only if every prisoner finds their own number.',
    ],
    hints: <String>[
      'If each prisoner just opened 50 boxes at random, the odds would be '
          '½ to the 100th power. What structure could link the prisoners\' '
          'searches so their fates rise and fall together instead of '
          'independently?',
      'What if a prisoner starts at the box matching their own number, then '
          'goes to the box whose label equals the slip they just found, and '
          'repeats? What kind of path does that trace through the boxes?',
      'Under that following strategy, the only way a prisoner fails is if their '
          'path is too long. What single property of the random arrangement '
          'decides whether everyone succeeds?',
    ],
    whyExplanation:
        'The arrangement of slips is a random permutation, which decomposes '
        'into cycles. If each prisoner starts at the box matching their own '
        'number and then follows the chain — open box labelled with the number '
        'you last found, repeat — each prisoner walks the cycle that contains '
        'their own number and is guaranteed to reach their slip in exactly the '
        'length of that cycle. So a prisoner fails only if their cycle is '
        'longer than 50. Crucially, a permutation of 100 elements can contain '
        'at most one cycle longer than 50, so either everyone succeeds or they '
        'all fail for the same reason. The probability that some cycle exceeds '
        'length 50 is 1/51 + 1/52 + … + 1/100 ≈ 0.688, so the prisoners all go '
        'free with probability 1 − 0.688 ≈ 0.312, about 31%.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question:
          'With the best possible strategy, what is the chance all 100 '
          'prisoners go free?',
      options: <String>[
        'About 31%',
        'About 50%',
        'About one in a million',
        'Essentially zero (½ to the 100th)',
      ],
      correctIndex: 0,
    ),
  ),

  // 4 ------------------------------------------------------------------------
  Puzzle(
    id: 'prisoners-lightbulb',
    title: 'The Prisoners and the Lightbulb',
    tagline: 'One switch, one room, and a plan that must never fail.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'A hundred prisoners are held in separate cells. There is one central '
        'room containing a single light with an on/off switch. One at a time, '
        'in a completely random order chosen by the warden, prisoners are taken '
        'into the room; a prisoner may toggle the light or leave it, then is '
        'returned to their cell. This continues indefinitely, and every '
        'prisoner is guaranteed to visit the room again and again without limit. '
        'At any visit, a prisoner may declare, "Every prisoner has now visited '
        'this room." If the declaration is true, all are freed; if it is false, '
        'all are executed. The prisoners can agree on a strategy beforehand but '
        'cannot communicate afterwards except through the light, and they do '
        'not know the light\'s starting state. Can they guarantee that they '
        'will all eventually be freed?',
    rules: <String>[
      'The order of visits is arbitrary, but each prisoner visits infinitely '
          'often.',
      'The only shared signal after the start is the state of the single '
          'light.',
      'A wrong declaration kills everyone, so the plan must be certain, not '
          'likely.',
    ],
    hints: <String>[
      'The light carries only one bit at a time. Would it help to give the '
          'prisoners unequal roles rather than treating them all the same?',
      'Suppose exactly one prisoner is allowed to turn the light off and '
          'counts each time they do. What must the other 99 prisoners do so '
          'that each off-turn represents a distinct newcomer?',
      'How can you protect against not knowing the light\'s starting state, so '
          'the counter never counts the same person twice or is fooled by the '
          'initial setting?',
    ],
    whyExplanation:
        'Yes. Beforehand they appoint one prisoner as the "counter." Every '
        'other prisoner follows this rule: the first two times they enter and '
        'find the light on, they turn it off; otherwise they leave it alone. '
        '(Using two turn-offs per person handles not knowing the initial '
        'state.) The counter, and only the counter, turns the light on whenever '
        'they find it off, adding one to a private tally each time. Because '
        'every non-counter turns the light off a fixed total number of times '
        'and each such off is switched back on and counted exactly once by the '
        'counter, the tally rises by exactly the intended amount only after '
        'each of the other 99 prisoners has visited. When the counter\'s tally '
        'reaches the agreed total (2 × 99 = 198 off-turns), they know every '
        'prisoner has been in the room and can safely declare it. Since each '
        'prisoner visits infinitely often, this count is reached with '
        'certainty.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Can they guarantee that they will all eventually be freed?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: true,
    ),
  ),

  // 5 ------------------------------------------------------------------------
  Puzzle(
    id: 'guess-two-thirds',
    title: 'Two-Thirds of the Average',
    tagline: 'When everyone out-thinks everyone, where does it end?',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'A large group of players each secretly writes down a real number '
        'between 0 and 100, inclusive. Once every choice is in, the average of '
        'all the numbers is computed, and the winner is whoever chose the '
        'number closest to exactly two-thirds of that average. Every player is '
        'perfectly rational, and it is common knowledge that all players are '
        'perfectly rational — each knows the others are reasoning just as '
        'carefully as they are. If you want to guarantee you are playing the '
        'uniquely rational choice, what number should you write down?',
    rules: <String>[
      'Choices are made simultaneously and in secret; you cannot react to '
          'others.',
      'The target is two-thirds of the average of everyone\'s numbers.',
      'Every player is rational, and everyone knows everyone is rational, '
          'without limit.',
    ],
    hints: <String>[
      'The average can be at most 100, so two-thirds of it can be at most about '
          '67. Can it ever be rational to pick a number above that ceiling?',
      'If no rational player would ever pick above 67, what new ceiling does '
          'that impose on the target — and then on the next round of '
          'reasoning?',
      'Keep applying that step. Where is the only number that survives the '
          'reasoning no matter how many times you repeat it?',
    ],
    whyExplanation:
        'Use iterated elimination of dominated strategies. The average is at '
        'most 100, so the target (two-thirds of the average) is at most about '
        '66.7 — any number above that can never win, so no rational player '
        'picks above it. But if everyone reasons that way, all choices lie '
        'below 66.7, making the target at most about 44.4; that eliminates '
        'everything above 44.4, and so on. Each round multiplies the ceiling by '
        'two-thirds, and repeated indefinitely by perfectly rational players '
        'who know everyone reasons this way, the only number that survives — '
        'the unique Nash equilibrium — is 0. If everyone picks 0, the target is '
        '0, and no one can do better by deviating.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 0),
  ),

  // 6 ------------------------------------------------------------------------
  Puzzle(
    id: 'josephus',
    title: 'The Circle of 100',
    tagline: 'Every second person falls. Where do you want to stand?',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'One hundred people stand in a circle, numbered 1 to 100 in order. The '
        'counting begins at person 1, and every second person is eliminated: '
        'person 2 goes first, then 4, then 6, and so on around the circle. The '
        'counting keeps going round and round — skipping those already gone — '
        'always removing every second remaining person, until just one person '
        'is left standing. Which numbered position is the sole survivor?',
    rules: <String>[
      'The circle is counted continuously; after 100 the count wraps back to '
          'the lowest remaining number.',
      'Exactly every second remaining person is removed, starting by removing '
          'person 2.',
      'The process ends when only one person remains.',
    ],
    hints: <String>[
      'Try tiny circles first. Where does the survivor land when the group size '
          'is exactly a power of two, such as 2, 4, or 8?',
      'For sizes that are a power of two, the survivor is always position 1. '
          'How might you write 100 as a power of two plus a remainder?',
      'If 100 = 64 + 36, how far past position 1 does that leftover of 36 push '
          'the survivor, given people are removed two at a time?',
    ],
    whyExplanation:
        'This is the Josephus problem with every second person eliminated. When '
        'the number of people is exactly a power of two, the survivor is always '
        'position 1, because the first full pass removes all even positions and '
        'leaves the counting poised to start again cleanly at 1. For a general '
        'count n, write n = 2^m + L, where 2^m is the largest power of two not '
        'exceeding n and L is the remainder. The survivor is then 2L + 1. Here '
        'n = 100 = 64 + 36, so 2^m = 64 and L = 36, giving 2 × 36 + 1 = 73. '
        'Position 73 is the sole survivor.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 73),
  ),

  // 7 ------------------------------------------------------------------------
  Puzzle(
    id: 'two-generals',
    title: 'The Two Generals',
    tagline: 'Two armies, one plan, and a valley full of doubt.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'Two allied generals have their armies camped on opposite hills, with '
        'an enemy city in the valley between them. They can defeat the enemy '
        'only if both armies attack at exactly the same time; if just one '
        'attacks alone, that army is destroyed. The generals can coordinate '
        'only by sending messengers who must cross the valley, where any '
        'messenger may be captured, so any message might simply never arrive. A '
        'general can send as many messengers as they like, including messengers '
        'confirming that a message was received, and confirming the '
        'confirmation, and so on. Working only through this unreliable channel, '
        'can they GUARANTEE a coordinated attack?',
    rules: <String>[
      'Victory requires both armies to attack at the same agreed time; a solo '
          'attack fails.',
      'Every messenger, including any acknowledgement, may be lost with no '
          'warning.',
      'A general commits to attack only if certain the other will attack too.',
    ],
    hints: <String>[
      'Suppose one general sends "attack at dawn." Before committing, why would '
          'they wait for confirmation that the message arrived?',
      'When that confirmation is sent back, does its sender now face exactly '
          'the same uncertainty the first general just faced? Who needs to '
          'confirm the confirmation?',
      'Does adding one more acknowledgement ever remove the doubt of the last '
          'sender, or does it just move the doubt to someone new — forever?',
    ],
    whyExplanation:
        'No — coordination cannot be guaranteed, and this is provably '
        'impossible. Suppose some finite sequence of messages would let both '
        'generals safely attack. Consider the very last message that must '
        'arrive for the plan to work. Its sender cannot know whether it was '
        'received, so they cannot rely on it — meaning that last message was '
        'not actually needed, contradicting the assumption that it was the last '
        'required one. Removing it and repeating the argument eliminates every '
        'message, which is absurd. The deep reason is that a coordinated attack '
        'requires common knowledge (each knows the other will attack, and each '
        'knows that the other knows, without end), but an unreliable channel '
        'can never build that infinite tower of certainty in finitely many '
        'messages. So no protocol can guarantee a coordinated attack.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Can they GUARANTEE a coordinated attack?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: false,
    ),
  ),

  // 8 ------------------------------------------------------------------------
  Puzzle(
    id: 'knights-knaves',
    title: 'Knights and Knaves',
    tagline: 'Truth-tellers and liars, and one sentence that gives it away.',
    category: PuzzleCategory.lateral,
    difficulty: 5,
    prompt:
        'On a certain island, every inhabitant is either a knight, who always '
        'tells the truth, or a knave, who always lies. You meet three of them, '
        'called A, B, and C. A declares, "All three of us are knaves." B '
        'declares, "Exactly one of us is a knight." C says nothing at all. '
        'Using only these statements, who is the knight?',
    rules: <String>[
      'Each person is either a knight (always truthful) or a knave (always '
          'lying).',
      'A knight\'s statement must be entirely true; a knave\'s statement must '
          'be entirely false.',
      'Reason only from the two statements given; C stays silent.',
    ],
    hints: <String>[
      'Start with A\'s claim. Could a knight ever truthfully say "all three of '
          'us are knaves"? What does that force A to be?',
      'Once you fix what A must be, count the knights that implies and check it '
          'against B\'s statement. Is B\'s claim then true or false?',
      'Test each remaining possibility for B and C against both statements. '
          'Which single assignment leaves no contradiction?',
    ],
    whyExplanation:
        'First examine A. If A were a knight, then A\'s statement "all three of '
        'us are knaves" would have to be true — but that would make A a knave, '
        'a contradiction. So A cannot be a knight; A is a knave, and A\'s '
        'statement is therefore false (so it is not the case that all three are '
        'knaves — at least one is a knight). Now consider B\'s claim, "exactly '
        'one of us is a knight." Since A is a knave, the knight(s) are among B '
        'and C. If B were a knave, B\'s statement would be false, so the number '
        'of knights would not be exactly one; but with A a knave that would '
        'force both B and C to be knaves, meaning zero knights — contradicting '
        'that at least one is a knight. So B must be a knight, B\'s statement is '
        'true, exactly one of the three is a knight, and that one is B (with A '
        'and C both knaves). The knight is B.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'Who is the knight?',
      options: <String>['A', 'B', 'C', 'It cannot be determined'],
      correctIndex: 1,
    ),
  ),

  // 9 ------------------------------------------------------------------------
  Puzzle(
    id: 'line-of-hats',
    title: 'The Line of 100 Hats',
    tagline: 'One person gambles so the other ninety-nine never have to.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'A hundred prisoners are made to stand in a single line. Each is given '
        'a hat that is either red or blue, assigned however the warden likes. '
        'Every prisoner can see the hats of all the people standing in front of '
        'them, but not their own hat and none of the hats behind them. Starting '
        'from the very back of the line, each prisoner in turn must call out a '
        'single word, "red" or "blue," and this call is heard by everyone. A '
        'prisoner is freed if the colour they call matches their own hat, and '
        'the calls carry no hidden meaning beyond the colour word itself. The '
        'prisoners agree on a strategy in advance. Using the best possible '
        'plan, how many prisoners can they GUARANTEE to save?',
    rules: <String>[
      'Each prisoner sees every hat in front of them but never their own or any '
          'behind.',
      'Calls happen from the back of the line forward, and everyone hears every '
          'call.',
      'Only the colour word may be spoken — no tone, timing, or other signal.',
    ],
    hints: <String>[
      'The very last person to be seen can gain no information about their own '
          'hat. Could you spend that one person\'s call to send information to '
          'everyone else?',
      'What if the rearmost prisoner announces something summarising all the '
          'hats they can see — such as whether the number of red hats ahead is '
          'odd or even?',
      'Given that shared summary plus every call they hear afterwards, how can '
          'each later prisoner pin down their own colour exactly?',
    ],
    whyExplanation:
        'They can guarantee 99. The prisoner at the very back sees all 99 hats '
        'in front and calls a colour that encodes the parity of the red hats '
        'they see — for example, "red" if the number of red hats ahead is odd '
        'and "blue" if it is even. This call is a pure signal and only a 50/50 '
        'gamble for that prisoner\'s own hat, so they cannot be guaranteed. But '
        'every other prisoner can now deduce their own hat exactly: each hears '
        'the announced parity, sees the hats still in front of them, and keeps '
        'track of the colours already called out behind them. The only value of '
        'their own hat that is consistent with the announced parity is forced, '
        'so they call it correctly. Thus all 99 prisoners ahead of the '
        'signaller are always saved, and 99 is the most that can be guaranteed.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const NumberEntryAnswerSpec(answer: 99, unit: 'prisoners'),
  ),

  // 10 -----------------------------------------------------------------------
  Puzzle(
    id: 'hex-first-player',
    title: 'The Game of Hex',
    tagline: 'A game that cannot tie hides a secret about moving first.',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    prompt:
        'Hex is played on a rhombic board of hexagonal cells. Two players take '
        'turns placing a stone of their own colour on any empty cell. One '
        'player is trying to connect their two opposite sides of the board with '
        'an unbroken chain of their stones; the other player is trying to '
        'connect the other two opposite sides with theirs. A fundamental fact '
        'about Hex is that the board can never end in a draw: once every cell is '
        'filled, exactly one of the two players has completed a connecting '
        'chain. Given perfect play, does the first player have a guaranteed '
        'winning strategy?',
    rules: <String>[
      'Players alternate placing stones on empty cells; stones are never moved '
          'or removed.',
      'Each player wins only by linking their own pair of opposite sides.',
      'Hex can never be a draw — when the board is full, exactly one player has '
          'connected their sides.',
    ],
    hints: <String>[
      'Since the game can never tie, exactly one player must have a winning '
          'strategy. Suppose, for the sake of argument, it were the second '
          'player.',
      'If the second player had a winning strategy, could the first player '
          'quietly "borrow" it by making an arbitrary first move and then '
          'pretending to be the second player?',
      'In this game, can having one extra stone already on the board ever hurt '
          'you? If not, what does that do to the assumption you were testing?',
    ],
    whyExplanation:
        'Yes — the first player has a guaranteed winning strategy, shown by a '
        'strategy-stealing argument. Because Hex can never be a draw, exactly '
        'one player must have a winning strategy. Suppose it were the second '
        'player. Then the first player could steal it: make any arbitrary first '
        'move, then simply follow the second player\'s winning strategy as if '
        'they were the second player, ignoring their extra stone. In Hex an '
        'extra stone of your own colour can never be a disadvantage — it can '
        'only help connect your sides — so having placed one already is at '
        'worst harmless. This means the first player could guarantee a win, '
        'contradicting the assumption that the second player had the winning '
        'strategy. Therefore it must be the first player who holds the winning '
        'strategy. The argument is non-constructive: it proves a winning '
        'strategy exists without revealing what it is, which is why no explicit '
        'strategy is known for large boards.',
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Does the first player have a guaranteed winning strategy?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: true,
    ),
  ),
];
