import 'package:flutter/material.dart';
import 'package:task_weather_app/data/models/model_task.dart';

/// ConfirmDeleteCategoryDialog prompts the user to confirm deletion of a category.
class ConfirmDeleteCategoryDialog extends StatelessWidget {
  final String category;
  final List<Task> tasksInCategory;
  final VoidCallback onDeleteConfirmed;

  const ConfirmDeleteCategoryDialog({
    super.key,
    required this.category,
    required this.tasksInCategory,
    required this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Category'),
      content: tasksInCategory.isNotEmpty
          ? Text(
              'The category "$category" contains ${tasksInCategory.length} task(s). Are you sure you want to delete it along with all its tasks?')
          : Text('Are you sure you want to delete the category "$category"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDeleteConfirmed();
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
