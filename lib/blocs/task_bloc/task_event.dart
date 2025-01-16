part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);
}

class RemoveTaskEvent extends TaskEvent {
  final String taskId;

  RemoveTaskEvent(this.taskId);
}

class EditTaskEvent extends TaskEvent {
  final String taskId;
  final String newTitle;
  final String newDescription;
  final String newCategory;

  EditTaskEvent(
      this.taskId, this.newTitle, this.newDescription, this.newCategory);
}

class ToggleTaskStatusEvent extends TaskEvent {
  final String taskId;

  ToggleTaskStatusEvent(this.taskId);
}

class DeleteTasksByCategoryEvent extends TaskEvent {
  final String category;

  DeleteTasksByCategoryEvent(this.category);
}
