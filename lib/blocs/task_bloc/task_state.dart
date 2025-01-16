part of 'task_bloc.dart';

@immutable
class TaskState {
  final List<Task> tasks;

  const TaskState({required this.tasks});

  TaskState copyWith({List<Task>? tasks}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
    );
  }
}
