import '../models/puzzle.dart';
import 'puzzle_cache.dart';
import 'puzzle_remote_source.dart';

/// Orchestrates puzzle content across three layers, most-to-least fresh:
///   1. Remote pack (hosted JSON) — the latest content, fetched on launch.
///   2. Cache — the last good remote pack, used when offline.
///   3. Bundled fallback — puzzles compiled into the app; always available.
///
/// [initial] returns instantly (cache or fallback) for a fast first paint;
/// [refresh] then updates from the network in the background.
class PuzzleRepository {
  PuzzleRepository({
    required this.remoteSource,
    required this.cache,
    required this.fallback,
  });

  final PuzzleRemoteSource remoteSource;
  final PuzzleCache cache;
  final List<Puzzle> fallback;

  /// Synchronous best-available content for immediate display: the cached pack
  /// if present, otherwise the bundled fallback. Never empty (unless fallback is).
  List<Puzzle> initial() {
    final cached = cache.load();
    if (cached != null && cached.puzzles.isNotEmpty) return cached.puzzles;
    return fallback;
  }

  /// Attempts to refresh from the network. On success caches the pack and
  /// returns its puzzles; on any failure (or when no URL is configured) returns
  /// null so the caller keeps whatever it already has.
  Future<List<Puzzle>?> refresh() async {
    if (!remoteSource.isConfigured) return null;
    try {
      final pack = await remoteSource.fetch();
      if (pack.puzzles.isEmpty) return null;
      await cache.save(pack);
      return pack.puzzles;
    } catch (_) {
      return null;
    }
  }
}
