import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/puzzle/puzzle_host_screen.dart';
import '../../features/stats/stats_screen.dart';

/// App routes. Route names/paths are the contract screens navigate against.
abstract final class Routes {
  static const home = '/';
  static const stats = '/stats';

  /// Path template for a puzzle; use [puzzlePath] to build a concrete location.
  static const puzzle = '/puzzle/:id';
  static String puzzlePath(String id) => '/puzzle/$id';
}

final appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: Routes.stats,
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: Routes.puzzle,
      builder: (context, state) =>
          PuzzleHostScreen(puzzleId: state.pathParameters['id'] ?? ''),
    ),
  ],
);
