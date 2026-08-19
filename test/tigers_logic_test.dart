import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/puzzles/tigers_puzzle.dart';

void main() {
  group('sheepSurvives', () {
    test('base cases', () {
      expect(sheepSurvives(1), isFalse);
      expect(sheepSurvives(2), isTrue);
      expect(sheepSurvives(3), isFalse);
      expect(sheepSurvives(4), isTrue);
    });

    test('flagship and near-flagship counts', () {
      expect(sheepSurvives(100), isTrue);
      expect(sheepSurvives(99), isFalse);
    });

    test('parity holds across a range', () {
      for (var n = 1; n <= 20; n++) {
        expect(
          sheepSurvives(n),
          n.isEven,
          reason: 'sheep should survive iff $n is even',
        );
      }
    });
  });

  group('sheepEaten', () {
    test('is the inverse of sheepSurvives', () {
      for (var n = 1; n <= 20; n++) {
        expect(sheepEaten(n), !sheepSurvives(n));
      }
    });
  });

  group('tigersPuzzle definition', () {
    test('correct answer is "Safe" for 100 tigers', () {
      final answer = tigersPuzzle.answer as BinaryAnswerSpec;
      expect(answer.correctIsA, isTrue);
      expect(answer.optionA, 'Safe');
      // Choosing optionA (true) is correct; choosing optionB (false) is not.
      expect(answer.isCorrect(true), isTrue);
      expect(answer.isCorrect(false), isFalse);
    });
  });
}
