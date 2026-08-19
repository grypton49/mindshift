import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/data/models/puzzle.dart';

/// A sandbox where the player moves number tiles into a tray and watches the
/// running sum update live.
///
/// Tap (or drag) a tile from the pool into the tray to add it; tap a tile in the
/// tray to send it back. [onAnswerChanged] fires with the current tray sum every
/// time it changes.
///
/// NO-VERDICT CONTRACT: the sandbox shows only the running sum and the target as
/// neutral facts. It never suggests which tiles to pick and never announces that
/// the target has been reached — the host owns correctness.
class NumberTilesSandbox extends StatefulWidget {
  const NumberTilesSandbox({
    super.key,
    required this.spec,
    required this.onAnswerChanged,
  });

  final NumberTilesSandboxSpec spec;

  /// Called with the current sum of tiles in the tray whenever it changes.
  final ValueChanged<int> onAnswerChanged;

  @override
  State<NumberTilesSandbox> createState() => _NumberTilesSandboxState();
}

class _NumberTilesSandboxState extends State<NumberTilesSandbox> {
  /// Indices (into `spec.tiles`) currently in the tray, in insertion order.
  final List<int> _inTray = <int>[];

  @override
  void initState() {
    super.initState();
    // Report the initial (empty) sum so the host starts in a known state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onAnswerChanged(_sum);
    });
  }

  @override
  void didUpdateWidget(covariant NumberTilesSandbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the puzzle's tiles changed, reset to a clean slate.
    if (!_sameTiles(oldWidget.spec.tiles, widget.spec.tiles)) {
      _inTray.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onAnswerChanged(_sum);
      });
    }
  }

  bool _sameTiles(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int get _sum {
    var total = 0;
    for (final i in _inTray) {
      total += widget.spec.tiles[i];
    }
    return total;
  }

  void _addToTray(int index) {
    if (_inTray.contains(index)) return;
    setState(() => _inTray.add(index));
    widget.onAnswerChanged(_sum);
  }

  void _removeFromTray(int index) {
    if (!_inTray.contains(index)) return;
    setState(() => _inTray.remove(index));
    widget.onAnswerChanged(_sum);
  }

  void _clearTray() {
    if (_inTray.isEmpty) return;
    setState(_inTray.clear);
    widget.onAnswerChanged(_sum);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final tiles = widget.spec.tiles;
    final poolIndices = [
      for (var i = 0; i < tiles.length; i++)
        if (!_inTray.contains(i)) i,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SumHeader(sum: _sum, target: widget.spec.target),
        const SizedBox(height: AppSpacing.lg),
        _TrayZone(
          trayIndices: _inTray,
          tiles: tiles,
          onTileTap: _removeFromTray,
          onAccept: _addToTray,
          onClear: _clearTray,
        ),
        const SizedBox(height: AppSpacing.lg),
        _PoolLabel(),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final i in poolIndices)
              Draggable<int>(
                data: i,
                feedback: _NumberTile(
                  value: tiles[i],
                  inTray: false,
                  dragging: true,
                ),
                childWhenDragging: _NumberTile(
                  value: tiles[i],
                  inTray: false,
                  faded: true,
                ),
                child: _NumberTile(
                  value: tiles[i],
                  inTray: false,
                  onTap: () => _addToTray(i),
                ),
              ),
            if (poolIndices.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  'All tiles are in the tray',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: c.textSecondary),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SumHeader extends StatelessWidget {
  const _SumHeader({required this.sum, required this.target});

  final int sum;
  final int target;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Stat(label: 'Your sum', value: '$sum', emphasized: true),
        Container(width: 1, height: 44, color: c.surfaceMuted),
        _Stat(label: 'Target', value: '$target'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: (textTheme.headlineMedium ?? const TextStyle()).copyWith(
            color: emphasized ? c.accent : c.textPrimary,
            fontWeight: FontWeight.w800,
          ),
          child: Text(value),
        ),
      ],
    );
  }
}

class _TrayZone extends StatelessWidget {
  const _TrayZone({
    required this.trayIndices,
    required this.tiles,
    required this.onTileTap,
    required this.onAccept,
    required this.onClear,
  });

  final List<int> trayIndices;
  final List<int> tiles;
  final ValueChanged<int> onTileTap;
  final ValueChanged<int> onAccept;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => !trayIndices.contains(details.data),
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidate, rejected) {
        final highlighted = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 96),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: highlighted ? c.accentSoft : c.surfaceMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(
              color: highlighted ? c.accent : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tray',
                    style: textTheme.labelLarge?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  if (trayIndices.isNotEmpty)
                    TextButton(
                      onPressed: onClear,
                      style: TextButton.styleFrom(
                        foregroundColor: c.textSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (trayIndices.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(
                    'Tap or drag tiles here',
                    style: textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final i in trayIndices)
                      _NumberTile(
                        value: tiles[i],
                        inTray: true,
                        onTap: () => onTileTap(i),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PoolLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Text(
      'Tiles',
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: c.textSecondary),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.value,
    required this.inTray,
    this.onTap,
    this.dragging = false,
    this.faded = false,
  });

  final int value;
  final bool inTray;
  final VoidCallback? onTap;
  final bool dragging;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final bg = inTray ? c.accent : c.surface;
    final fg = inTray ? c.onAccent : c.textPrimary;

    final tile = Opacity(
      opacity: faded ? 0.3 : 1,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(
            color: inTray ? c.accent : c.surfaceMuted,
            width: 1.5,
          ),
          boxShadow: dragging
              ? const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$value',
          style: TextStyle(
            color: fg,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    if (dragging) {
      return Material(color: Colors.transparent, child: tile);
    }

    return GestureDetector(onTap: onTap, child: tile);
  }
}
