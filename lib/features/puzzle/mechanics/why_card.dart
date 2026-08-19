import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';

/// A gentle "why it works" card, rendered on a soft accent surface.
///
/// This is an OPTIONAL, post-solve explanation. The host only ever mounts it
/// AFTER the player has reached the conclusion themselves — it is never shown
/// while the puzzle is still open, so it can carry a full explanation without
/// leaking anything the player hasn't yet earned.
class WhyCard extends StatelessWidget {
  const WhyCard({super.key, required this.explanation, this.title});

  /// The explanation prose to render.
  final String explanation;

  /// Optional heading; defaults to "Why it works".
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 20, color: c.accent),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title ?? 'Why it works',
                style: textTheme.titleMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            explanation,
            style: textTheme.bodyMedium?.copyWith(
              color: c.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
