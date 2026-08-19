import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';

/// A calm bottom action bar for committing an answer.
///
/// Shows a single "Check my answer" button (enabled only when [canSubmit]) and,
/// optionally, a gentle [feedbackMessage] beneath it.
///
/// NO-VERDICT CONTRACT: this widget never renders the correct answer. Feedback
/// is limited to whatever encouraging string the host passes (e.g. "Not quite —
/// keep exploring" / "You solved it!"). When [solved] is true the message uses
/// [AppPalette.positive]; otherwise [AppPalette.nudge] — a warm, non-shaming hue.
class AnswerBar extends StatelessWidget {
  const AnswerBar({
    super.key,
    required this.canSubmit,
    required this.onSubmit,
    this.feedbackMessage,
    this.solved = false,
  });

  /// Whether the "Check my answer" button is enabled.
  final bool canSubmit;

  /// Called when the player taps the button.
  final VoidCallback onSubmit;

  /// Optional gentle message shown below the button. Never the answer itself.
  final String? feedbackMessage;

  /// When true, the button switches to a calm, settled "Solved" state.
  final bool solved;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final message = feedbackMessage;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildButton(context),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: message == null
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              solved
                                  ? Icons.check_circle_outline
                                  : Icons.spa_outlined,
                              size: 18,
                              color: solved ? c.positive : c.nudge,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: solved ? c.positive : c.nudge,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final c = context.palette;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    if (solved) {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_rounded),
        label: const Text('Solved'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: shape,
          backgroundColor: c.positive,
          disabledBackgroundColor: c.positive,
          foregroundColor: c.onAccent,
          disabledForegroundColor: c.onAccent,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      );
    }

    return FilledButton(
      onPressed: canSubmit ? onSubmit : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: shape,
        backgroundColor: c.accent,
        disabledBackgroundColor: c.surfaceMuted,
        foregroundColor: c.onAccent,
        disabledForegroundColor: c.textSecondary,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      child: const Text('Check my answer'),
    );
  }
}
