import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pomodoro/pomodoro_controller.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(pomodoroControllerProvider.notifier);
    return FutureBuilder<Map<String, int>>(
      future: controller.loadStats(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const {};
        final entries = data.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: entries.isEmpty
                ? const Center(child: Text('No stats yet. Complete a focus session to see progress.'))
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      return ListTile(
                        leading: const Icon(Icons.calendar_today_rounded),
                        title: Text(e.key),
                        trailing: Text('${e.value} min'),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}