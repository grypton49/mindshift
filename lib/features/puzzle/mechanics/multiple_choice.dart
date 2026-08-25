import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/puzzle.dart';

/// Answer input: the player commits by choosing one of several options. Reports
/// the selected index via [onSelected]; highlights only the current choice and
/// NEVER marks which option is correct.
class MultipleChoiceToggle extends StatelessWidget {
  const MultipleChoiceToggle({
    super.key,
    required this.spec,
    required this.onSelected,
    this.selected,
  });

  final MultipleChoiceAnswerSpec spec;
  final ValueChanged<int> onSelected;
  final int? selected;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          spec.question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.35,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < spec.options.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _Option(
            label: spec.options[i],
            isSelected: selected == i,
            onTap: () => onSelected(i),
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
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
    return Material(
      color: isSelected ? c.accentSoft : c.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(
              color: isSelected ? c.accent : c.surfaceMuted,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 22,
                color: isSelected ? c.accent : c.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
