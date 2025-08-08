import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tasks_controller.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksControllerProvider);
    final tasksCtrl = ref.read(tasksControllerProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Add a task to focus on',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) async {
                      if (value.trim().isEmpty) return;
                      await tasksCtrl.add(value.trim());
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () async {
                    final value = _controller.text.trim();
                    if (value.isEmpty) return;
                    await tasksCtrl.add(value);
                    _controller.clear();
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Add one to stay focused.'))
                  : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final t = tasks[index];
                        return ListTile(
                          leading: Checkbox(
                            value: t.done,
                            onChanged: (_) => tasksCtrl.toggle(t.id),
                          ),
                          title: Text(
                            t.title,
                            style: TextStyle(
                              decoration: t.done ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => tasksCtrl.remove(t.id),
                          ),
                        );
                      },
                    ),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: tasksCtrl.clearCompleted,
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Clear completed'),
                ),
                const Spacer(),
                Text('${tasks.where((t) => !t.done).length} remaining'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}