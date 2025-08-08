import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pomodoro/pomodoro_controller.dart';
import '../pomodoro/pomodoro_models.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroControllerProvider);
    final ctrl = ref.read(pomodoroControllerProvider.notifier);

    void update({
      int? focus,
      int? shortBreak,
      int? longBreak,
      int? cycles,
      bool? autoStart,
    }) {
      ctrl.updateSettings(
        state.settings.copyWith(
          focusMinutes: focus ?? state.settings.focusMinutes,
          shortBreakMinutes: shortBreak ?? state.settings.shortBreakMinutes,
          longBreakMinutes: longBreak ?? state.settings.longBreakMinutes,
          cyclesBeforeLongBreak: cycles ?? state.settings.cyclesBeforeLongBreak,
          autoStartNext: autoStart ?? state.settings.autoStartNext,
        ),
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _NumberTile(
            title: 'Focus minutes',
            value: state.settings.focusMinutes,
            onChanged: (v) => update(focus: v),
          ),
          _NumberTile(
            title: 'Short break minutes',
            value: state.settings.shortBreakMinutes,
            onChanged: (v) => update(shortBreak: v),
          ),
          _NumberTile(
            title: 'Long break minutes',
            value: state.settings.longBreakMinutes,
            onChanged: (v) => update(longBreak: v),
          ),
          _NumberTile(
            title: 'Cycles before long break',
            value: state.settings.cyclesBeforeLongBreak,
            min: 1,
            max: 12,
            onChanged: (v) => update(cycles: v),
          ),
          SwitchListTile(
            title: const Text('Auto-start next session'),
            subtitle: const Text('Start next phase automatically when timer ends'),
            value: state.settings.autoStartNext,
            onChanged: (v) => update(autoStart: v),
          ),
          const SizedBox(height: 24),
          const Text('About', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('A lightweight Pomodoro super app built with Flutter.'),
        ],
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 120,
  });

  final String title;
  final int value;
  final void Function(int value) onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$title: $value'),
      subtitle: Slider(
        value: value.toDouble(),
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: max - min,
        label: '$value',
        onChanged: (v) => onChanged(v.round()),
      ),
    );
  }
}