import 'package:flutter/material.dart';

import '../../core/theme/admin_theme.dart';

/// Compact record search used above administrator tables.
class RecordSearchField extends StatelessWidget {
  const RecordSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13, color: AdminColors.ink),
          decoration: InputDecoration(
            hintText: 'Search these records…',
            hintStyle: const TextStyle(fontSize: 13, color: AdminColors.muted),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AdminColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AdminColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AdminColors.teal),
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
        ),
      );
}
