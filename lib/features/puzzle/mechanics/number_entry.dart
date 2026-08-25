import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/puzzle.dart';

/// Answer input: the player types an exact whole number. Reports the parsed int
/// (or null when empty/invalid) via [onChanged]; the host commits it through the
/// AnswerBar. It NEVER reveals whether the entered number is right.
class NumberEntryField extends StatefulWidget {
  const NumberEntryField({
    super.key,
    required this.spec,
    required this.onChanged,
  });

  final NumberEntryAnswerSpec spec;
  final ValueChanged<int?> onChanged;

  @override
  State<NumberEntryField> createState() => _NumberEntryFieldState();
}

class _NumberEntryFieldState extends State<NumberEntryField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your answer',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                ],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: c.textPrimary,
                ),
                cursorColor: c.accent,
                onChanged: (text) => widget.onChanged(int.tryParse(text.trim())),
                decoration: InputDecoration(
                  hintText: '—',
                  hintStyle: TextStyle(
                    color: c.textSecondary.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: c.surfaceMuted,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
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
            ),
            if (widget.spec.unit != null) ...[
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.spec.unit!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: c.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
