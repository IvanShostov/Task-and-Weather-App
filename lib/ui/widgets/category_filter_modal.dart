import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weather_app/blocs/category_bloc/category_bloc.dart';

/// CategoryFilterModal allows users to filter tasks by categories and status.
class CategoryFilterModal extends StatefulWidget {
  final Map<String, bool> selectedCategories;
  final bool showCompleted;
  final bool showIncomplete;
  final Function(Map<String, bool>, bool, bool) onFilterUpdated;

  const CategoryFilterModal({
    super.key,
    required this.selectedCategories,
    required this.showCompleted,
    required this.showIncomplete,
    required this.onFilterUpdated,
  });

  @override
  CategoryFilterModalState createState() => CategoryFilterModalState();
}

class CategoryFilterModalState extends State<CategoryFilterModal> {
  late Map<String, bool> _localSelectedCategories;
  late bool _localShowCompleted;
  late bool _localShowIncomplete;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  /// Initializes local filter states from widget properties.
  void _initializeFilters() {
    _localSelectedCategories = Map.from(widget.selectedCategories);
    _localShowCompleted = widget.showCompleted;
    _localShowIncomplete = widget.showIncomplete;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final categories = state.categories;
        _updateLocalCategories(categories);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category and Status Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView(
                    shrinkWrap: true,
                    children: categories.map((category) {
                      return CheckboxListTile(
                        title: Text(category),
                        value: _localSelectedCategories[category],
                        onChanged: (value) {
                          setState(() {
                            _localSelectedCategories[category] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Show Completed'),
                  value: _localShowCompleted,
                  onChanged: (value) {
                    setState(() {
                      _localShowCompleted = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Show Incomplete'),
                  value: _localShowIncomplete,
                  onChanged: (value) {
                    setState(() {
                      _localShowIncomplete = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _resetFilters(categories),
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Updates local selected categories based on available categories.
  void _updateLocalCategories(List<String> categories) {
    for (final category in categories) {
      _localSelectedCategories.putIfAbsent(category, () => true);
    }
    _localSelectedCategories.removeWhere((key, _) => !categories.contains(key));
  }

  /// Resets all filters to their default states.
  void _resetFilters(List<String> categories) {
    setState(() {
      _localSelectedCategories = {
        for (var category in categories) category: true,
      };
      _localShowCompleted = true;
      _localShowIncomplete = true;
    });
  }

  /// Applies the selected filters and notifies the parent widget.
  void _applyFilters() {
    widget.onFilterUpdated(
      _localSelectedCategories,
      _localShowCompleted,
      _localShowIncomplete,
    );
    Navigator.of(context).pop();
  }
}
