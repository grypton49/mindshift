import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget: wires the router + calm-minimalist theme.
class MindShiftApp extends StatelessWidget {
  const MindShiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MindShift',
      debugShowCheckedModeBanner: false,
      theme: MindShiftTheme.light(),
      routerConfig: appRouter,
    );
  }
}
