import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';
import 'package:task_weather_app/blocs/task_bloc/task_bloc.dart';

/// Displays a confirmation dialog for deleting a category.
/// If [taskCount] is greater than zero, the dialog informs the user
/// that deleting the category will also delete all associated tasks.
void showDeleteCategoryDialog(
  BuildContext context, {
  required String category,
  required int taskCount,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Category'),
        content: taskCount == 0
            ? Text('Are you sure you want to delete the category "$category"?')
            : Text(
                'The category "$category" contains $taskCount task(s). Do you want to delete it along with all its tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Trigger the deletion of the category.
              context.read<CategoryBloc>().add(DeleteCategoryEvent(category));
              // Trigger the deletion of all tasks under the category.
              context
                  .read<TaskBloc>()
                  .add(DeleteTasksByCategoryEvent(category));
              // Close the dialog.
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
