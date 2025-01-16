import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_weather_app/data/models/model_task.dart';

/// TaskListWidget displays a list of tasks with search and filter capabilities.
class TaskListWidget extends StatelessWidget {
  final String searchQuery;
  final Map<String, bool> selectedCategories;
  final bool showCompleted;
  final bool showIncomplete;
  final Function(Task) onEditTask;

  const TaskListWidget({
    super.key,
    required this.searchQuery,
    required this.selectedCategories,
    required this.showCompleted,
    required this.showIncomplete,
    required this.onEditTask,
  });

  /// Filters tasks based on search query, selected categories, and completion status.
  List<Task> _filterTasks(List<Task> tasks) {
    return tasks.where((task) {
      final matchesCategory = selectedCategories[task.category] ?? false;
      final matchesSearch = task.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = (showCompleted && task.isCompleted) ||
          (showIncomplete && !task.isCompleted);
      return matchesCategory && matchesSearch && matchesStatus;
    }).toList();
  }

  /// Shows a confirmation dialog before deleting a task.
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Task task) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete the task "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      context.read<TaskBloc>().add(RemoveTaskEvent(task.id));

      // Show SnackBar after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${task.title}" deleted.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final filteredTasks = _filterTasks(state.tasks);

        if (filteredTasks.isEmpty) {
          return const Center(
            child: Text('No tasks to display.'),
          );
        }

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];

            return ListTile(
              title: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${task.description} • ${task.category}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => onEditTask(task),
                    tooltip: 'Edit Task',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _showDeleteConfirmationDialog(context, task),
                    tooltip: 'Delete Task',
                  ),
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      context
                          .read<TaskBloc>()
                          .add(ToggleTaskStatusEvent(task.id));
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
