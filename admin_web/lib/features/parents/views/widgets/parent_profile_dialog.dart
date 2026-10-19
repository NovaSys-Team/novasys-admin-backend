import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/parent_record.dart';
import 'parent_status_badge.dart';

class ParentProfileDialog extends StatelessWidget {
  const ParentProfileDialog({super.key, required this.parent});
  final ParentRecord parent;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Parent profile'),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sample parent profile · read-only preview',
              style: TextStyle(fontSize: 11, color: AdminColors.teal),
            ),
            const SizedBox(height: 20),
            Text(parent.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ParentStatusBadge(parent.status),
            const SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(fontSize: 11, color: AdminColors.muted),
            ),
            const SizedBox(height: 6),
            Text(parent.email),
            const SizedBox(height: 24),
            Text(
              'Linked children (${parent.children.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (parent.children.isEmpty) const Text('No linked children.'),
            for (final child in parent.children)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdminPanel(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${child.school} · Grade ${child.grade}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}
