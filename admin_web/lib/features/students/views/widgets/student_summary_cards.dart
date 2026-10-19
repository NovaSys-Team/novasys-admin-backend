import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/student_record.dart';

class StudentSummaryCards extends StatelessWidget {
  const StudentSummaryCards({super.key, required this.summary});
  final StudentSummary summary;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 4
          : constraints.maxWidth >= 450
          ? 2
          : 1;
      final counts = {
        'Total students': summary.total,
        'Active students': summary.active,
        'Pending students': summary.pending,
        'Schools': summary.schools,
      };
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final entry in counts.entries)
            SizedBox(
              width: (constraints.maxWidth - (columns - 1) * 16) / columns,
              child: AdminPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AdminColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      entry.value.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sample data · all records',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}
