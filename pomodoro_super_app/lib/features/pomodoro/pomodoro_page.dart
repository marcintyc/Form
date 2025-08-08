import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pomodoro_controller.dart';
import 'pomodoro_models.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroControllerProvider);
    final controller = ref.read(pomodoroControllerProvider.notifier);

    String phaseLabel(TimerPhase p) => switch (p) {
          TimerPhase.focus => 'Focus',
          TimerPhase.shortBreak => 'Short Break',
          TimerPhase.longBreak => 'Long Break',
        };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            SegmentedButton<TimerPhase>(
              segments: const [
                ButtonSegment(value: TimerPhase.focus, label: Text('Focus'), icon: Icon(Icons.timer_rounded)),
                ButtonSegment(value: TimerPhase.shortBreak, label: Text('Short'), icon: Icon(Icons.coffee_rounded)),
                ButtonSegment(value: TimerPhase.longBreak, label: Text('Long'), icon: Icon(Icons.spa_rounded)),
              ],
              selected: {state.phase},
              onSelectionChanged: (s) => controller.switchPhase(s.first),
            ),
            const Spacer(),
            _TimerCircle(timeText: controller.formatRemaining(), phase: phaseLabel(state.phase)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: state.isRunning ? controller.pause : controller.start,
                  icon: Icon(state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(state.isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: controller.reset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  onPressed: controller.skip,
                  icon: const Icon(Icons.skip_next_rounded),
                  tooltip: 'Skip',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _StatChip(icon: Icons.check_circle_rounded, label: 'Focus sessions', value: '${state.completedFocusSessions}'),
                _StatChip(icon: Icons.all_inclusive_rounded, label: 'Cycles', value: '${state.completedCycles}'),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _TimerCircle extends StatelessWidget {
  const _TimerCircle({required this.timeText, required this.phase});
  final String timeText;
  final String phase;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: CircularProgressIndicator(
            value: null, // Indeterminate for simplicity; can be computed as remaining/total
            strokeWidth: 10,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(timeText, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(phase, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$label: '),
          Text(value, style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}