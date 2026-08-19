import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/app.dart';
import 'package:mindshift/data/providers.dart';
import 'package:mindshift/data/repositories/puzzle_remote_source.dart';

/// Pumps the app with a hermetic (no-network) remote source and optional seeded
/// solved puzzles (so we can reach a gated level in tests).
Future<void> _pumpApp(WidgetTester tester, {List<String> solved = const []}) async {
  SharedPreferences.setMockInitialValues({
    if (solved.isNotEmpty) 'mindshift.solvedIds': solved,
  });
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        puzzleRemoteSourceProvider.overrideWithValue(
          PuzzleRemoteSource(url: '', timeout: Duration.zero),
        ),
      ],
      child: const MindShiftApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home shows the level ladder starting at level 1', (tester) async {
    await _pumpApp(tester);
    // Level 1 is the on-ramp puzzle and is visible without scrolling.
    expect(find.text('Make the Target'), findsWidgets);
  });

  testWidgets(
    'an unlocked puzzle reveals nothing before solving, then solves via the '
    "player's own prediction",
    (tester) async {
      // Seed the two levels before the flagship so it is unlocked.
      await _pumpApp(tester, solved: ['make-the-target', 'will-it-balance']);

      // The flagship is Level 3 — scroll the ladder until it's visible, open it.
      final tigers = find.text('Tigers & Sheep');
      await tester.scrollUntilVisible(
        tigers,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(tigers);
      await tester.pumpAndSettle();

      // Host is up and NOTHING is revealed yet: no "why" affordance.
      expect(find.text('Check my answer'), findsOneWidget);
      expect(find.text('Show me why'), findsNothing);

      // The player commits their own conclusion (Safe).
      final safe = find.text('Safe').first;
      await tester.ensureVisible(safe);
      await tester.tap(safe);
      await tester.pumpAndSettle();

      final submit = find.text('Check my answer');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();

      // Solved: the optional post-solve explanation is now available.
      expect(find.text('Show me why'), findsOneWidget);
    },
  );
}
