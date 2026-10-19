import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_record.dart';
import 'widgets/attendance_widgets.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key, required this.controller});
  final AttendanceController controller;
  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  late final _search = TextEditingController(text: widget.controller.query);
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    widget.controller.reset();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      final records = controller.visibleRecords;
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
                    'Attendance',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Follow explicit boarding, drop-off and absence records.',
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
          AttendanceSummaryCards(summary: controller.summary),
          const SizedBox(height: 24),
          AdminPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF4F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'GPS arrival does not mark attendance. Drivers explicitly confirm each boarding and drop-off.',
                    style: TextStyle(fontSize: 12, color: AdminColors.teal),
                  ),
                ),
                const SizedBox(height: 24),
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
                      child: _filter<AttendanceStatus>(
                        label: 'Attendance status',
                        value: controller.status,
                        values: AttendanceStatus.values,
                        labelFor: (value) => value.label,
                        onChanged: controller.filterStatus,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: _filter<SchoolRun>(
                        label: 'School run',
                        value: controller.run,
                        values: SchoolRun.values,
                        labelFor: (value) => value.label,
                        onChanged: controller.filterRun,
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
                AttendanceTable(records: records),
                if (records.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      children: [
                        const Text(
                          'No attendance records match your search or filters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AdminColors.muted),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _reset,
                          child: const Text('Show all records'),
                        ),
                      ],
                    ),
                  ),
              ],
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
