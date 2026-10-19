import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/students_controller.dart';
import '../models/student_record.dart';
import 'widgets/student_profile_dialog.dart';
import 'widgets/student_summary_cards.dart';
import 'widgets/students_table.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key, required this.controller});
  final StudentsController controller;
  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  late final _search = TextEditingController(text: widget.controller.query);
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    widget.controller.resetFilters();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      final students = controller.visibleStudents;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NOVASYS / CONTROL CENTER',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Manage students across your school transport network.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AdminColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '19 Oct 2026'),
                      TextSpan(
                        text: '  · Morning',
                        style: TextStyle(color: AdminColors.muted),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          StudentSummaryCards(summary: controller.summary),
          const SizedBox(height: 24),
          AdminPanel(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 332),
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: RecordSearchField(
                            controller: _search,
                            onChanged: controller.search,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: _filter<String>(
                            label: 'School',
                            value: controller.school,
                            values: controller.schools,
                            labelFor: (v) => v,
                            onChanged: controller.filterSchool,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: _filter<int>(
                            label: 'Grade',
                            value: controller.grade,
                            values: controller.grades,
                            labelFor: (v) => '$v',
                            onChanged: controller.filterGrade,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: _filter<StudentStatus>(
                            label: 'Student status',
                            value: controller.status,
                            values: StudentStatus.values,
                            labelFor: (v) => v.label,
                            onChanged: controller.filterStatus,
                          ),
                        ),
                        if (controller.hasFilters)
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Reset filters'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StudentsTable(
                      students: students,
                      sortField: controller.sortField,
                      ascending: controller.ascending,
                      onSort: controller.sortBy,
                      onProfile: (student) => showDialog<void>(
                        context: context,
                        builder: (context) =>
                            StudentProfileDialog(student: student),
                      ),
                    ),
                    if (students.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            const Text(
                              'No students match your search or filters.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AdminColors.muted),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _reset,
                              child: const Text('Show all students'),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Sample data · Select a student name to view their profile.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _filter<T>({
    required String label,
    required T? value,
    required List<T> values,
    required String Function(T) labelFor,
    required ValueChanged<T?> onChanged,
  }) => InputDecorator(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11, color: AdminColors.muted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        isDense: true,
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: AdminColors.ink),
        items: [
          DropdownMenuItem<T>(value: null, child: const Text('All')),
          for (final option in values)
            DropdownMenuItem<T>(value: option, child: Text(labelFor(option))),
        ],
        onChanged: onChanged,
      ),
    ),
  );
}
