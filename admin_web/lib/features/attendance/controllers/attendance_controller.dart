import 'package:flutter/foundation.dart';

import '../models/attendance_record.dart';

class AttendanceController extends ChangeNotifier {
  AttendanceController({List<AttendanceRecord>? records})
    : _records = List.unmodifiable(
        records ??
            const [
              AttendanceRecord(
                id: 'aanya-am',
                student: 'Aanya Perera',
                run: SchoolRun.morning,
                status: AttendanceStatus.expected,
              ),
              AttendanceRecord(
                id: 'dineth-am',
                student: 'Dineth Silva',
                run: SchoolRun.morning,
                status: AttendanceStatus.expected,
              ),
              AttendanceRecord(
                id: 'sethum-am',
                student: 'Sethum Jayasinghe',
                run: SchoolRun.morning,
                status: AttendanceStatus.absent,
              ),
            ],
      );

  final List<AttendanceRecord> _records;
  String _query = '';
  AttendanceStatus? _status;
  SchoolRun? _run;
  String get query => _query;
  AttendanceStatus? get status => _status;
  SchoolRun? get run => _run;
  bool get hasFilters => _query.isNotEmpty || _status != null || _run != null;

  List<AttendanceRecord> get visibleRecords {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      _records.where(
        (record) =>
            (_status == null || record.status == _status) &&
            (_run == null || record.run == _run) &&
            '${record.student} ${record.run.label} ${record.status.label} ${record.absence}'
                .toLowerCase()
                .contains(query),
      ),
    );
  }

  /// Totals describe the complete sample day, independent of table filters.
  AttendanceSummary get summary => AttendanceSummary(
    total: _records.length,
    expected: _records
        .where((r) => r.status == AttendanceStatus.expected)
        .length,
    confirmed: _records
        .where(
          (r) =>
              r.status == AttendanceStatus.boarded ||
              r.status == AttendanceStatus.droppedOff,
        )
        .length,
    absent: _records.where((r) => r.status == AttendanceStatus.absent).length,
  );

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void filterStatus(AttendanceStatus? value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void filterRun(SchoolRun? value) {
    if (_run == value) return;
    _run = value;
    notifyListeners();
  }

  void reset() {
    if (!hasFilters) return;
    _query = '';
    _status = null;
    _run = null;
    notifyListeners();
  }
}
