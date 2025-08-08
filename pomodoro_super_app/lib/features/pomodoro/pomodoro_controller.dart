import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../shared/services/local_storage.dart';
import '../../shared/services/notifications_service.dart';
import 'pomodoro_models.dart';

final pomodoroControllerProvider = NotifierProvider<PomodoroController, PomodoroState>(PomodoroController.new);

class PomodoroController extends Notifier<PomodoroState> {
  static const _storageKeySettings = 'pomodoro_settings_v1';
  static const _storageKeyStats = 'pomodoro_stats_v1';

  Timer? _ticker;

  @override
  PomodoroState build() {
    final saved = _loadSettingsSync();
    final settings = saved ?? PomodoroSettingsModel(
      focusMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      cyclesBeforeLongBreak: 4,
      autoStartNext: true,
    );
    return PomodoroState(
      phase: TimerPhase.focus,
      secondsRemaining: settings.focusMinutes * 60,
      isRunning: false,
      completedFocusSessions: 0,
      completedCycles: 0,
      settings: settings,
    );
  }

  PomodoroSettingsModel? _loadSettingsSync() {
    // Note: SharedPreferences is async. For initial state we skip and later hydrate.
    _hydrateAsync();
    return null;
  }

  Future<void> _hydrateAsync() async {
    final json = await LocalStorage.getJson(_storageKeySettings) as Map<String, dynamic>?;
    if (json != null) {
      state = state.copyWith(settings: PomodoroSettingsModel.fromJson(json));
      _resetToPhase(state.phase);
    }
  }

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isRunning) return;
      final next = state.secondsRemaining - 1;
      if (next <= 0) {
        _onTimerCompleted();
      } else {
        state = state.copyWith(secondsRemaining: next);
      }
    });
  }

  void pause() {
    if (!state.isRunning) return;
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    pause();
    _resetToPhase(state.phase);
  }

  void skip() {
    pause();
    _onTimerCompleted();
  }

  void _resetToPhase(TimerPhase phase) {
    final s = state.settings;
    final seconds = switch (phase) {
      TimerPhase.focus => s.focusMinutes * 60,
      TimerPhase.shortBreak => s.shortBreakMinutes * 60,
      TimerPhase.longBreak => s.longBreakMinutes * 60,
    };
    state = state.copyWith(phase: phase, secondsRemaining: seconds, isRunning: false);
  }

  void updateSettings(PomodoroSettingsModel newSettings) {
    state = state.copyWith(settings: newSettings);
    LocalStorage.setJson(_storageKeySettings, newSettings.toJson());
    _resetToPhase(state.phase);
  }

  void switchPhase(TimerPhase phase) {
    pause();
    _resetToPhase(phase);
  }

  String formatRemaining() {
    final minutes = state.secondsRemaining ~/ 60;
    final seconds = state.secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        ;
  }

  Future<void> _onTimerCompleted() async {
    // Record stats for focus sessions
    if (state.phase == TimerPhase.focus) {
      await _recordFocusCompletion(minutes: state.settings.focusMinutes);
      state = state.copyWith(completedFocusSessions: state.completedFocusSessions + 1);
    }

    // Determine next phase
    TimerPhase nextPhase;
    int nextCompletedCycles = state.completedCycles;
    if (state.phase == TimerPhase.focus) {
      final nextFocusCount = state.completedFocusSessions + 1;
      if (nextFocusCount % state.settings.cyclesBeforeLongBreak == 0) {
        nextPhase = TimerPhase.longBreak;
        nextCompletedCycles += 1;
      } else {
        nextPhase = TimerPhase.shortBreak;
      }
    } else {
      nextPhase = TimerPhase.focus;
    }

    _resetToPhase(nextPhase);

    await NotificationsService.showNow(
      title: switch (nextPhase) {
        TimerPhase.focus => 'Time to Focus',
        TimerPhase.shortBreak => 'Short Break',
        TimerPhase.longBreak => 'Long Break',
      },
      body: switch (nextPhase) {
        TimerPhase.focus => 'Start your next focus session.',
        TimerPhase.shortBreak => 'Take a quick breather.',
        TimerPhase.longBreak => 'Recharge with a longer break.',
      },
    );

    state = state.copyWith(completedCycles: nextCompletedCycles);

    if (state.settings.autoStartNext) {
      start();
    }
  }

  Future<void> _recordFocusCompletion({required int minutes}) async {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final json = await LocalStorage.getJson(_storageKeyStats) as Map<String, dynamic>? ?? {};
    final current = json[todayKey] as int? ?? 0;
    json[todayKey] = current + minutes;
    await LocalStorage.setJson(_storageKeyStats, json);
  }

  Future<Map<String, int>> loadStats() async {
    final json = await LocalStorage.getJson(_storageKeyStats) as Map<String, dynamic>? ?? {};
    return json.map((key, value) => MapEntry(key, (value as num).toInt()));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}