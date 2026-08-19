import '../models/puzzle.dart';
import 'make_the_target_puzzle.dart';
import 'tigers_puzzle.dart';
import 'will_it_balance_puzzle.dart';

/// The single source of truth for all puzzles in the app. Adding a puzzle = adding
/// a [Puzzle] entry here (composing existing sandbox mechanics). Kept as a plain
/// list so `puzzleRegistryProvider` can expose it and the home screen can render it.
final List<Puzzle> puzzleRegistry = <Puzzle>[
  tigersPuzzle, // flagship: game theory / induction
  makeTheTargetPuzzle, // math playground
  willItBalancePuzzle, // physics intuition
];
