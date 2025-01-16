import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';
import 'package:task_weather_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_weather_app/data/models/model_task.dart';
import 'package:task_weather_app/ui/widgets/category_controls.dart';
import 'package:task_weather_app/ui/widgets/empty_category_message.dart';
import 'package:task_weather_app/ui/widgets/validated_text_field.dart';
import 'package:task_weather_app/utils/category_deletion.dart';

/// AddTaskModal allows users to add or edit a task.
class AddTaskModal extends StatefulWidget {
  final Task? taskToEdit;
  final ValueChanged<Task> onTaskAdded;
  final ValueChanged<Task> onTaskEdited;
  final VoidCallback onAddCategory;

  const AddTaskModal({
    super.key,
    this.taskToEdit,
    required this.onTaskAdded,
    required this.onTaskEdited,
    required this.onAddCategory,
  });

  @override
  AddTaskModalState createState() => AddTaskModalState();
}

class AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.taskToEdit != null) {
      _initializeEditMode();
    } else {
      _initializeDefaultCategory();
    }
  }

  /// Initializes the modal in edit mode with existing task data.
  void _initializeEditMode() {
    _titleController.text = widget.taskToEdit!.title;
    _descriptionController.text = widget.taskToEdit!.description;
    _selectedCategory = widget.taskToEdit!.category;
  }

  /// Sets a default category when adding a new task.
  void _initializeDefaultCategory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories = context.read<CategoryBloc>().state.categories;
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategory = categories.first;
        });
      }
    });
  }

  /// Saves the task after validation.
  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.taskToEdit?.id ?? DateTime.now().toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory ?? '',
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
    );

    if (widget.taskToEdit == null) {
      widget.onTaskAdded(task);
    } else {
      widget.onTaskEdited(task);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (widget.taskToEdit == null) {
          setState(() {
            _selectedCategory =
                state.categories.isNotEmpty ? state.categories.last : null;
          });
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final categories = state.categories;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskToEdit == null ? 'Add Task' : 'Edit Task',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValidatedTextField(
                      controller: _titleController,
                      labelText: 'Title',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter a task title'
                              : null,
                    ),
                    const SizedBox(height: 8),
                    ValidatedTextField(
                      maxLines: 3,
                      controller: _descriptionController,
                      labelText: 'Description',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter a task description'
                              : null,
                    ),
                    const SizedBox(height: 8),
                    CategoryControls(
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      onDeleteCategory: () {
                        if (_selectedCategory != null) {
                          final taskCount = context
                              .read<TaskBloc>()
                              .state
                              .tasks
                              .where(
                                  (task) => task.category == _selectedCategory)
                              .length;

                          showDeleteCategoryDialog(
                            context,
                            category: _selectedCategory!,
                            taskCount: taskCount,
                          );
                        }
                      },
                      onAddCategory: widget.onAddCategory,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _saveTask,
                          child: Text(
                            widget.taskToEdit == null
                                ? 'Add Task'
                                : 'Save Changes',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                    if (categories.isEmpty) const EmptyCategoryMessage(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
