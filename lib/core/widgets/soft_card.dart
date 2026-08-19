import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// A rounded "paper" surface with a soft, low shadow — the base building block
/// of the calm-minimalist layout. When [onTap] is provided it becomes tappable
/// with a gentle, rounded ripple.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  /// Content rendered inside the card.
  final Widget child;

  /// Inner padding. Defaults to [AppSpacing.lg] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Optional tap handler. When non-null the card shows an ink ripple.
  final VoidCallback? onTap;

  /// Surface color. Defaults to the theme's surface (`context.palette.surface`).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final borderRadius = BorderRadius.circular(AppSpacing.radiusLarge);

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          splashColor: c.accentSoft.withValues(alpha: 0.35),
          highlightColor: c.accentSoft.withValues(alpha: 0.18),
          child: content,
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: borderRadius, child: content),
    );
  }
}
