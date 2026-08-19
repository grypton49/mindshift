import 'puzzle_category.dart';

/// ============================================================================
/// MindShift puzzle model — the framework contract.
///
/// A [Puzzle] is pure DATA. It never contains reasoning or "the answer" as prose.
/// It gives the player (a) a problem to read, (b) a [SandboxSpec] to experiment
/// in, and (c) an [AnswerSpec] describing how they commit their own conclusion.
///
/// CORE PHILOSOPHY: the human does the thinking. Sandboxes react truthfully to
/// player actions but state NO conclusions. Hints are opt-in nudges phrased as
/// questions. The [whyExplanation] is shown ONLY after the puzzle is solved.
///
/// New puzzles are added as data in `puzzle_registry.dart`, composing the
/// existing sandbox mechanics. Only a genuinely new interaction needs new code.
/// ============================================================================
class Puzzle {
  const Puzzle({
    required this.id,
    required this.title,
    required this.tagline,
    required this.category,
    required this.difficulty,
    required this.prompt,
    required this.sandbox,
    required this.answer,
    this.rules = const [],
    this.hints = const [],
    this.whyExplanation,
    this.comingSoon = false,
  });

  /// Stable unique id (also the persistence key for solved state).
  final String id;

  /// Short display title, e.g. "Tigers & Sheep".
  final String title;

  /// One-line hook shown on the home card.
  final String tagline;

  final PuzzleCategory category;

  /// 1 (gentle) .. 5 (fiendish). Used for display + ordering only.
  final int difficulty;

  /// The full problem statement shown in the puzzle header. States the setup
  /// and the question — never a hint about the method or answer.
  final String prompt;

  /// Bulleted rules/constraints shown under the prompt (may be empty).
  final List<String> rules;

  /// Describes the interactive experiment area. See [SandboxSpec].
  final SandboxSpec sandbox;

  /// Describes how the player commits their answer + the pure correctness check.
  final AnswerSpec answer;

  /// Opt-in, progressive nudges. Each should be a QUESTION that points at HOW to
  /// think ("What happens with just 2?"), never the answer. Shown one at a time.
  final List<String> hints;

  /// Optional "why it works" explanation. The host screen shows this ONLY after
  /// the player has solved the puzzle themselves. Null = no explanation.
  final String? whyExplanation;

  /// When true the puzzle is a placeholder shown as locked/"coming soon".
  final bool comingSoon;
}

/// ============================================================================
/// SandboxSpec — the interactive experiment area.
///
/// Sealed so [PuzzleHostScreen] can exhaustively map each variant to its
/// mechanic widget. Every variant carries only the parameters of the scenario;
/// it must never encode the verdict for a given case.
/// ============================================================================
sealed class SandboxSpec {
  const SandboxSpec();
}

/// Flagship "100 tigers, 1 sheep" sandbox: a dial to pick how many tigers to
/// experiment with (min..max) plus a drag-to-"bite" simulation that faithfully
/// animates the mechanical consequence (eater becomes a sheep) — with no verdict.
/// [questionTigers] is the real count the final question asks about (e.g. 100).
class TigersSandboxSpec extends SandboxSpec {
  const TigersSandboxSpec({
    this.minTigers = 1,
    this.maxTigers = 12,
    this.questionTigers = 100,
  });

  final int minTigers;
  final int maxTigers;
  final int questionTigers;
}

/// Drag/combine number tiles to reach a target. The sandbox shows the running
/// value only; it never suggests which tiles to combine.
class NumberTilesSandboxSpec extends SandboxSpec {
  const NumberTilesSandboxSpec({required this.tiles, required this.target});

  final List<int> tiles;
  final int target;
}

/// A balance-beam sandbox: a fixed weight sits on the left; the player places a
/// weight on the right and drags it along the beam. The beam tilts live; the app
/// never announces whether it balances.
class LeverSandboxSpec extends SandboxSpec {
  const LeverSandboxSpec({
    required this.leftWeight,
    required this.leftDistance,
    required this.rightWeight,
    this.maxDistance = 5,
  });

  final double leftWeight;
  final double leftDistance;
  final double rightWeight;
  final double maxDistance;
}

/// A single-pile take-away game (Nim). The player always moves first and removes
/// 1..[maxTake] stones from a pile of [stones]; the app plays a PERFECT opponent.
/// [lastTakeWins] true = taking the last stone wins; false = whoever must take
/// the last stone loses (misère). The sandbox lets the player play it out and
/// discover the strategy themselves — it never states who "should" win.
class NimSandboxSpec extends SandboxSpec {
  const NimSandboxSpec({
    required this.stones,
    this.maxTake = 3,
    this.lastTakeWins = true,
  });

  final int stones;
  final int maxTake;
  final bool lastTakeWins;
}

/// ============================================================================
/// AnswerSpec — how the player commits a conclusion + a PURE correctness check.
///
/// ANSWER-SOURCE RULE (contract between the host screen and the mechanics):
///   - [BinaryAnswerSpec]  -> answer chosen via a PredictionToggle shown BELOW an
///     exploration-only sandbox. isCorrect receives a bool (true = optionA).
///   - [ReachTargetAnswerSpec] -> answer DERIVED from sandbox state; the sandbox
///     reports its current value via `onAnswerChanged` (int). isCorrect gets that int.
///   - [GoalAnswerSpec] -> the sandbox reports whether the goal is met via
///     `onAnswerChanged` (bool). isCorrect gets that bool.
///
/// Feedback is confirm / gentle try-again only. isCorrect never surfaces the
/// answer itself to the UI.
/// ============================================================================
sealed class AnswerSpec {
  const AnswerSpec();

  /// Pure check. Returns whether [answer] is the player's correct conclusion.
  bool isCorrect(Object? answer);
}

/// A two-choice commitment (e.g. Safe/Eaten, Balances/Tips). [correctIsA] is
/// supplied by the puzzle definition, typically computed from that puzzle's pure
/// logic function (kept in the puzzle's own file), so reasoning stays testable
/// and out of the UI.
class BinaryAnswerSpec extends AnswerSpec {
  const BinaryAnswerSpec({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.correctIsA,
  });

  /// The question posed at commit time, e.g. "With 100 tigers, is the sheep…".
  final String question;
  final String optionA;
  final String optionB;
  final bool correctIsA;

  @override
  bool isCorrect(Object? answer) => answer is bool && answer == correctIsA;
}

/// The player has answered correctly when the sandbox's reported value equals
/// [target] (e.g. Make the Target). The player commits by matching, not guessing.
class ReachTargetAnswerSpec extends AnswerSpec {
  const ReachTargetAnswerSpec({required this.target});

  final int target;

  @override
  bool isCorrect(Object? answer) => answer is int && answer == target;
}

/// The player succeeds by achieving a state in the sandbox (e.g. balancing a
/// beam). The sandbox reports a bool "goal met" via `onAnswerChanged`; the app
/// never announces the result — the player achieves it by doing.
class GoalAnswerSpec extends AnswerSpec {
  const GoalAnswerSpec({required this.goalLabel});

  /// e.g. "Balance the beam".
  final String goalLabel;

  @override
  bool isCorrect(Object? answer) => answer == true;
}
