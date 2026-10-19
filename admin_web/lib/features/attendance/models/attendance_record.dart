enum AttendanceStatus {
  expected('Expected'),
  boarded('Boarded'),
  droppedOff('Dropped off'),
  absent('Absent');

  const AttendanceStatus(this.label);
  final String label;
}

enum SchoolRun {
  morning('Morning'),
  afternoon('Afternoon');

  const SchoolRun(this.label);
  final String label;
}

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.student,
    required this.run,
    required this.status,
    this.absence = 'None reported',
  });
  final String id;
  final String student;
  final SchoolRun run;
  final AttendanceStatus status;
  final String absence;
}

class AttendanceSummary {
  const AttendanceSummary({
    required this.total,
    required this.expected,
    required this.confirmed,
    required this.absent,
  });
  final int total;
  final int expected;
  final int confirmed;
  final int absent;
}
