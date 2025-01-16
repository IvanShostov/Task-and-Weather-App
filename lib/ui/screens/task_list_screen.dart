import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';
import 'package:task_weather_app/data/models/model_task.dart';
import 'package:task_weather_app/ui/widgets/search_and_filter_widget.dart';
import 'package:task_weather_app/ui/widgets/task_list_widget.dart';
import 'package:task_weather_app/ui/widgets/weather_widget.dart';
import 'package:task_weather_app/utils/category_utils.dart';
import 'package:task_weather_app/utils/modal_helpers.dart';

/// TaskListScreen displays the list of tasks and integrates weather information.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  String searchQuery = '';
  late Box<String> categoryBox;
  late Box<Task> taskBox;
  List<String> categories = [];
  Map<String, bool> selectedCategories = {};
  bool showCompleted = true;
  bool showIncomplete = true;

  @override
  void initState() {
    super.initState();
    _initializeHiveBoxes();
    _initializeCategories();
  }

  /// Initializes Hive boxes for categories and tasks.
  void _initializeHiveBoxes() {
    categoryBox = Hive.box<String>('categories');
    taskBox = Hive.box<Task>('tasks');
  }

  /// Loads categories from the Hive box.
  void _initializeCategories() {
    categories = loadCategories(categoryBox);
    selectedCategories = {for (var category in categories) category: true};
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFilterActive = selectedCategories.values.contains(false) ||
        !showCompleted ||
        !showIncomplete;

    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        setState(() {
          categories = state.categories;
          for (var category in categories) {
            selectedCategories.putIfAbsent(category, () => true);
          }
          selectedCategories.removeWhere((key, _) => !categories.contains(key));
        });
      },
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Task and Weather App'),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  SearchAndFilterWidget(
                    onSearch: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    onFilterPressed: () => showCategoryFilterModal(
                      context,
                      selectedCategories: selectedCategories,
                      showCompleted: showCompleted,
                      showIncomplete: showIncomplete,
                      onFilterUpdated:
                          (updatedSelectedCategories, completed, incomplete) {
                        setState(() {
                          selectedCategories = updatedSelectedCategories;
                          showCompleted = completed;
                          showIncomplete = incomplete;
                        });
                      },
                    ),
                    isFilterActive: isFilterActive,
                  ),
                  Expanded(
                    child: TaskListWidget(
                        searchQuery: searchQuery,
                        selectedCategories: selectedCategories,
                        showCompleted: showCompleted,
                        showIncomplete: showIncomplete,
                        onEditTask: (task) => showAddOrEditTaskModal(context,
                            taskToEdit: task,
                            onAddCategory: () =>
                                showAddCategoryModal(context, categories))),
                  ),
                ],
              ),
              const WeatherWidget(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddOrEditTaskModal(context,
                onAddCategory: () => showAddCategoryModal(context, categories)),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
