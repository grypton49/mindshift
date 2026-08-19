import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/models/puzzle_serialization.dart';
import 'package:mindshift/data/puzzles/puzzle_registry.dart';

void main() {
  group('round-trip', () {
    test('every bundled puzzle survives toJson -> fromJson unchanged', () {
      for (final puzzle in puzzleRegistry) {
        final json = puzzleToJson(puzzle);
        final parsed = puzzleFromJson(json);
        expect(parsed, isNotNull, reason: 'failed to parse ${puzzle.id}');
        // Re-serializing the parsed puzzle yields identical JSON.
        expect(puzzleToJson(parsed!), equals(json));
      }
    });

    test('PuzzlePack round-trips', () {
      final pack = PuzzlePack(version: 7, puzzles: puzzleRegistry);
      final parsed = PuzzlePack.fromJson(pack.toJson());
      expect(parsed.version, 7);
      expect(parsed.puzzles.length, puzzleRegistry.length);
    });
  });

  group('forward-compatibility (unknown types are skipped, not fatal)', () {
    test('unknown sandbox type -> null spec', () {
      expect(sandboxSpecFromJson({'type': 'quantum-maze'}), isNull);
    });

    test('unknown answer type -> null spec', () {
      expect(answerSpecFromJson({'type': 'freeform'}), isNull);
    });

    test('unknown category -> null puzzle', () {
      final json = puzzleToJson(puzzleRegistry.first)..['category'] = 'astrology';
      expect(puzzleFromJson(json), isNull);
    });

    test('a pack silently drops puzzles this build cannot render', () {
      final good = puzzleToJson(puzzleRegistry.first);
      final futuristic = {
        'id': 'from-the-future',
        'title': 'Needs a newer app',
        'tagline': '...',
        'category': 'gameTheory',
        'difficulty': 2,
        'prompt': '...',
        'sandbox': {'type': 'hologram'},
        'answer': {'type': 'binary', 'optionA': 'a', 'optionB': 'b', 'correctIsA': true},
      };
      final pack = PuzzlePack.fromJson({
        'version': 2,
        'puzzles': [good, futuristic],
      });
      expect(pack.puzzles.length, 1);
      expect(pack.puzzles.single.id, puzzleRegistry.first.id);
    });
  });

  group('tolerant parsing', () {
    test('missing id -> null (skipped)', () {
      final json = puzzleToJson(puzzleRegistry.first)..remove('id');
      expect(puzzleFromJson(json), isNull);
    });

    test('numeric fields accept strings from loose JSON', () {
      final spec = sandboxSpecFromJson({'type': 'numberTiles', 'tiles': [1, 2], 'target': '9'});
      expect(spec, isA<Object>());
    });
  });
}
