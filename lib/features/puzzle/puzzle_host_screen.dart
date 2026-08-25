import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/core/widgets/calm_scaffold.dart';
import 'package:mindshift/core/widgets/insight_card.dart';
import 'package:mindshift/core/widgets/primary_button.dart';
import 'package:mindshift/core/widgets/soft_card.dart';
import 'package:mindshift/data/models/puzzle.dart';
import 'package:mindshift/data/models/puzzle_category.dart';
import 'package:mindshift/data/providers.dart';
import 'package:mindshift/features/puzzle/mechanics/answer_bar.dart';
import 'package:mindshift/features/puzzle/mechanics/lever_sandbox.dart';
import 'package:mindshift/features/puzzle/mechanics/multiple_choice.dart';
import 'package:mindshift/features/puzzle/mechanics/nim_sandbox.dart';
import 'package:mindshift/features/puzzle/mechanics/number_entry.dart';
import 'package:mindshift/features/puzzle/mechanics/number_tiles_sandbox.dart';
import 'package:mindshift/features/puzzle/mechanics/prediction_toggle.dart';
import 'package:mindshift/features/puzzle/mechanics/reasoning_sandbox.dart';
import 'package:mindshift/features/puzzle/mechanics/tigers_sandbox.dart';
import 'package:mindshift/features/puzzle/mechanics/why_card.dart';

/// The generic puzzle host screen.
///
/// It reads a [Puzzle] by id, renders its header, the interactive sandbox for
/// its [SandboxSpec], the commit affordance for its [AnswerSpec], opt-in hints,
/// and a bottom [AnswerBar]. It NEVER reveals the answer or the reasoning before
/// the player solves it — the "why" explanation is only offered, opt-in, after a
/// correct solve.
///
/// ANSWER SOURCING (per the model contract):
///   - [BinaryAnswerSpec]  -> a [PredictionToggle] shown below an
///     exploration-only sandbox; the chosen bool (true = optionA) is the answer.
///   - [ReachTargetAnswerSpec] -> the sandbox reports an int via
///     `onAnswerChanged`; the latest reported int is the answer.
///   - [GoalAnswerSpec] -> the sandbox reports a bool via `onAnswerChanged`; the
///     latest reported bool is the answer.
class PuzzleHostScreen extends ConsumerStatefulWidget {
  const PuzzleHostScreen({super.key, required this.puzzleId});

  final String puzzleId;

  @override
  ConsumerState<PuzzleHostScreen> createState() => _PuzzleHostScreenState();
}

class _PuzzleHostScreenState extends ConsumerState<PuzzleHostScreen> {
  // ---- Answer sources (only one is relevant per puzzle, keyed by AnswerSpec) --
  /// BinaryAnswerSpec: the player's toggle choice (true = optionA), null = none.
  bool? _selectedBinary;

  /// ReachTargetAnswerSpec: the sandbox's latest reported sum, null until first.
  int? _reportedInt;

  /// GoalAnswerSpec: the sandbox's latest reported "goal met" bool, null until
  /// first.
  bool? _reportedBool;

  /// NumberEntryAnswerSpec: the whole number the player typed, null until entered.
  int? _enteredNumber;

  /// MultipleChoiceAnswerSpec: the option index the player tapped, null = none.
  int? _selectedChoice;

  // ---- Screen state ----------------------------------------------------------
  /// How many hints the player has chosen to reveal (never auto-shown).
  int _revealedHints = 0;

  /// Whether the puzzle is solved (either just now or already on entry).
  bool _solved = false;

  /// Whether the opt-in "why it works" card is currently expanded.
  bool _showWhy = false;

  /// The current gentle feedback under the AnswerBar (never the answer itself).
  String? _feedback;

  @override
  void initState() {
    super.initState();
    final puzzle = ref.read(puzzleByIdProvider(widget.puzzleId));
    if (puzzle != null && ref.read(progressProvider).isSolved(puzzle.id)) {
      _solved = true;
      _feedback = 'You solved this one.';
    }
  }

  // ---- Answer-source helpers (exhaustive over the sealed AnswerSpec) ----------
  Object? _currentAnswer(AnswerSpec spec) => switch (spec) {
    BinaryAnswerSpec() => _selectedBinary,
    ReachTargetAnswerSpec() => _reportedInt,
    GoalAnswerSpec() => _reportedBool,
    NumberEntryAnswerSpec() => _enteredNumber,
    MultipleChoiceAnswerSpec() => _selectedChoice,
  };

  bool _canSubmit(AnswerSpec spec) => switch (spec) {
    BinaryAnswerSpec() => _selectedBinary != null,
    ReachTargetAnswerSpec() => _reportedInt != null,
    GoalAnswerSpec() => _reportedBool != null,
    NumberEntryAnswerSpec() => _enteredNumber != null,
    MultipleChoiceAnswerSpec() => _selectedChoice != null,
  };

