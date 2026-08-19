import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/app.dart';
import 'package:mindshift/data/providers.dart';
import 'package:mindshift/data/repositories/puzzle_remote_source.dart';

void main() {
  testWidgets('MindShift app boots to a screen', (tester) async {
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

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
