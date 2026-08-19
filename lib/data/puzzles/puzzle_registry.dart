import '../models/puzzle.dart';
import 'make_the_target_puzzle.dart';
import 'more_puzzles.dart';
import 'nim_puzzle.dart';
import 'tigers_puzzle.dart';
import 'will_it_balance_puzzle.dart';

/// The single source of truth for the app's built-in puzzles. Order here is the
/// canonical level ladder (easy → hard); the remote pack can extend it. Adding a
/// puzzle = adding a [Puzzle] entry (composing existing sandbox mechanics).
final List<Puzzle> puzzleRegistry = <Puzzle>[
  makeTheTargetPuzzle, // 1 · math · d1
  willItBalancePuzzle, // 2 · physics · d2
  tigersPuzzle, // 3 · game theory (flagship) · d3
  makeTheTargetTwo, // 4 · math · d3
  willItBalanceTwo, // 5 · physics · d4
  tigersNinetyNine, // 6 · game theory · d4
  makeTheTargetThree, // 7 · math · d5
  lastStonePuzzle, // 8 · game theory (Nim) · d5
  lastStoneReversedPuzzle, // 9 · game theory (Nim misère) · d4
];
