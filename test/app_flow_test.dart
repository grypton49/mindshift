import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/app.dart';
import 'package:mindshift/data/providers.dart';
import 'package:mindshift/data/repositories/puzzle_remote_source.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // Keep the test hermetic: no real network fetch of the remote pack.
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
  testWidgets('home lists the flagship puzzle', (tester) async {
    await _pumpApp(tester);
    expect(find.text('Tigers & Sheep'), findsWidgets);
  });

  testWidgets(
    'flagship puzzle reveals nothing before solving, then solves via the '
    "player's own prediction",
    (tester) async {
      await _pumpApp(tester);

      // Open the flagship puzzle from the home shelf.
      final card = find.text('Tigers & Sheep').first;
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();

      // Host screen is up and NOTHING is revealed yet: no "why" affordance.
      expect(find.text('Check my answer'), findsOneWidget);
      expect(find.text('Show me why'), findsNothing);

      // The player commits their own conclusion (the sheep is Safe with 100).
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
