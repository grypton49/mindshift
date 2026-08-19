import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// A gentle, softly-highlighted card used for post-solve "why" explanations and
/// hint text. Sits on a muted accent wash so it reads as supportive rather than
/// alarming — never shaming.
class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.text, this.title, this.icon});

  /// Body copy — the explanation or hint.
  final String text;

  /// Optional heading, rendered in the accent color.
  final String? title;

  /// Optional leading icon, tinted with the accent color.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: c.accent, size: 22),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: c.accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(
                  text,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    height: 1.5,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
