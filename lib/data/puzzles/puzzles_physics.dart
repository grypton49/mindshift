import '../models/puzzle.dart';
import '../models/puzzle_category.dart';

/// The MindShift "physics" puzzle set: seven counterintuitive physics problems
/// (each solved with the pure-reasoning sandbox) plus three tactile puzzles that
/// share the reusable interactive mechanics (nim, lever, number tiles).
///
/// Pure DATA only — no reasoning or verdicts live here. Prompts state the setup
/// and the question; hints are opt-in QUESTIONS; each [whyExplanation] is shown
/// ONLY after the player has committed the correct answer themselves.
final List<Puzzle> physicsPuzzles = <Puzzle>[
  // 1 ------------------------------------------------------------------------
  Puzzle(
    id: 'boat-and-rock',
    title: 'The Boat and the Rock',
    tagline: 'Drop the rock overboard — does the pool rise, fall, or hold?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You are sitting in a small rowboat, floating in a swimming pool. In '
        'your lap is a heavy rock — so dense it sinks like a stone. You lift the '
        'rock and drop it over the side. It plunges straight to the bottom of '
        'the pool and settles there, while the boat, now lighter, rides a little '
        'higher. What happens to the pool’s water level?',
    rules: const [
      'The boat stays afloat the whole time.',
      'The rock is denser than water and sinks completely to the bottom.',
      'No water splashes out of the pool.',
    ],
    hints: const [
      'While the rock rides in the boat, how much water does its weight push aside?',
      'Once the rock is on the bottom, is it the rock’s weight or its volume that sets how much water it displaces?',
      'For a rock denser than water, which is bigger — a volume of water that weighs as much as the rock, or the rock itself?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'What happens to the pool\'s water level?',
      options: ['It rises', 'It falls', 'It stays the same'],
      correctIndex: 1,
    ),
    whyExplanation:
        'The level falls. While the rock rides in the boat, the boat floats a '
        'little lower and displaces an extra volume of water whose WEIGHT equals '
        'the rock’s weight. Once the rock sinks, it displaces only its own '
        'VOLUME of water. Because the rock is denser than water, a volume of '
        'water heavy enough to match the rock is LARGER than the rock itself — '
        'so tossing it overboard removes more displacement than it adds, and the '
        'water level drops.',
  ),

  // 2 ------------------------------------------------------------------------
  Puzzle(
    id: 'helium-balloon-car',
    title: 'The Balloon in the Car',
    tagline:
        'The car lurches forward. Everything leans back — except one thing.',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A helium balloon on a light string is tied to the floor of a car, so '
        'it floats upright, straining toward the roof. Every window is shut, so '
        'the air inside is sealed in with the balloon. The car waits at a red '
        'light; the light turns green and the car accelerates smoothly forward. '
        'You — and everything loose — feel pressed back into your seat. Which '
        'way does the balloon lean as the car speeds up?',
    rules: const [
      'The car accelerates forward in a straight line.',
      'The windows are closed, so the cabin air moves with the car.',
      'The string keeps the balloon from touching the roof.',
    ],
    hints: const [
      'When the car accelerates, which way does the surrounding air tend to get thrown?',
      'If the denser air piles up toward the back, where is the air pressure now higher?',
      'A helium balloon is always pushed toward LOWER pressure — where has that ended up?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'Which way does the balloon lean?',
      options: ['Backward', 'Forward', 'It stays upright'],
      correctIndex: 1,
    ),
    whyExplanation:
        'It leans forward — the opposite of everything else. When the car '
        'accelerates, the ordinary air in the cabin, which is far denser than '
        'the helium, gets thrown toward the back, just as you are. That raises '
        'the air pressure at the rear and lowers it at the front. A balloon is '
        'pushed by the surrounding air from high pressure toward low pressure — '
        'that is exactly what buoyancy is, the same effect that makes it rise '
        'against gravity. So it tilts FORWARD, into the low-pressure region, '
        'leaning the same way the car accelerates.',
  ),

  // 3 ------------------------------------------------------------------------
  Puzzle(
    id: 'falling-slinky',
    title: 'The Falling Slinky',
    tagline: 'Let go of the top. What does the bottom do first?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You hold a Slinky by its top coil and let it dangle. Under its own '
        'weight it stretches into a long spring and hangs perfectly still. Then '
        'you open your fingers and let it drop. In the very first instant after '
        'you release the top — before the spring has had any time to collapse — '
        'what does the BOTTOM of the Slinky do?',
    rules: const [
      'The Slinky hangs fully stretched and motionless before release.',
      'Only the top coil is let go; nothing touches the bottom.',
      'Consider only the first instant after release.',
    ],
    hints: const [
      'Before release, what forces act on the bottom coil, and why does it hang motionless?',
      'Does letting go of the top instantly change the stretch — and therefore the tension — down near the bottom?',
      'How fast can the "news" that the top was released actually travel down the spring?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question:
          'The instant after release, what does the BOTTOM of the slinky do?',
      options: ['Falls immediately', 'Rises', 'Stays still for a moment'],
      correctIndex: 2,
    ),
    whyExplanation:
        'The bottom stays still for a moment. While the Slinky hangs stretched, '
        'the bottom coil is held up by the spring tension pulling it upward, '
        'which exactly cancels gravity pulling it down — that balance is why it '
        'hangs motionless. Letting go removes your hand’s force at the TOP, '
        'but it does not instantly change the stretch, and so the tension, near '
        'the bottom. That upward pull still balances gravity there until the '
        'collapsing top physically arrives. The information that "the top was '
        'released" can travel down no faster than the spring can collapse — so '
        'the bottom simply hovers in place until the falling top catches up to '
        'it, then they drop together.',
  ),

  // 4 ------------------------------------------------------------------------
  Puzzle(
    id: 'bicycle-pedal',
    title: 'The Backward Pedal',
    tagline: 'Pull the low pedal backward. Which way does the bike roll?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A bicycle stands upright on level ground while a friend holds it steady '
        'so it cannot tip over. One pedal is at its lowest point, hanging '
        'straight down. You crouch beside the bike, take hold of that low pedal, '
        'and gently pull it horizontally backward — toward the rear wheel. The '
        'bike is free to roll. Which way does it roll?',
    rules: const [
      'The bike is held upright but free to roll forward or backward.',
      'You pull the lowest pedal horizontally toward the back of the bike.',
      'The chain and gears are engaged as normal.',
    ],
    hints: const [
      'When you ride this bike forward, which way is the bottom pedal moving relative to the frame?',
      'Are you pulling the pedal backward relative to the frame, or relative to the ground?',
      'For each full turn of the pedals, how far does the bike travel along the ground compared with how far the pedal swings around its little circle?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'When the lower pedal is pulled straight back, the bicycle…',
      options: ['Rolls forward', 'Rolls backward', 'Stays put'],
      correctIndex: 1,
    ),
    whyExplanation:
        'It rolls backward — toward you, in the direction of your pull. Here is '
        'the trap: when you ride forward, the pedal at the bottom of its stroke '
        'is sweeping backward relative to the bike frame, so "pedal going '
        'backward" feels like it should mean "bike going forward." But you are '
        'pulling the pedal backward relative to the GROUND, not the frame. '
        'Because the wheels are geared, one turn of the cranks rolls the whole '
        'bike a long way — the bottom bracket travels far more than the pedal '
        'swings around its little circle. So as you drag the pedal backward, the '
        'entire bike slides backward faster than the crank can wind forward, and '
        'the bike rolls backward with your hand.',
  ),

  // 5 ------------------------------------------------------------------------
  Puzzle(
    id: 'mpemba',
    title: 'The Mpemba Effect',
    tagline: 'Could a hot cup beat a cold one to ice?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'Two identical open containers go into the same freezer at the same '
        'moment. One holds water that starts out hot, near boiling; the other '
        'holds the same amount of water starting out cold, near room '
        'temperature. Common sense says the cold water has a head start and must '
        'reach the frozen state first. But careful experiments — noted since '
        'antiquity and studied in modern labs — tell a stranger story. Can hot '
        'water sometimes freeze faster than cold water?',
    rules: const [
      'Same freezer, same containers, same amount of water.',
      'The only difference is the starting temperature.',
      '"Freeze faster" means reaching a solid frozen state in less time.',
    ],
    hints: const [
      'Does a hotter container lose heat to its surroundings faster or slower than a cooler one?',
      'Might some of the hot water leave before it ever reaches freezing — so is there really the same amount left to freeze?',
      'Could effects like evaporation, convection currents, dissolved gases, or supercooling differ between the two containers?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const BinaryAnswerSpec(
      question: 'Can hot water sometimes freeze faster than cold water?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: true,
    ),
    whyExplanation:
        'Yes — this is the Mpemba effect, named for the Tanzanian schoolboy '
        'Erasto Mpemba, who noticed it while making ice cream in 1963. Under the '
        'right conditions a hotter sample really can reach the frozen state '
        'before a cooler one. There is no single tidy cause; several effects can '
        'each tip the balance: hot water evaporates more, so less mass is left '
        'to freeze; it stirs up stronger convection currents that shed heat '
        'quickly; it drives off dissolved gases; and the two samples can '
        'supercool to different degrees before ice forms. It does not happen '
        'every time — it depends on the setup — but it happens, which is why '
        '"cold obviously wins" is the wrong bet.',
  ),

  // 6 ------------------------------------------------------------------------
  Puzzle(
    id: 'bullet-drop',
    title: 'The Bullet and the Drop',
    tagline: 'One bullet flies, one just falls. Who lands first?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You stand on a wide, perfectly level field holding two identical '
        'bullets at exactly the same height. At one instant you fire the first '
        'bullet from a gun held perfectly horizontal — it screams away parallel '
        'to the ground — and at that very same instant you simply let the second '
        'bullet drop from your other hand. Ignore air resistance and the curve '
        'of the Earth. Which bullet reaches the ground first?',
    rules: const [
      'Both bullets start at the same height at the same instant.',
      'The fired bullet leaves the barrel perfectly horizontally over level ground.',
      'Ignore air resistance and the Earth’s curvature.',
    ],
    hints: const [
      'Can you treat a bullet’s horizontal motion and its vertical motion completely separately?',
      'Does travelling sideways give the fired bullet any upward push to slow its fall?',
      'What is the vertical starting speed of each bullet at the moment of release?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'Which reaches the ground first?',
      options: [
        'The dropped bullet',
        'The fired bullet',
        'They land at the same time',
      ],
      correctIndex: 2,
    ),
    whyExplanation:
        'They land at the same time. Horizontal and vertical motion are '
        'independent: gravity pulls both bullets downward with the same '
        'acceleration, and neither one starts with any up-or-down speed. The '
        'fired bullet’s enormous forward speed carries it far downrange, '
        'but sideways motion does nothing to hold it up — it cannot fight '
        'gravity. Both bullets begin falling from the same height with zero '
        'vertical velocity, so both take exactly the same time to hit the '
        'ground. The fired one just lands far, far away.',
  ),

  // 7 ------------------------------------------------------------------------
  Puzzle(
    id: 'ice-in-glass',
    title: 'The Melting Ice',
    tagline: 'A brim-full glass, a melting cube. Will it spill?',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A glass is filled to the very brim with water — one more drop would '
        'spill — and a single ice cube floats in it, bobbing partly above the '
        'surface. You leave the glass on the table and watch the ice slowly '
        'melt away completely. As the floating ice turns to water, what happens '
        'to the level in the glass?',
    rules: const [
      'The glass starts filled exactly to the brim, with the ice already floating.',
      'The ice melts completely.',
      'Ignore evaporation and temperature-driven changes in the water’s volume.',
    ],
    hints: const [
      'A floating object pushes aside a WEIGHT of water equal to its own weight — how does that compare to the water the ice will become?',
      'When the ice melts, does its meltwater weigh any more or less than the ice did?',
      'Does the part of the cube poking up above the surface add any water that was not already accounted for?',
    ],
    sandbox: const ReasoningSandboxSpec(),
    answer: const MultipleChoiceAnswerSpec(
      question: 'As the floating ice melts, the water level…',
      options: ['Overflows', 'Drops', 'Stays the same'],
      correctIndex: 2,
    ),
    whyExplanation:
        'The level stays the same — not a drop overflows. A floating ice cube '
        'pushes aside a volume of water whose weight exactly equals the '
        'cube’s own weight. When it melts, the cube becomes water of that '
        'very same weight — and that weight of water takes up precisely the '
        'volume the submerged part of the cube was already displacing. So the '
        'meltwater slots perfectly into the "hole" the ice was making. The bit '
        'poking up above the surface is just the extra room ice takes up by '
        'being less dense than water; it adds no new volume below the line. This '
        'is also why melting sea ice does not, on its own, raise sea level — '
        'unlike ice that sits on land.',
  ),

  // 8 ------------------------------------------------------------------------
  Puzzle(
    id: 'twenty-stone-duel',
    title: 'The Twenty-Stone Duel',
    tagline:
        'Twenty stones, take 1–3, last one wins. First move — can you win?',
    category: PuzzleCategory.gameTheory,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A pile of 20 stones sits between you and a flawless opponent. You take '
        'turns; on each turn a player removes 1, 2, or 3 stones. Whoever picks '
        'up the very last stone wins the duel. You get to move first, and your '
        'opponent never makes a mistake. Going first, can you always force a '
        'win?',
    rules: const [
      'The pile starts with exactly 20 stones.',
      'On your turn you must remove 1, 2, or 3 stones.',
      'Whoever takes the last stone wins.',
      'You move first; your opponent plays perfectly.',
    ],
    hints: const [
      'After you move and your opponent replies, how much can you guarantee the pile has shrunk — and who controls that total?',
      'Is there a "safe" number of stones you would love to hand your opponent at the end of every round?',
      'What is special about 20 when the most you can ever remove in a turn is 3?',
    ],
    sandbox: const NimSandboxSpec(stones: 20, maxTake: 3, lastTakeWins: true),
    answer: const BinaryAnswerSpec(
      question: 'Going first, can you always force a win?',
      optionA: 'Yes',
      optionB: 'No',
      correctIsA: false,
    ),
    whyExplanation:
        'No — with 20 stones you cannot force a win, because 20 is a multiple of '
        '4. Whatever you take (1, 2, or 3), your opponent can always remove '
        'enough to make your two moves add up to exactly 4. So a perfect '
        'opponent keeps handing the pile back to you at the next lower multiple '
        'of 4: 20 → 16 → 12 → 8 → 4 → 0. Eventually you face 4 stones; whatever '
        'you take leaves 1, 2, or 3, and your opponent scoops up the last one. '
        'The player who can leave a multiple of 4 owns the game — and from 20, '
        'moving first, that player is your opponent, not you. (You would want to '
        'move first only when the pile is NOT a multiple of 4.)',
  ),

  // 9 ------------------------------------------------------------------------
  Puzzle(
    id: 'balance-beam',
    title: 'The Stubborn Beam',
    tagline: 'A heavy block will not move. Balance it with a lighter one.',
    category: PuzzleCategory.physics,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'A seesaw-style beam rests on a central pivot. A heavy block weighing 7 '
        'units is fixed to the left arm, 4 units of distance from the pivot — '
        'and it will not budge. On the right arm you have a lighter block '
        'weighing only 4 units, and you can slide it in and out along the beam, '
        'anywhere from 0 to 8 units from the pivot. Slide the right-hand block '
        'to the one spot that makes the beam hang perfectly level.',
    rules: const [
      'The left block weighs 7 units and is fixed 4 units from the pivot.',
      'The right block weighs 4 units and slides between 0 and 8 units from the pivot.',
      'Only the right block can move; place it so the beam balances.',
    ],
    hints: const [
      'What is the left block’s turning effect on the beam — does it depend on its weight alone, or on weight AND distance?',
      'Since the right block is lighter than the left, should it sit closer to the pivot or farther out to match it?',
      'What distance, multiplied by the right block’s weight of 4, equals the left block’s turning effect?',
    ],
    sandbox: const LeverSandboxSpec(
      leftWeight: 7,
      leftDistance: 4,
      rightWeight: 4,
      maxDistance: 8,
    ),
    answer: const GoalAnswerSpec(goalLabel: 'Balance the beam'),
    whyExplanation:
        'A beam balances when the two sides have equal "turning effect" (torque) '
        'about the pivot — and turning effect is weight multiplied by distance '
        'from the pivot, not weight on its own. The left block gives 7 × 4 = 28. '
        'To match that with the lighter 4-unit block, you need 4 × distance = '
        '28, so the distance must be 7 units. The lighter block simply sits '
        'farther out to make up for weighing less — that is the whole secret of '
        'the lever, and why a small child can balance an adult on a seesaw by '
        'sitting right at the end.',
  ),

  // 10 -----------------------------------------------------------------------
  Puzzle(
    id: 'exact-total',
    title: 'The Exact Total',
    tagline: 'Six odd tiles. Hit 53 on the nose.',
    category: PuzzleCategory.math,
    difficulty: 5,
    comingSoon: false,
    prompt:
        'You are given six numbered tiles: 7, 11, 13, 17, 19, and 23. Pick some '
        'of them — any combination you like — so that the numbers on your chosen '
        'tiles add up to exactly 53. Each tile you use counts once; leave out '
        'the ones you do not want. Build a selection that totals precisely 53.',
    rules: const [
      'The tiles available are 7, 11, 13, 17, 19, and 23.',
      'Each tile may be used at most once.',
      'Use as few or as many tiles as you like — the chosen tiles must sum to exactly 53.',
    ],
    hints: const [
      '53 is odd, and every tile is odd — how many odd numbers must you combine to reach an odd total?',
      'Which single tile, subtracted from 53, leaves an amount you can build from the tiles that remain?',
      'If you start with the largest tile, 23, how much more do you still need, and can the smaller tiles reach it?',
    ],
    sandbox: const NumberTilesSandboxSpec(
      tiles: [7, 11, 13, 17, 19, 23],
      target: 53,
    ),
    answer: const ReachTargetAnswerSpec(target: 53),
    whyExplanation:
        'There is more than one way to land on 53 exactly. For example, '
        '13 + 17 + 23 = 53, and so does 11 + 19 + 23 = 53. A useful shortcut: '
        'since 53 is odd and every tile here is odd, you must use an ODD number '
        'of tiles — one, three, or five — because any even count of odd numbers '
        'always sums to an even total. No single tile equals 53, so the shortest '
        'routes use three tiles, as above. The quiet pleasure of this small '
        'subset-sum puzzle is that the "odd total" constraint secretly tells you '
        'how many pieces to look for.',
  ),
];