  void _onSubmit(Puzzle puzzle) {
    if (_solved) return;
    final correct = puzzle.answer.isCorrect(_currentAnswer(puzzle.answer));
    if (correct) {
      ref.read(progressProvider.notifier).markSolved(puzzle.id);
      setState(() {
        _solved = true;
        _feedback = 'You solved it!';
      });
    } else {
      setState(() => _feedback = 'Not quite — keep exploring.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = ref.watch(puzzleByIdProvider(widget.puzzleId));

    if (puzzle == null || puzzle.comingSoon) {
      return CalmScaffold(
        title: puzzle?.title ?? 'Puzzle',
        showBack: true,
        body: const _ComingSoonPlaceholder(),
      );
    }

    return CalmScaffold(
      title: puzzle.title,
      showBack: true,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PuzzleHeader(puzzle: puzzle),
                  const SizedBox(height: AppSpacing.lg),
                  SoftCard(child: _buildSandbox(puzzle.sandbox)),
                  if (puzzle.answer case final BinaryAnswerSpec binary) ...[
                    const SizedBox(height: AppSpacing.lg),
                    PredictionToggle(
                      spec: binary,
                      selected: _selectedBinary,
                      onSelected: (value) =>
                          setState(() => _selectedBinary = value),
                    ),
                  ],
                  if (puzzle.answer case final MultipleChoiceAnswerSpec mc) ...[
                    const SizedBox(height: AppSpacing.lg),
                    MultipleChoiceToggle(
                      spec: mc,
                      selected: _selectedChoice,
                      onSelected: (index) =>
                          setState(() => _selectedChoice = index),
                    ),
                  ],
                  if (puzzle.answer case final NumberEntryAnswerSpec ne) ...[
                    const SizedBox(height: AppSpacing.lg),
                    NumberEntryField(
                      spec: ne,
                      onChanged: (value) =>
                          setState(() => _enteredNumber = value),
                    ),
                  ],
                  ..._buildHints(puzzle),
                  ..._buildWhy(puzzle),
                ],
              ),
            ),
          ),
          AnswerBar(
            canSubmit: _canSubmit(puzzle.answer),
            solved: _solved,
            feedbackMessage: _feedback,
            onSubmit: () => _onSubmit(puzzle),
          ),
        ],
      ),
    );
  }

  /// Exhaustive mapping of a [SandboxSpec] to its mechanic widget. The answer
  /// wiring differs per sandbox: Tigers is exploration-only (its prediction is
  /// committed via the [PredictionToggle]), while Number-tiles and Lever report
  /// their live value back to us.
  Widget _buildSandbox(SandboxSpec spec) => switch (spec) {
    TigersSandboxSpec() => TigersSandbox(spec: spec),
    NumberTilesSandboxSpec() => NumberTilesSandbox(
      spec: spec,
      onAnswerChanged: (sum) => setState(() => _reportedInt = sum),
    ),
    LeverSandboxSpec() => LeverSandbox(
      spec: spec,
      onAnswerChanged: (balanced) => setState(() => _reportedBool = balanced),
    ),
    NimSandboxSpec() => NimSandbox(spec: spec),
    ReasoningSandboxSpec() => ReasoningSandbox(spec: spec),
  };

  /// Opt-in, one-at-a-time hints. Never auto-shown; the reveal button hides once
  /// every hint is out.
  List<Widget> _buildHints(Puzzle puzzle) {
    if (puzzle.hints.isEmpty) return const [];

    final widgets = <Widget>[];
    for (var i = 0; i < _revealedHints && i < puzzle.hints.length; i++) {
      widgets
        ..add(const SizedBox(height: AppSpacing.md))
        ..add(
          InsightCard(
            title: 'Nudge ${i + 1}',
            text: puzzle.hints[i],
            icon: Icons.lightbulb_outline_rounded,
          ),
        );
    }

    if (_revealedHints < puzzle.hints.length) {
      widgets
        ..add(const SizedBox(height: AppSpacing.sm))
        ..add(
          Align(
            alignment: Alignment.centerLeft,
            child: GhostButton(
              label: _revealedHints == 0 ? 'Need a nudge?' : 'Another nudge?',
              icon: Icons.spa_outlined,
              onPressed: () => setState(() => _revealedHints++),
            ),
          ),
        );
    }

    return widgets;
  }

  /// The opt-in, post-solve "why it works" affordance. Only ever offered after a
  /// correct solve, and only when the puzzle actually has an explanation.
  List<Widget> _buildWhy(Puzzle puzzle) {
    final explanation = puzzle.whyExplanation;
    if (!_solved || explanation == null) return const [];

    return [
      const SizedBox(height: AppSpacing.sm),
      Align(
        alignment: Alignment.centerLeft,
        child: GhostButton(
          label: _showWhy ? 'Hide why' : 'Show me why',
          icon: Icons.lightbulb_outline_rounded,
          onPressed: () => setState(() => _showWhy = !_showWhy),
        ),
      ),
      if (_showWhy) ...[
        const SizedBox(height: AppSpacing.sm),
        WhyCard(explanation: explanation),
      ],
    ];
  }
}

/// The header card: category chip, difficulty, prompt, and the rules list.
class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({required this.puzzle});

  final Puzzle puzzle;

  static Color _categoryColor(PuzzleCategory category, AppPalette palette) =>
      switch (category) {
        PuzzleCategory.gameTheory => palette.gameTheory,
        PuzzleCategory.math => palette.math,
        PuzzleCategory.physics => palette.physics,
        PuzzleCategory.lateral => palette.lateral,
      };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final c = context.palette;
    final categoryColor = _categoryColor(puzzle.category, c);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CategoryChip(label: puzzle.category.label, color: categoryColor),
              _DifficultyDots(
                difficulty: puzzle.difficulty,
                color: categoryColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            puzzle.prompt,
            style: textTheme.titleMedium?.copyWith(
              color: c.textPrimary,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (puzzle.rules.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            for (final rule in puzzle.rules)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: textTheme.bodyMedium?.copyWith(
                          color: c.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({required this.difficulty, required this.color});

  final int difficulty;
  final Color color;

  static const int _maxDots = 5;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _maxDots; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : AppSpacing.xs),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < difficulty ? color : c.surfaceMuted,
              ),
            ),
          ),
      ],
    );
  }
}

/// Calm placeholder for a missing or not-yet-available puzzle.
class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final c = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spa_outlined, size: 44, color: c.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'This puzzle is coming soon',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check back shortly — a fresh problem to think through is on its '
              'way.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: c.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
