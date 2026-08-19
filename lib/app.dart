import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers.dart';

/// Root widget: wires the router + calm-minimalist light/dark themes. The active
/// theme mode is driven by [themeModeProvider] (system by default, persisted).
class MindShiftApp extends ConsumerWidget {
  const MindShiftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'MindShift',
      debugShowCheckedModeBanner: false,
      theme: MindShiftTheme.light(),
      darkTheme: MindShiftTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
