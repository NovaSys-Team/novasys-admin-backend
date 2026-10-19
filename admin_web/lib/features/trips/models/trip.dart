enum TripStatus {
  notStarted('Not started'),
  inProgress('In progress'),
  completed('Completed'),
  cancelled('Cancelled');

  const TripStatus(this.label);
  final String label;
}

enum TripAttendance {
  expected('Expected'),
  boarded('Boarded'),
  droppedOff('Dropped off'),
  absent('Absent');

  const TripAttendance(this.label);
  final String label;
}

class Trip {
  Trip({
    required this.id,
    required this.name,
    required this.status,
    required List<TripAttendance> attendance,
  }) : attendance = List.unmodifiable(attendance);

  final String id;
  final String name;
  final TripStatus status;
  final List<TripAttendance> attendance;

  String get attendanceLabel =>
      attendance.map((entry) => entry.label).join(' / ');
}
