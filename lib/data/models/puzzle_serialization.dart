import 'puzzle.dart';
import 'puzzle_category.dart';

/// JSON (de)serialization for puzzles, kept OUT of the model classes so the
/// models stay pure. This is what lets puzzle CONTENT be delivered remotely.
///
/// FORWARD-COMPATIBILITY: [puzzleFromJson] returns null when a puzzle needs a
/// mechanic/answer/category this app build doesn't know about (unknown `type`).
/// The loader filters nulls, so an older app simply SKIPS puzzles that require a
/// newer app version instead of crashing. Add a new mechanic → ship an app
/// update → older installs ignore those puzzles until updated.

// ---------------------------------------------------------------------------
// SandboxSpec
// ---------------------------------------------------------------------------

Map<String, dynamic> sandboxSpecToJson(SandboxSpec spec) {
  return switch (spec) {
    TigersSandboxSpec s => {
        'type': 'tigers',
        'minTigers': s.minTigers,
        'maxTigers': s.maxTigers,
        'questionTigers': s.questionTigers,
      },
    NumberTilesSandboxSpec s => {
        'type': 'numberTiles',
        'tiles': s.tiles,
        'target': s.target,
      },
    LeverSandboxSpec s => {
        'type': 'lever',
        'leftWeight': s.leftWeight,
        'leftDistance': s.leftDistance,
        'rightWeight': s.rightWeight,
        'maxDistance': s.maxDistance,
      },
  };
}

/// Returns null for an unknown `type` (a mechanic this build doesn't ship).
SandboxSpec? sandboxSpecFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'tigers':
      return TigersSandboxSpec(
        minTigers: _int(json['minTigers'], 1),
        maxTigers: _int(json['maxTigers'], 12),
        questionTigers: _int(json['questionTigers'], 100),
      );
    case 'numberTiles':
      return NumberTilesSandboxSpec(
        tiles: _intList(json['tiles']),
        target: _int(json['target'], 0),
      );
    case 'lever':
      return LeverSandboxSpec(
        leftWeight: _double(json['leftWeight'], 1),
        leftDistance: _double(json['leftDistance'], 1),
        rightWeight: _double(json['rightWeight'], 1),
        maxDistance: _double(json['maxDistance'], 5),
      );
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// AnswerSpec
// ---------------------------------------------------------------------------

Map<String, dynamic> answerSpecToJson(AnswerSpec spec) {
  return switch (spec) {
    BinaryAnswerSpec a => {
        'type': 'binary',
        'question': a.question,
        'optionA': a.optionA,
        'optionB': a.optionB,
        'correctIsA': a.correctIsA,
      },
    ReachTargetAnswerSpec a => {
        'type': 'reachTarget',
        'target': a.target,
      },
    GoalAnswerSpec a => {
        'type': 'goal',
        'goalLabel': a.goalLabel,
      },
  };
}

/// Returns null for an unknown `type`.
AnswerSpec? answerSpecFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'binary':
      return BinaryAnswerSpec(
        question: _str(json['question']),
        optionA: _str(json['optionA']),
        optionB: _str(json['optionB']),
        correctIsA: json['correctIsA'] == true,
      );
    case 'reachTarget':
      return ReachTargetAnswerSpec(target: _int(json['target'], 0));
    case 'goal':
      return GoalAnswerSpec(goalLabel: _str(json['goalLabel']));
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// Puzzle
// ---------------------------------------------------------------------------

Map<String, dynamic> puzzleToJson(Puzzle p) {
  return {
    'id': p.id,
    'title': p.title,
    'tagline': p.tagline,
    'category': p.category.name,
    'difficulty': p.difficulty,
    'prompt': p.prompt,
    'rules': p.rules,
    'sandbox': sandboxSpecToJson(p.sandbox),
    'answer': answerSpecToJson(p.answer),
    'hints': p.hints,
    if (p.whyExplanation != null) 'whyExplanation': p.whyExplanation,
    'comingSoon': p.comingSoon,
  };
}

/// Parses one puzzle. Returns null (so the loader can skip it) when the puzzle
/// references an unknown sandbox/answer type or category, or is missing an id.
Puzzle? puzzleFromJson(Map<String, dynamic> json) {
  final id = json['id'];
  if (id is! String || id.isEmpty) return null;

  final category = _categoryByName(json['category']);
  if (category == null) return null;

  final sandboxJson = json['sandbox'];
  final answerJson = json['answer'];
  if (sandboxJson is! Map || answerJson is! Map) return null;

  final sandbox = sandboxSpecFromJson(Map<String, dynamic>.from(sandboxJson));
  final answer = answerSpecFromJson(Map<String, dynamic>.from(answerJson));
  if (sandbox == null || answer == null) return null;

  return Puzzle(
    id: id,
    title: _str(json['title']),
    tagline: _str(json['tagline']),
    category: category,
    difficulty: _int(json['difficulty'], 1),
    prompt: _str(json['prompt']),
    rules: _strList(json['rules']),
    sandbox: sandbox,
    answer: answer,
    hints: _strList(json['hints']),
    whyExplanation: json['whyExplanation'] is String
        ? json['whyExplanation'] as String
        : null,
    comingSoon: json['comingSoon'] == true,
  );
}

// ---------------------------------------------------------------------------
// PuzzlePack — the top-level remote/bundled document
// ---------------------------------------------------------------------------

/// A versioned collection of puzzles. `version` lets us reason about content
/// revisions and is handy for debugging which pack a player is on.
class PuzzlePack {
  const PuzzlePack({required this.version, required this.puzzles});

  final int version;
  final List<Puzzle> puzzles;

  /// Parses a pack, silently skipping any puzzle this build can't render.
  factory PuzzlePack.fromJson(Map<String, dynamic> json) {
    final rawList = json['puzzles'];
    final puzzles = <Puzzle>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map) {
          final puzzle = puzzleFromJson(Map<String, dynamic>.from(item));
          if (puzzle != null) puzzles.add(puzzle);
        }
      }
    }
    return PuzzlePack(version: _int(json['version'], 1), puzzles: puzzles);
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'puzzles': puzzles.map(puzzleToJson).toList(),
      };
}

// ---------------------------------------------------------------------------
// Small tolerant coercion helpers (remote JSON should never crash the app)
// ---------------------------------------------------------------------------

String _str(Object? v) => v is String ? v : '';

int _int(Object? v, int fallback) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

double _double(Object? v, double fallback) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? fallback;
  return fallback;
}

List<String> _strList(Object? v) =>
    v is List ? v.map((e) => e.toString()).toList() : const [];

List<int> _intList(Object? v) =>
    v is List ? v.map((e) => _int(e, 0)).toList() : const [];

PuzzleCategory? _categoryByName(Object? name) {
  if (name is! String) return null;
  for (final c in PuzzleCategory.values) {
    if (c.name == name) return c;
  }
  return null;
}
