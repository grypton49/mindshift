import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/puzzles/puzzle_registry.dart';

void main() {
  test('there are exactly 50 puzzles', () {
    expect(puzzleRegistry.length, 50);
  });

  test('all puzzle ids are unique', () {
    final ids = puzzleRegistry.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every puzzle is well-formed', () {
    for (final p in puzzleRegistry) {
      expect(p.id.trim(), isNotEmpty, reason: 'id');
      expect(p.title.trim(), isNotEmpty, reason: '${p.id} title');
      expect(p.tagline.trim(), isNotEmpty, reason: '${p.id} tagline');
      expect(p.prompt.trim(), isNotEmpty, reason: '${p.id} prompt');
      expect(p.hints, isNotEmpty, reason: '${p.id} hints');
      expect(p.whyExplanation, isNotNull, reason: '${p.id} why');
      expect(p.whyExplanation!.trim(), isNotEmpty, reason: '${p.id} why empty');
      expect(p.difficulty, inInclusiveRange(1, 5), reason: '${p.id} difficulty');
      expect(p.comingSoon, isFalse, reason: '${p.id} comingSoon');
    }
  });

  test('multiple-choice answers are valid (index in range, options distinct)', () {
    for (final p in puzzleRegistry) {
      final a = p.answer;
      if (a is MultipleChoiceAnswerSpec) {
        expect(a.options.length, greaterThanOrEqualTo(2), reason: '${p.id} opts');
        expect(a.correctIndex, inInclusiveRange(0, a.options.length - 1),
            reason: '${p.id} correctIndex');
        expect(a.options.toSet().length, a.options.length,
            reason: '${p.id} duplicate options');
        expect(a.question.trim(), isNotEmpty, reason: '${p.id} question');
      }
    }
  });
}
