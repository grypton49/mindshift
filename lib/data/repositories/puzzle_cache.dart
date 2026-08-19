import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/puzzle_serialization.dart';

/// Caches the last successfully-fetched puzzle pack so players have fresh content
/// even when offline. Backed by [SharedPreferences].
class PuzzleCache {
  PuzzleCache(this._prefs);

  final SharedPreferences _prefs;

  static const _kPack = 'mindshift.puzzlePack';

  /// Loads the cached pack, or null if none/invalid.
  PuzzlePack? load() {
    final raw = _prefs.getString(_kPack);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return PuzzlePack.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(PuzzlePack pack) async {
    await _prefs.setString(_kPack, jsonEncode(pack.toJson()));
  }
}
