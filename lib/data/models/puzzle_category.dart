/// The kinds of problems MindShift hosts. Categories are pure metadata — the
/// interactive mechanic a puzzle uses is defined by its [SandboxSpec], not by
/// its category, so any category can reuse any sandbox.
enum PuzzleCategory {
  gameTheory('Game Theory'),
  math('Math'),
  physics('Physics'),
  lateral('Lateral Thinking');

  const PuzzleCategory(this.label);

  /// Human-readable label shown on cards and headers.
  final String label;
}
