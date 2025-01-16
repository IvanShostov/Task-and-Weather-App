import 'package:flutter/material.dart';

/// EmptyCategoryMessage displays a message when there are no available categories.
class EmptyCategoryMessage extends StatelessWidget {
  const EmptyCategoryMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Text(
        'No available categories. Please add a category.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
