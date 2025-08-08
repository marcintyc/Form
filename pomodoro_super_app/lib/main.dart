import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'shared/theme.dart';
import 'shared/widgets/app_scaffold.dart';
import 'features/pomodoro/pomodoro_page.dart';
import 'features/tasks/tasks_page.dart';
import 'features/stats/stats_page.dart';
import 'features/settings/settings_page.dart';
import 'shared/services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService.ensureInitialized();
  runApp(const ProviderScope(child: PomodoroSuperApp()));
}

final _router = GoRouter(
  initialLocation: '/pomodoro',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/pomodoro',
          pageBuilder: (context, state) => const NoTransitionPage(child: PomodoroPage()),
        ),
        GoRoute(
          path: '/tasks',
          pageBuilder: (context, state) => const NoTransitionPage(child: TasksPage()),
        ),
        GoRoute(
          path: '/stats',
          pageBuilder: (context, state) => const NoTransitionPage(child: StatsPage()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
        ),
      ],
    ),
  ],
);

class PomodoroSuperApp extends StatelessWidget {
  const PomodoroSuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pomodoro Super App',
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}