import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/student_record.dart';

class StudentsTable extends StatefulWidget {
  const StudentsTable({
    super.key,
    required this.students,
    required this.sortField,
    required this.ascending,
    required this.onSort,
    required this.onProfile,
  });
  final List<StudentRecord> students;
  final StudentSortField sortField;
  final bool ascending;
  final ValueChanged<StudentSortField> onSort;
  final ValueChanged<StudentRecord> onProfile;
  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 900;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        child: SingleChildScrollView(
          key: const ValueKey('students-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 900 : constraints.maxWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(246.3),
                1: FlexColumnWidth(253.52),
                2: FlexColumnWidth(155.42),
                3: FlexColumnWidth(408.77),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                  children: [
                    for (final entry in {
                      'Student': StudentSortField.name,
                      'School': StudentSortField.school,
                      'Grade': StudentSortField.grade,
                      'Pickup': StudentSortField.pickup,
                    }.entries)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Tooltip(
                          message: 'Sort by ${entry.key.toLowerCase()}',
                          child: TextButton(
                            key: ValueKey('sort-${entry.value.name}'),
                            onPressed: () => widget.onSort(entry.value),
                            style: TextButton.styleFrom(
                              foregroundColor: AdminColors.muted,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 15,
                              ),
                              minimumSize: const Size(0, 43),
                              textStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(entry.key),
                                const SizedBox(width: 6),
                                Icon(
                                  widget.sortField == entry.value
                                      ? (widget.ascending
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward)
                                      : Icons.unfold_more,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                for (final student in widget.students)
                  TableRow(
                    key: ValueKey('student-row-${student.id}'),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AdminColors.border),
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Tooltip(
                          message: 'View profile for ${student.name}',
                          child: TextButton(
                            key: ValueKey('student-profile-${student.id}'),
                            onPressed: () => widget.onProfile(student),
                            style: TextButton.styleFrom(
                              foregroundColor: AdminColors.ink,
                              textStyle: const TextStyle(fontSize: 12),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 18,
                              ),
                            ),
                            child: Text(student.name),
                          ),
                        ),
                      ),
                      _cell(
                        Text(
                          student.school,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Text(
                          '${student.grade}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Text(
                          student.pickup,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
  Widget _cell(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    child: child,
  );
}
