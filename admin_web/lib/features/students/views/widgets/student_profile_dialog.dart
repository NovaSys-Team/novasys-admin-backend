import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/student_record.dart';

class StudentProfileDialog extends StatelessWidget {
  const StudentProfileDialog({super.key, required this.student});
  final StudentRecord student;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Student profile'),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sample student profile · read-only preview',
              style: TextStyle(fontSize: 11, color: AdminColors.teal),
            ),
            const SizedBox(height: 20),
            Text(student.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            StatusBadge(
              student.status.label,
              tone: student.status == StudentStatus.active
                  ? BadgeTone.green
                  : BadgeTone.amber,
            ),
            const SizedBox(height: 20),
            _detail('School', student.school),
            _detail('Grade', '${student.grade}'),
            _detail('Pickup', student.pickup),
            const SizedBox(height: 8),
            Text(
              'Parent / guardian',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(student.parentName),
            const SizedBox(height: 8),
            Text(student.parentEmail),
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
  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AdminColors.muted),
        ),
        const SizedBox(height: 6),
        Text(value),
      ],
    ),
  );
}
