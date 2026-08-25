import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/puzzle.dart';

/// The "sandbox" for pure-reasoning puzzles: a calm framing plus a PRIVATE
/// scratchpad for the player's own working. Nothing here is validated, scored,
/// or persisted — the thinking is entirely the human's. It reports no answer;
/// the answer is committed via a number-entry / multiple-choice / yes-no widget.
class ReasoningSandbox extends StatefulWidget {
  const ReasoningSandbox({super.key, required this.spec});

  final ReasoningSandboxSpec spec;

  @override
  State<ReasoningSandbox> createState() => _ReasoningSandboxState();
}

class _ReasoningSandboxState extends State<ReasoningSandbox> {
  final _scratch = TextEditingController();

  @override
  void dispose() {
    _scratch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.self_improvement_rounded, size: 20, color: c.accent),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                widget.spec.note ?? 'Take your time. Reason it through, then commit your answer.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: c.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _scratch,
          maxLines: 5,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(fontSize: 15, height: 1.4, color: c.textPrimary),
          cursorColor: c.accent,
          decoration: InputDecoration(
            hintText: 'Scratchpad — jot your working (just for you)…',
            hintStyle: TextStyle(color: c.textSecondary.withValues(alpha: 0.7)),
            filled: true,
            fillColor: c.surfaceMuted,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: BorderSide(color: c.accent),
            ),
          ),
        ),
      ],
    );
  }
}
