import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/services/local_storage.dart';

final tasksControllerProvider = NotifierProvider<TasksController, List<TaskItem>>(TasksController.new);

class TaskItem {
  TaskItem({required this.id, required this.title, required this.done});

  final String id;
  final String title;
  final bool done;

  TaskItem copyWith({String? id, String? title, bool? done}) =>
      TaskItem(id: id ?? this.id, title: title ?? this.title, done: done ?? this.done);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};
  static TaskItem fromJson(Map<String, dynamic> json) =>
      TaskItem(id: json['id'] as String, title: json['title'] as String, done: json['done'] as bool? ?? false);
}

class TasksController extends Notifier<List<TaskItem>> {
  static const _storageKey = 'tasks_v1';

  @override
  List<TaskItem> build() {
    _hydrate();
    return const <TaskItem>[];
  }

  Future<void> _hydrate() async {
    final json = await LocalStorage.getJson(_storageKey);
    if (json is List) {
      state = json.map((e) => TaskItem.fromJson(Map<String, dynamic>.from(e))).toList();
    }
  }

  Future<void> _persist() async {
    await LocalStorage.setJson(_storageKey, state.map((e) => e.toJson()).toList());
  }

  Future<void> add(String title) async {
    state = [
      ...state,
      TaskItem(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, done: false),
    ];
    await _persist();
  }

  Future<void> toggle(String id) async {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(done: !t.done) else t,
    ];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _persist();
  }

  Future<void> clearCompleted() async {
    state = state.where((t) => !t.done).toList();
    await _persist();
  }
}