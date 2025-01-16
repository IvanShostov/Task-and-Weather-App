import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';
import 'package:task_weather_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_weather_app/data/models/model_task.dart';
import 'package:task_weather_app/ui/widgets/add_category_modal.dart';
import 'package:task_weather_app/ui/widgets/add_task_modal.dart';
import 'package:task_weather_app/ui/widgets/category_filter_modal.dart';

/// Shows the Add Category modal bottom sheet.
void showAddCategoryModal(
    BuildContext context, List<String> existingCategories) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => AddCategoryModal(
      existingCategories: existingCategories,
      onCategoryAdded: (newCategory) {
        context.read<CategoryBloc>().add(AddCategoryEvent(newCategory));
      },
    ),
  );
}

/// Shows the Add or Edit Task modal bottom sheet.
void showAddOrEditTaskModal(BuildContext context,
    {Task? taskToEdit, required VoidCallback onAddCategory}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => AddTaskModal(
      taskToEdit: taskToEdit,
      onTaskAdded: (newTask) {
        context.read<TaskBloc>().add(AddTaskEvent(newTask));
      },
      onTaskEdited: (updatedTask) {
        context.read<TaskBloc>().add(EditTaskEvent(
              updatedTask.id,
              updatedTask.title,
              updatedTask.description,
              updatedTask.category,
            ));
      },
      onAddCategory: onAddCategory,
    ),
  );
}

/// Shows the Category Filter modal bottom sheet.
void showCategoryFilterModal(BuildContext context,
    {required Map<String, bool> selectedCategories,
    required bool showCompleted,
    required bool showIncomplete,
    required Function(Map<String, bool>, bool, bool) onFilterUpdated}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => CategoryFilterModal(
      selectedCategories: selectedCategories,
      showCompleted: showCompleted,
      showIncomplete: showIncomplete,
      onFilterUpdated: onFilterUpdated,
    ),
  );
}
