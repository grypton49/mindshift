import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:mindshift/core/theme/app_colors.dart';
import 'package:mindshift/core/theme/app_spacing.dart';
import 'package:mindshift/data/models/puzzle.dart';

/// A balance-beam sandbox. A fixed weight sits on the left at
/// [LeverSandboxSpec.leftDistance]; the player drags a right-hand weight along
/// the beam from 0 to [LeverSandboxSpec.maxDistance]. The beam tilts live from
/// real torque (`leftWeight * leftDistance` vs `rightWeight * rightDistance`).
///
/// [onAnswerChanged] reports `true` while the beam sits within a small balance
/// tolerance and `false` otherwise.
///
/// NO-VERDICT CONTRACT: the honest, physical tilt of the beam is the only
/// feedback. Nothing prints "balanced!" or otherwise announces success — the
/// host decides what a balanced state means.
class LeverSandbox extends StatefulWidget {
  const LeverSandbox({
    super.key,
    required this.spec,
    required this.onAnswerChanged,
  });

  final LeverSandboxSpec spec;

  /// Called with whether the beam is currently balanced, on every change.
  final ValueChanged<bool> onAnswerChanged;

  @override
  State<LeverSandbox> createState() => _LeverSandboxState();
}

class _LeverSandboxState extends State<LeverSandbox> {
  late double _rightDistance;
  bool _lastBalanced = false;

  static const double _maxTiltRad = 0.16; // ~9 degrees at full deflection.
  static const double _beamAreaHeight = 220;
  static const double _edgeInset = 36;

  @override
  void initState() {
    super.initState();
    _rightDistance = widget.spec.maxDistance / 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _lastBalanced = _isBalanced;
      widget.onAnswerChanged(_lastBalanced);
    });
  }

  @override
  void didUpdateWidget(covariant LeverSandbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final s = widget.spec;
    final o = oldWidget.spec;
    if (s.leftWeight != o.leftWeight ||
        s.leftDistance != o.leftDistance ||
        s.rightWeight != o.rightWeight ||
        s.maxDistance != o.maxDistance) {
      _rightDistance = s.maxDistance / 2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _lastBalanced = _isBalanced;
        widget.onAnswerChanged(_lastBalanced);
      });
    }
  }

  double get _leftTorque => widget.spec.leftWeight * widget.spec.leftDistance;
  double get _rightTorque => widget.spec.rightWeight * _rightDistance;
  double get _net => _leftTorque - _rightTorque;

  /// A comfortable, calm tolerance so balancing is achievable by drag.
  double get _tolerance => math.max(0.5, _leftTorque.abs() * 0.1);

  bool get _isBalanced => _net.abs() <= _tolerance;

  double get _beamAngle {
    final scale = math.max(
      _leftTorque.abs(),
      widget.spec.rightWeight * widget.spec.maxDistance,
    );
    if (scale == 0) return 0;
    final norm = (_net / scale).clamp(-1.0, 1.0);
    // Positive Flutter rotation is clockwise (screen). Right-heavy (net < 0)
    // should drop the right end -> clockwise -> positive angle.
    return -norm * _maxTiltRad;
  }

  void _setDistanceFromX(double localX, double width) {
    final pivotX = width / 2;
    final halfLen = pivotX - _edgeInset;
    if (halfLen <= 0) return;
    final pxPerUnit = halfLen / widget.spec.maxDistance;
    final raw = (localX - pivotX) / pxPerUnit;
    final clamped = raw.clamp(0.0, widget.spec.maxDistance).toDouble();
    if (clamped == _rightDistance) return;
    setState(() => _rightDistance = clamped);
    final balancedNow = _isBalanced;
    if (balancedNow != _lastBalanced) {
      _lastBalanced = balancedNow;
      widget.onAnswerChanged(balancedNow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _setDistanceFromX(d.localPosition.dx, width),
              onPanStart: (d) => _setDistanceFromX(d.localPosition.dx, width),
              onPanUpdate: (d) => _setDistanceFromX(d.localPosition.dx, width),
              child: SizedBox(
                height: _beamAreaHeight,
                width: width,
                child: _BeamPainterArea(
                  width: width,
                  beamAngle: _beamAngle,
                  leftWeight: widget.spec.leftWeight,
                  rightWeight: widget.spec.rightWeight,
                  leftDistance: widget.spec.leftDistance,
                  rightDistance: _rightDistance,
                  maxDistance: widget.spec.maxDistance,
                  edgeInset: _edgeInset,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Drag the right weight along the beam',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Lays out the pivot, the tilting beam, and both weights.
class _BeamPainterArea extends StatelessWidget {
  const _BeamPainterArea({
    required this.width,
    required this.beamAngle,
    required this.leftWeight,
    required this.rightWeight,
    required this.leftDistance,
    required this.rightDistance,
    required this.maxDistance,
    required this.edgeInset,
  });

  final double width;
  final double beamAngle;
  final double leftWeight;
  final double rightWeight;
  final double leftDistance;
  final double rightDistance;
  final double maxDistance;
  final double edgeInset;

  static const double _beamThickness = 14;
  static const double _weightSize = 46;

  @override
  Widget build(BuildContext context) {
    final pivotX = width / 2;
    final halfLen = pivotX - edgeInset;
    final pxPerUnit = maxDistance == 0 ? 0.0 : halfLen / maxDistance;

    final leftFrac = leftDistance.clamp(0.0, maxDistance) * pxPerUnit;
    final rightFrac = rightDistance.clamp(0.0, maxDistance) * pxPerUnit;

    // Beam group is a Stack the full width of the beam, centered on the pivot,
    // rotated about its center (the fulcrum).
    final beamGroupWidth = halfLen * 2;
    const beamGroupHeight = 120.0;
    final beamCenterY = beamGroupHeight / 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Fulcrum triangle sits under the pivot.
        Positioned(
          bottom: 24,
          left: pivotX - 26,
          child: CustomPaint(
            size: const Size(52, 40),
            painter: _FulcrumPainter(),
          ),
        ),
        // Base line.
        Positioned(
          bottom: 22,
          left: edgeInset,
          right: edgeInset,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // The tilting beam + weights, centered vertically a bit above base.
        Positioned(
          bottom: 44,
          child: Transform.rotate(
            angle: beamAngle,
            child: SizedBox(
              width: beamGroupWidth,
              height: beamGroupHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // The beam bar.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: beamCenterY - _beamThickness / 2,
                    child: Container(
                      height: _beamThickness,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(_beamThickness / 2),
                      ),
                    ),
                  ),
                  // Left (fixed) weight.
                  Positioned(
                    left: (halfLen - leftFrac) - _weightSize / 2,
                    top: beamCenterY - _beamThickness / 2 - _weightSize,
                    child: _WeightDisc(
                      value: leftWeight,
                      color: AppColors.secondary,
                    ),
                  ),
                  // Right (draggable) weight.
                  Positioned(
                    left: (halfLen + rightFrac) - _weightSize / 2,
                    top: beamCenterY - _beamThickness / 2 - _weightSize,
                    child: _WeightDisc(
                      value: rightWeight,
                      color: AppColors.accent,
                      grabbable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeightDisc extends StatelessWidget {
  const _WeightDisc({
    required this.value,
    required this.color,
    this.grabbable = false,
  });

  final double value;
  final Color color;
  final bool grabbable;

  static const double _size = _BeamPainterArea._weightSize;

  String get _label {
    // Show whole numbers cleanly; keep one decimal only when needed.
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: grabbable
            ? Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        _label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FulcrumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FulcrumPainter oldDelegate) => false;
}
