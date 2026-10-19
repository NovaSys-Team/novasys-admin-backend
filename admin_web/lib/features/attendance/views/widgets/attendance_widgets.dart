import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/attendance_record.dart';

class AttendanceStatusBadge extends StatelessWidget {
  const AttendanceStatusBadge(this.status, {super.key});
  final AttendanceStatus status;
  @override
  Widget build(BuildContext context) => StatusBadge(
    status.label,
    tone: status == AttendanceStatus.expected
        ? BadgeTone.amber
        : BadgeTone.green,
  );
}

class AttendanceSummaryCards extends StatelessWidget {
  const AttendanceSummaryCards({super.key, required this.summary});
  final AttendanceSummary summary;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 4
          : constraints.maxWidth >= 450
          ? 2
          : 1;
      final values = {
        'Total records': summary.total,
        'Expected': summary.expected,
        'Confirmed': summary.confirmed,
        'Absent': summary.absent,
      };
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final entry in values.entries)
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
                      '${entry.value}'.padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.key == 'Confirmed'
                          ? 'Boarded or dropped off'
                          : 'Sample day · all records',
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

class AttendanceTable extends StatefulWidget {
  const AttendanceTable({super.key, required this.records});
  final List<AttendanceRecord> records;
  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 850;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        child: SingleChildScrollView(
          key: const ValueKey('attendance-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 850 : constraints.maxWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(323.83),
                1: FlexColumnWidth(237.27),
                2: FlexColumnWidth(237.72),
                3: FlexColumnWidth(265.19),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                  children: [
                    for (final title in [
                      'Student',
                      'School run',
                      'Attendance',
                      'Absence',
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.muted,
                          ),
                        ),
                      ),
                  ],
                ),
                for (final record in widget.records)
                  TableRow(
                    key: ValueKey(record.id),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AdminColors.border),
                      ),
                    ),
                    children: [
                      _cell(
                        Text(
                          record.student,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Text(
                          record.run.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AttendanceStatusBadge(record.status),
                        ),
                      ),
                      _cell(
                        Text(
                          record.absence,
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    child: child,
  );
}
