import 'package:flutter/material.dart';

/// ValidatedTextField is a reusable widget for text input with validation.
class ValidatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) validator;
  final int? maxLines;

  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      textInputAction: (maxLines != null && maxLines! > 1)
          ? TextInputAction.newline
          : TextInputAction.done,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
