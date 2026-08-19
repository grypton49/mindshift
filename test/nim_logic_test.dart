import 'package:flutter_test/flutter_test.dart';
import 'package:mindshift/data/puzzles/nim_logic.dart';

/// Plays the game with BOTH sides using [nimOptimalTake] and reports whether the
/// first mover won — this must agree with the closed-form [nimFirstPlayerWins].
bool _firstMoverWinsBySim(int stones, int maxTake, bool lastTakeWins) {
  var s = stones;
  var mover = 0; // 0 = first player
  var last = -1;
  while (s > 0) {
    final take = nimOptimalTake(
      stones: s,
      maxTake: maxTake,
      lastTakeWins: lastTakeWins,
    );
    s -= take;
    last = mover;
    mover = 1 - mover;
  }
  return lastTakeWins ? last == 0 : last != 0;
}

void main() {
  group('nimFirstPlayerWins (normal play, last stone wins)', () {
    test('multiples of (maxTake+1) are losing for the first player', () {
      expect(nimFirstPlayerWins(stones: 12, maxTake: 3, lastTakeWins: true), isFalse);
      expect(nimFirstPlayerWins(stones: 8, maxTake: 3, lastTakeWins: true), isFalse);
      expect(nimFirstPlayerWins(stones: 4, maxTake: 3, lastTakeWins: true), isFalse);
    });
    test('non-multiples are winning for the first player', () {
      expect(nimFirstPlayerWins(stones: 13, maxTake: 3, lastTakeWins: true), isTrue);
      expect(nimFirstPlayerWins(stones: 7, maxTake: 3, lastTakeWins: true), isTrue);
    });
  });

  test('optimal-vs-optimal simulation matches the closed form (normal play)', () {
    for (var s = 1; s <= 30; s++) {
      for (var k = 1; k <= 4; k++) {
        expect(
          _firstMoverWinsBySim(s, k, true),
          nimFirstPlayerWins(stones: s, maxTake: k, lastTakeWins: true),
          reason: 'normal play stones=$s maxTake=$k',
        );
      }
    }
  });

  test('optimal-vs-optimal simulation matches the closed form (misère)', () {
    for (var s = 1; s <= 30; s++) {
      for (var k = 1; k <= 4; k++) {
        expect(
          _firstMoverWinsBySim(s, k, false),
          nimFirstPlayerWins(stones: s, maxTake: k, lastTakeWins: false),
          reason: 'misère stones=$s maxTake=$k',
        );
      }
    }
  });
}
