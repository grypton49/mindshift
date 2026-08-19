import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/data/models/puzzle_serialization.dart';
import 'package:mindshift/data/puzzles/puzzle_registry.dart';
import 'package:mindshift/data/repositories/puzzle_cache.dart';
import 'package:mindshift/data/repositories/puzzle_remote_source.dart';
import 'package:mindshift/data/repositories/puzzle_repository.dart';

const _timeout = Duration(seconds: 5);

PuzzleRemoteSource _sourceReturning(String body, {int status = 200}) {
  return PuzzleRemoteSource(
    url: 'https://example.com/puzzles.json',
    timeout: _timeout,
    // Build from UTF-8 bytes so unicode content survives (mirrors a real server).
    client: MockClient((_) async => http.Response.bytes(utf8.encode(body), status)),
  );
}

Future<PuzzleCache> _emptyCache() async {
  SharedPreferences.setMockInitialValues({});
  return PuzzleCache(await SharedPreferences.getInstance());
}

void main() {
  final remoteJson =
      jsonEncode(PuzzlePack(version: 2, puzzles: puzzleRegistry).toJson());

  test('initial() returns bundled fallback when cache is empty', () async {
    final repo = PuzzleRepository(
      remoteSource: _sourceReturning('{}'),
      cache: await _emptyCache(),
      fallback: puzzleRegistry,
    );
    expect(repo.initial().length, puzzleRegistry.length);
  });

  test('refresh() fetches, returns puzzles, and caches them', () async {
    final cache = await _emptyCache();
    final repo = PuzzleRepository(
      remoteSource: _sourceReturning(remoteJson),
      cache: cache,
      fallback: puzzleRegistry,
    );
    final fetched = await repo.refresh();
    expect(fetched, isNotNull);
    expect(fetched!.length, puzzleRegistry.length);
    // Cached now: a fresh repo over the same store serves the remote pack.
    expect(cache.load()?.version, 2);
  });

  test('refresh() returns null on HTTP error (keeps existing content)',
      () async {
    final repo = PuzzleRepository(
      remoteSource: _sourceReturning('nope', status: 500),
      cache: await _emptyCache(),
      fallback: puzzleRegistry,
    );
    expect(await repo.refresh(), isNull);
  });

  test('refresh() makes no request and returns null when URL not configured',
      () async {
    var called = false;
    final source = PuzzleRemoteSource(
      url: '',
      timeout: _timeout,
      client: MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      }),
    );
    final repo = PuzzleRepository(
      remoteSource: source,
      cache: await _emptyCache(),
      fallback: puzzleRegistry,
    );
    expect(await repo.refresh(), isNull);
    expect(called, isFalse);
  });
}
