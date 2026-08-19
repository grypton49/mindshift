import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/data/models/puzzle.dart';

/// Two large, calm option cards for committing a binary prediction.
///
/// Shows [BinaryAnswerSpec.question] above the two choices. Choosing
/// [BinaryAnswerSpec.optionA] calls `onSelected(true)`; choosing
/// [BinaryAnswerSpec.optionB] calls `onSelected(false)`.
///
/// NO-VERDICT CONTRACT: this widget only reflects which card the player has
/// *chosen* ([selected]). It never marks a card as right or wrong and gives no
/// visual hint at correctness — [BinaryAnswerSpec.correctIsA] is intentionally
/// ignored here; correctness lives with the host's answer check.
class PredictionToggle extends StatelessWidget {
  const PredictionToggle({
    super.key,
    required this.spec,
    required this.onSelected,
    this.selected,
  });

  final BinaryAnswerSpec spec;

  /// Called with `true` for optionA, `false` for optionB.
  final ValueChanged<bool> onSelected;

  /// The player's current choice: `true` = optionA, `false` = optionB,
  /// `null` = nothing chosen yet. Used only to highlight, not to grade.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          spec.question,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: c.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _OptionCard(
          label: spec.optionA,
          isSelected: selected == true,
          onTap: () => onSelected(true),
        ),
        const SizedBox(height: AppSpacing.md),
        _OptionCard(
          label: spec.optionB,
          isSelected: selected == false,
          onTap: () => onSelected(false),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? c.accentSoft : c.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: isSelected ? c.accent : c.surfaceMuted,
          width: isSelected ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                _SelectionDot(isSelected: isSelected),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      color: c.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? c.accent : Colors.transparent,
        border: Border.all(
          color: isSelected ? c.accent : c.textSecondary,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 16, color: c.onAccent)
          : null,
    );
  }
}
