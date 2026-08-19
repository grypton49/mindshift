import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/puzzle_serialization.dart';

/// Fetches the remote puzzle pack (a hosted JSON file, e.g. a GitHub raw URL).
class PuzzleRemoteSource {
  PuzzleRemoteSource({
    required this.url,
    required this.timeout,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// The raw JSON URL. Empty means "no remote configured" — see [isConfigured].
  final String url;
  final Duration timeout;
  final http.Client _client;

  /// True only when a real URL has been set in AppConfig. When false the app
  /// makes no network calls at all.
  bool get isConfigured => url.trim().isNotEmpty;

  /// Fetches and parses the pack. Throws on network/HTTP/parse failure — the
  /// repository is responsible for catching and falling back.
  Future<PuzzlePack> fetch() async {
    final response = await _client.get(Uri.parse(url)).timeout(timeout);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Unexpected status ${response.statusCode}',
        Uri.parse(url),
      );
    }
    // Decode bytes as UTF-8 explicitly so unicode content is correct regardless
    // of whether the server sent a charset in its content-type header.
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Puzzle pack root must be a JSON object');
    }
    return PuzzlePack.fromJson(decoded);
  }
}
