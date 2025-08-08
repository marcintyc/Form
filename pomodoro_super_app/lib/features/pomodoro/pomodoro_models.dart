enum TimerPhase { focus, shortBreak, longBreak }

class PomodoroSettingsModel {
  PomodoroSettingsModel({
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.cyclesBeforeLongBreak,
    required this.autoStartNext,
  });

  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cyclesBeforeLongBreak;
  final bool autoStartNext;

  PomodoroSettingsModel copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? cyclesBeforeLongBreak,
    bool? autoStartNext,
  }) {
    return PomodoroSettingsModel(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      cyclesBeforeLongBreak: cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
      autoStartNext: autoStartNext ?? this.autoStartNext,
    );
  }

  Map<String, dynamic> toJson() => {
        'focusMinutes': focusMinutes,
        'shortBreakMinutes': shortBreakMinutes,
        'longBreakMinutes': longBreakMinutes,
        'cyclesBeforeLongBreak': cyclesBeforeLongBreak,
        'autoStartNext': autoStartNext,
      };

  static PomodoroSettingsModel fromJson(Map<String, dynamic> json) => PomodoroSettingsModel(
        focusMinutes: json['focusMinutes'] as int? ?? 25,
        shortBreakMinutes: json['shortBreakMinutes'] as int? ?? 5,
        longBreakMinutes: json['longBreakMinutes'] as int? ?? 15,
        cyclesBeforeLongBreak: json['cyclesBeforeLongBreak'] as int? ?? 4,
        autoStartNext: json['autoStartNext'] as bool? ?? true,
      );
}

class PomodoroState {
  PomodoroState({
    required this.phase,
    required this.secondsRemaining,
    required this.isRunning,
    required this.completedFocusSessions,
    required this.completedCycles,
    required this.settings,
  });

  final TimerPhase phase;
  final int secondsRemaining;
  final bool isRunning;
  final int completedFocusSessions;
  final int completedCycles;
  final PomodoroSettingsModel settings;

  PomodoroState copyWith({
    TimerPhase? phase,
    int? secondsRemaining,
    bool? isRunning,
    int? completedFocusSessions,
    int? completedCycles,
    PomodoroSettingsModel? settings,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
      completedFocusSessions: completedFocusSessions ?? this.completedFocusSessions,
      completedCycles: completedCycles ?? this.completedCycles,
      settings: settings ?? this.settings,
    );
  }
}