import 'package:hive/hive.dart';

/// loadCategories retrieves categories from the Hive box.
/// If no categories are found, it initializes with default categories.
List<String> loadCategories(Box<String> categoryBox) {
  final storedCategories = categoryBox.values.toList();
  if (storedCategories.isEmpty) {
    final defaultCategories = ['General', 'Work', 'Personal'];
    for (var category in defaultCategories) {
      categoryBox.add(category);
    }
    return defaultCategories;
  } else {
    return storedCategories.cast<String>();
  }
}
