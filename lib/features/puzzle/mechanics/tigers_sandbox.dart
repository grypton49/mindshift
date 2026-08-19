import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_palette.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/data/models/puzzle.dart';

/// The flagship "many tigers, one sheep" experiment area.
///
/// The player picks how many tigers to experiment with (a dial from
/// [TigersSandboxSpec.minTigers] to [TigersSandboxSpec.maxTigers]) and can drag
/// any tiger onto the sheep to "simulate a bite". The mechanical consequence is
/// animated faithfully: the tiger that eats TURNS INTO the sheep (so it can now
/// be eaten in turn). The player may keep going.
///
/// NO-VERDICT CONTRACT: this sandbox shows ONLY the rule's mechanics. It never
/// states whether the sheep ends up safe or eaten for any count, uses no
/// success/failure colouring, and has no `onAnswerChanged` — the player commits
/// their prediction separately.
class TigersSandbox extends StatefulWidget {
  const TigersSandbox({super.key, required this.spec});

  final TigersSandboxSpec spec;

  @override
  State<TigersSandbox> createState() => _TigersSandboxState();
}

class _TigersSandboxState extends State<TigersSandbox> {
  static const String _tigerGlyph = '\u{1F42F}'; // 🐯
  static const String _sheepGlyph = '\u{1F411}'; // 🐑

  late int _chosenCount;
  late int _tigersRemaining;

  /// True during the brief moment the just-eaten tiger is shown before it
  /// visibly becomes the new sheep.
  bool _incomingTiger = false;

  /// Monotonic id so each bite's transformation animates independently.
  int _biteSeq = 0;
  Timer? _morphTimer;

  @override
  void initState() {
    super.initState();
    _chosenCount = widget.spec.minTigers.clamp(
      widget.spec.minTigers,
      widget.spec.maxTigers,
    );
    _tigersRemaining = _chosenCount;
  }

  @override
  void dispose() {
    _morphTimer?.cancel();
    super.dispose();
  }

  void _onCountChanged(double value) {
    final next = value.round();
    if (next == _chosenCount) return;
    _morphTimer?.cancel();
    setState(() {
      _chosenCount = next;
      _tigersRemaining = next;
      _incomingTiger = false;
    });
  }

  void _reset() {
    _morphTimer?.cancel();
    setState(() {
      _tigersRemaining = _chosenCount;
      _incomingTiger = false;
    });
  }

  void _bite() {
    if (_tigersRemaining <= 0) return;
    _morphTimer?.cancel();
    _biteSeq++;
    setState(() {
      // The eating tiger leaves the flock; the old sheep is gone; the eater
      // now occupies the sheep's place, shown first as a tiger...
      _tigersRemaining -= 1;
      _incomingTiger = true;
    });
    // ...then visibly turns into a sheep.
    _morphTimer = Timer(const Duration(milliseconds: 360), () {
      if (!mounted) return;
      setState(() => _incomingTiger = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final spec = widget.spec;
    final divisions = (spec.maxTigers - spec.minTigers).clamp(1, 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dial / slider to pick how many tigers to experiment with.
        Row(
          children: [
            Text(_tigerGlyph, style: const TextStyle(fontSize: 20)),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: c.accent,
                  inactiveTrackColor: c.surfaceMuted,
                  thumbColor: c.accent,
                  overlayColor: c.accentSoft,
                  valueIndicatorColor: c.accent,
                ),
                child: Slider(
                  value: _chosenCount.toDouble(),
                  min: spec.minTigers.toDouble(),
                  max: spec.maxTigers.toDouble(),
                  divisions: divisions,
                  label: '$_chosenCount tigers',
                  onChanged: _onCountChanged,
                ),
              ),
            ),
            SizedBox(
              width: 78,
              child: Text(
                '$_chosenCount tigers',
                textAlign: TextAlign.end,
                style: textTheme.labelLarge?.copyWith(color: c.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // The experiment arena.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: c.surfaceMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The sheep — a drop target for a bite.
              _SheepZone(
                sheepGlyph: _sheepGlyph,
                tigerGlyph: _tigerGlyph,
                showingIncomingTiger: _incomingTiger,
                biteSeq: _biteSeq,
                onBite: _bite,
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: c.background, height: 1),
              const SizedBox(height: AppSpacing.md),
              // The flock of tigers.
              _FlockArea(
                count: _tigersRemaining,
                tigerGlyph: _tigerGlyph,
                onDropAccepted: _bite,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _tigersRemaining > 0
                    ? 'Drag a tiger onto the sheep, or tap it, to try a bite'
                    : 'No tigers left to experiment with',
                style: textTheme.bodySmall?.copyWith(color: c.textSecondary),
              ),
            ),
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              style: TextButton.styleFrom(
                foregroundColor: c.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              label: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

/// The sheep, presented as a [DragTarget]. When a tiger is dropped (or the zone
/// is tapped while tigers remain), it briefly shows the incoming tiger, then
/// cross-fades it into a sheep — the honest mechanical consequence.
class _SheepZone extends StatelessWidget {
  const _SheepZone({
    required this.sheepGlyph,
    required this.tigerGlyph,
    required this.showingIncomingTiger,
    required this.biteSeq,
    required this.onBite,
  });

  final String sheepGlyph;
  final String tigerGlyph;
  final bool showingIncomingTiger;
  final int biteSeq;
  final VoidCallback onBite;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return DragTarget<int>(
      onAcceptWithDetails: (_) => onBite(),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        // The glyph shown right now: an incoming tiger, or the resting sheep.
        final glyph = showingIncomingTiger ? tigerGlyph : sheepGlyph;
        return GestureDetector(
          onTap: onBite,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: hovering ? c.accentSoft : c.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(
                color: hovering ? c.accent : c.surfaceMuted,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.7, end: 1).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: child,
                    ),
                  ),
                  // Key on both the glyph and bite sequence so each bite's
                  // tiger->sheep morph animates even for consecutive bites.
                  child: Text(
                    glyph,
                    key: ValueKey<String>('$glyph-$biteSeq'),
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'the sheep',
                  style: textTheme.labelSmall?.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The flock of draggable tigers. Each tiger can be dragged onto the sheep.
class _FlockArea extends StatelessWidget {
  const _FlockArea({
    required this.count,
    required this.tigerGlyph,
    required this.onDropAccepted,
  });

  final int count;
  final String tigerGlyph;
  final VoidCallback onDropAccepted;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count == 1 ? '1 tiger' : '$count tigers',
          style: textTheme.labelMedium?.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < count; i++)
                Draggable<int>(
                  data: i,
                  feedback: _TigerChip(glyph: tigerGlyph, elevated: true),
                  childWhenDragging: _TigerChip(glyph: tigerGlyph, faded: true),
                  child: _TigerChip(glyph: tigerGlyph),
                ),
              if (count == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(
                    '(none)',
                    style: textTheme.bodySmall?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TigerChip extends StatelessWidget {
  const _TigerChip({
    required this.glyph,
    this.elevated = false,
    this.faded = false,
  });

  final String glyph;
  final bool elevated;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final chip = Opacity(
      opacity: faded ? 0.3 : 1,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(color: c.surfaceMuted, width: 1.5),
          boxShadow: elevated
              ? const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Text(glyph, style: const TextStyle(fontSize: 26)),
      ),
    );

    // Draggable feedback is rendered without a Material ancestor.
    if (elevated) {
      return Material(color: Colors.transparent, child: chip);
    }
    return chip;
  }
}
