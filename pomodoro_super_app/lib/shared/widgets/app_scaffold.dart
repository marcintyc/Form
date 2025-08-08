import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem('/pomodoro', Icons.timer_rounded, 'Focus'),
    _TabItem('/tasks', Icons.checklist_rounded, 'Tasks'),
    _TabItem('/stats', Icons.insights_rounded, 'Stats'),
    _TabItem('/settings', Icons.settings_rounded, 'Settings'),
  ];

  int _indexForLocation(String location) {
    return _tabs.indexWhere((t) => location.startsWith(t.location)).clamp(0, _tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              label: t.label,
            ),
        ],
        onDestinationSelected: (index) {
          final loc = _tabs[index].location;
          if (loc != location) context.go(loc);
        },
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.location, this.icon, this.label);
  final String location;
  final IconData icon;
  final String label;
}