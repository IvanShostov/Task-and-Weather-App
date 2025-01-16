import 'package:flutter/material.dart';

/// AddCategoryModal allows users to add a new category.
class AddCategoryModal extends StatefulWidget {
  final ValueChanged<String> onCategoryAdded;
  final List<String> existingCategories;

  const AddCategoryModal({
    super.key,
    required this.onCategoryAdded,
    required this.existingCategories,
  });

  @override
  AddCategoryModalState createState() => AddCategoryModalState();
}

class AddCategoryModalState extends State<AddCategoryModal> {
  final TextEditingController _newCategoryController = TextEditingController();
  String? _errorMessage;

  /// Validates the input and adds the new category if valid.
  void _validateAndAddCategory() {
    final newCategory = _newCategoryController.text.trim();

    if (newCategory.isEmpty) {
      setState(() {
        _errorMessage = 'Category cannot be empty!';
      });
      return;
    }

    if (widget.existingCategories.contains(newCategory)) {
      setState(() {
        _errorMessage = 'This category already exists!';
      });
      return;
    }

    widget.onCategoryAdded(newCategory);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newCategoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateAndAddCategory,
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
