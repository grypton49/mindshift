import 'package:flutter/widgets.dart';
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
    expect(find.text('The Blue-Eyed Islanders'), findsWidgets);
  });

  testWidgets(
    'a reasoning puzzle reveals nothing pre-solve, then solves via a committed '
    'multiple-choice answer',
    (tester) async {
      await _pumpApp(tester);

      // An early multiple-choice level is within the opening unlock window.
      final card = find.text('The 100 Prisoners and the Boxes');
      await tester.scrollUntilVisible(
        card,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(card);
      await tester.pumpAndSettle();

      // Host is up; nothing revealed yet.
      expect(find.text('Check my answer'), findsOneWidget);
      expect(find.text('Show me why'), findsNothing);

      // Commit the correct option (the player's own conclusion).
      final option = find.text('About 31%');
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();

      final submit = find.text('Check my answer');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();

      // Solved: the optional post-solve explanation is now offered.
      expect(find.text('Show me why'), findsOneWidget);
    },
  );
}
