import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_theme.dart';
import 'package:mindshift/data/providers.dart';

void main() {
  group('themes', () {
    test('light theme carries the light palette', () {
      final theme = MindShiftTheme.light();
      expect(theme.brightness, Brightness.light);
      final palette = theme.extension<AppPalette>();
      expect(palette, isNotNull);
      expect(palette!.background, AppPalette.light.background);
    });

    test('dark theme carries the dark palette and is dark', () {
      final theme = MindShiftTheme.dark();
      expect(theme.brightness, Brightness.dark);
      final palette = theme.extension<AppPalette>();
      expect(palette, isNotNull);
      expect(palette!.background, AppPalette.dark.background);
      // Dark surfaces are darker than light ones.
      expect(
        palette.background.computeLuminance(),
        lessThan(AppPalette.light.background.computeLuminance()),
      );
    });
  });

  group('theme mode persistence', () {
    test('defaults to system and round-trips a chosen mode', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final controller = ThemeController(prefs);
      expect(controller.state, ThemeMode.system);

      await controller.setMode(ThemeMode.dark);
      expect(controller.state, ThemeMode.dark);

      // A fresh controller over the same store restores the choice.
      expect(ThemeController(prefs).state, ThemeMode.dark);
    });
  });
}
