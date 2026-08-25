import '../models/puzzle.dart';
import 'puzzles_logic.dart';
import 'puzzles_math.dart';
import 'puzzles_number.dart';
import 'puzzles_physics.dart';
import 'puzzles_probability.dart';

/// The app's 50 built-in puzzles, in level order (all difficulty 5). Assembled
/// from the five themed sets. Adding puzzles = extend a set (or the remote pack).
final List<Puzzle> puzzleRegistry = <Puzzle>[
  ...logicPuzzles, // 1–10  · logic / epistemic / game theory
  ...mathPuzzles, // 11–20 · optimization / combinatorics
  ...numberPuzzles, // 21–30 · number theory / counting
  ...probabilityPuzzles, // 31–40 · probability
  ...physicsPuzzles, // 41–50 · counterintuitive physics + tactile
];
