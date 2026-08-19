// Dev tool: serializes the bundled puzzle registry into the canonical pack JSON.
//
//   dart run tool/export_pack.dart > content/puzzles.json
//
// Run this whenever you change the built-in puzzles, to keep the hosted pack in
// sync. (Adding NEW puzzles is normally done by editing content/puzzles.json
// directly — see content/README.md.)
import 'dart:convert';

import 'package:mindshift/data/models/puzzle_serialization.dart';
import 'package:mindshift/data/puzzles/puzzle_registry.dart';

void main() {
  final pack = PuzzlePack(version: 2, puzzles: puzzleRegistry);
  const encoder = JsonEncoder.withIndent('  ');
  // ignore: avoid_print
  print(encoder.convert(pack.toJson()));
}
