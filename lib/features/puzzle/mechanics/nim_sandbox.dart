import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/puzzle.dart';
import '../../../data/puzzles/nim_logic.dart';

/// Sandbox for the single-pile take-away game. The player (always first) removes
/// 1..maxTake stones; a PERFECT opponent replies. The player replays it to
/// discover the strategy themselves — the widget shows only what actually
/// happens each round, never the general answer or the winning rule.
class NimSandbox extends StatefulWidget {
  const NimSandbox({super.key, required this.spec});

  final NimSandboxSpec spec;

  @override
  State<NimSandbox> createState() => _NimSandboxState();
}

enum _Turn { you, opponent }

class _NimSandboxState extends State<NimSandbox> {
  late int _remaining;
  _Turn _turn = _Turn.you;
  bool _busy = false; // opponent "thinking" — locks input
  String _log = '';
  bool _gameOver = false;
  bool _youWon = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    setState(() {
      _remaining = widget.spec.stones;
      _turn = _Turn.you;
      _busy = false;
      _gameOver = false;
      _youWon = false;
      _log = 'Your move — take 1 to ${widget.spec.maxTake}.';
    });
  }

  void _finish(_Turn lastMover) {
    // Whoever took the last stone wins (or loses, in misère).
    final lastMoverWins = widget.spec.lastTakeWins;
    final youTookLast = lastMover == _Turn.you;
    _youWon = lastMoverWins ? youTookLast : !youTookLast;
    _gameOver = true;
    _log = _youWon ? 'You won this round.' : 'The opponent won this round.';
  }

  Future<void> _takeAsPlayer(int count) async {
    if (_busy || _gameOver || _turn != _Turn.you) return;
    setState(() {
      _remaining -= count;
      _log = 'You took $count.';
    });
    if (_remaining <= 0) {
      setState(() => _finish(_Turn.you));
      return;
    }
    setState(() {
      _turn = _Turn.opponent;
      _busy = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    _opponentMove();
  }

  void _opponentMove() {
    final take = nimOptimalTake(
      stones: _remaining,
      maxTake: widget.spec.maxTake,
      lastTakeWins: widget.spec.lastTakeWins,
    );
    setState(() {
      _remaining -= take;
      _log = 'Opponent took $take.';
    });
    if (_remaining <= 0) {
      setState(() => _finish(_Turn.opponent));
      return;
    }
    setState(() {
      _turn = _Turn.you;
      _busy = false;
      _log = 'Your move — take 1 to ${widget.spec.maxTake}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final maxTake = widget.spec.maxTake;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StonePile(remaining: _remaining, total: widget.spec.stones),
        const SizedBox(height: AppSpacing.md),
        Text(
          _log,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _gameOver
                ? (_youWon ? c.positive : c.nudge)
                : c.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (!_gameOver)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var n = 1; n <= maxTake; n++) ...[
                _TakeButton(
                  count: n,
                  enabled: !_busy && _turn == _Turn.you && n <= _remaining,
                  onTap: () => _takeAsPlayer(n),
                ),
                if (n < maxTake) const SizedBox(width: AppSpacing.sm),
              ],
            ],
          )
        else
          Center(
            child: TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play again'),
            ),
          ),
      ],
    );
  }
}

class _StonePile extends StatelessWidget {
  const _StonePile({required this.remaining, required this.total});

  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < total; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: i < remaining
                        ? c.accent
                        : c.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$remaining left',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TakeButton extends StatelessWidget {
  const _TakeButton({
    required this.count,
    required this.enabled,
    required this.onTap,
  });

  final int count;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      child: Text('Take $count'),
    );
  }
}
