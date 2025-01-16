import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:task_weather_app/data/models/model_task.dart';

part 'task_event.dart';
part 'task_state.dart';

/// TaskBloc manages the state and events related to tasks.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> taskBox;

  /// Constructor initializes the bloc with the initial state and sets up event handlers.
  TaskBloc(this.taskBox) : super(TaskState(tasks: taskBox.values.toList())) {
    // Register event handlers
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<RemoveTaskEvent>(_onRemoveTask);
    on<EditTaskEvent>(_onEditTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
    on<DeleteTasksByCategoryEvent>(_onDeleteTasksByCategory);

    // Trigger the initial load of tasks
    add(LoadTasksEvent());
  }

  /// Handles loading tasks from the Hive box.
  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) {
    final tasks = taskBox.values.toList();
    emit(state.copyWith(tasks: tasks));
  }

  /// Handles adding a new task.
  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) {
    taskBox.put(event.task.id, event.task);
    final updatedTasks = taskBox.values.toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  /// Handles removing an existing task.
  void _onRemoveTask(RemoveTaskEvent event, Emitter<TaskState> emit) {
    taskBox.delete(event.taskId);
    final updatedTasks = taskBox.values.toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  /// Handles editing an existing task.
  void _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) {
    final task = taskBox.get(event.taskId);
    if (task != null) {
      final updatedTask = Task(
        id: task.id,
        title: event.newTitle,
        description: event.newDescription,
        category: event.newCategory,
        isCompleted: task.isCompleted,
      );
      taskBox.put(task.id, updatedTask);
      final updatedTasks = taskBox.values.toList();
      emit(state.copyWith(tasks: updatedTasks));
    }
  }

  /// Handles toggling the completion status of a task.
  void _onToggleTaskStatus(
      ToggleTaskStatusEvent event, Emitter<TaskState> emit) {
    final task = taskBox.get(event.taskId);
    if (task != null) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        isCompleted: !task.isCompleted,
      );
      taskBox.put(task.id, updatedTask);
      final updatedTasks = taskBox.values.toList();
      emit(state.copyWith(tasks: updatedTasks));
    }
  }

  /// Handles deleting all tasks under a specific category.
  void _onDeleteTasksByCategory(
      DeleteTasksByCategoryEvent event, Emitter<TaskState> emit) {
    final tasksToDelete =
        state.tasks.where((task) => task.category == event.category).toList();
    for (var task in tasksToDelete) {
      taskBox.delete(task.id);
    }
    final updatedTasks =
        state.tasks.where((task) => task.category != event.category).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }
}
