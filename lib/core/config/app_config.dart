/// App-wide configuration.
class AppConfig {
  AppConfig._();

  /// The raw URL of the remote puzzle pack (a JSON file). New puzzles are added
  /// by editing that JSON — players receive them on the next launch, no app
  /// update required (as long as they reuse a mechanic the app already ships).
  ///
  /// HOW TO SET THIS UP:
  ///   1. Push this repo to GitHub (the pack lives at `content/puzzles.json`).
  ///   2. Open that file on GitHub and click "Raw" to get its raw URL, e.g.
  ///      `https://raw.githubusercontent.com/<you>/mindshift/main/content/puzzles.json`
  ///   3. Paste that URL below and ship an app update once.
  ///
  /// While this is empty, the app makes NO network calls and simply uses the
  /// puzzles bundled in the build — everything still works offline.
  static const String puzzlePackUrl =
      'https://raw.githubusercontent.com/grypton49/mindshift/main/content/puzzles.json';

  /// How long to wait for the remote pack before giving up and using the cache.
  static const Duration remoteFetchTimeout = Duration(seconds: 8);
}
