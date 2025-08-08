# Pomodoro Super App

A Flutter super app focused on deep work: Pomodoro timer, Tasks, Stats, and Settings.

## Run

1. Install Flutter (stable) and ensure `flutter --version` works.
2. Create missing platform scaffolds (only needed if this repo was created without `flutter create`):
   ```bash
   flutter create .
   ```
3. Get packages and run:
   ```bash
   flutter pub get
   flutter run -d chrome   # or any connected device
   ```

## Features
- Pomodoro timer with focus/short/long breaks
- Auto-start next session (configurable)
- Tasks list with local persistence
- Daily stats of focused minutes
- Material 3 theming, light/dark