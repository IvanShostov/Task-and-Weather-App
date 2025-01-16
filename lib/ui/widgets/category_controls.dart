import 'package:flutter/material.dart';

/// CategoryControls provides UI elements to select, add, or delete categories.
class CategoryControls extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onDeleteCategory;
  final VoidCallback onAddCategory;

  const CategoryControls({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onDeleteCategory,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the selected category is valid.
    final isValidSelectedCategory =
        selectedCategory != null && categories.contains(selectedCategory);

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: isValidSelectedCategory
                ? selectedCategory
                : (categories.isNotEmpty ? categories.first : null),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: onCategoryChanged,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDeleteCategory,
          tooltip: 'Delete Category',
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: onAddCategory,
          tooltip: 'Add Category',
        ),
      ],
    );
  }
}
