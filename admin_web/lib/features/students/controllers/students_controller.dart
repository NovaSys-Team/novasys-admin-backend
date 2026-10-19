import 'package:flutter/foundation.dart';

import '../models/student_record.dart';

class StudentsController extends ChangeNotifier {
  StudentsController({List<StudentRecord>? students})
    : _students = List.unmodifiable(
        students ??
            const [
              StudentRecord(
                id: 'student-001',
                name: 'Aanya Perera',
                school: 'Royal College',
                grade: 4,
                pickup: 'Temple Road, Nugegoda',
                parentName: 'Nethmi Perera',
                parentEmail: 'nethmi@example.test',
                status: StudentStatus.active,
              ),
              StudentRecord(
                id: 'student-002',
                name: 'Dineth Silva',
                school: 'Royal College',
                grade: 6,
                pickup: 'High Level Road, Maharagama',
                parentName: 'Dilini Silva',
                parentEmail: 'dilini@example.test',
                status: StudentStatus.active,
              ),
              StudentRecord(
                id: 'student-003',
                name: 'Sethum Jayasinghe',
                school: 'Ananda College',
                grade: 10,
                pickup: 'Kottawa Road, Pannipitiya',
                parentName: 'Kasun Jayasinghe',
                parentEmail: 'kasun@example.test',
                status: StudentStatus.pending,
              ),
            ],
      );
  final List<StudentRecord> _students;
  String _query = '';
  String get query => _query;
  String? _school;
  String? get school => _school;
  int? _grade;
  int? get grade => _grade;
  StudentStatus? _status;
  StudentStatus? get status => _status;
  StudentSortField _sortField = StudentSortField.name;
  StudentSortField get sortField => _sortField;
  bool _ascending = true;
  bool get ascending => _ascending;
  bool get hasFilters =>
      _query.isNotEmpty || _school != null || _grade != null || _status != null;
  List<String> get schools => List.unmodifiable(
    _students.map((s) => s.school).toSet().toList()..sort(),
  );
  List<int> get grades =>
      List.unmodifiable(_students.map((s) => s.grade).toSet().toList()..sort());
  StudentSummary get summary => StudentSummary(
    total: _students.length,
    active: _students.where((s) => s.status == StudentStatus.active).length,
    pending: _students.where((s) => s.status == StudentStatus.pending).length,
    schools: schools.length,
  );

  List<StudentRecord> get visibleStudents {
    final query = _query.trim().toLowerCase();
    final result = _students
        .where(
          (student) =>
              (_school == null || student.school == _school) &&
              (_grade == null || student.grade == _grade) &&
              (_status == null || student.status == _status) &&
              '${student.name} ${student.school} ${student.grade} ${student.pickup} ${student.parentName} ${student.parentEmail} ${student.status.label}'
                  .toLowerCase()
                  .contains(query),
        )
        .toList();
    result.sort((a, b) {
      var comparison = switch (_sortField) {
        StudentSortField.name => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        StudentSortField.school => a.school.toLowerCase().compareTo(
          b.school.toLowerCase(),
        ),
        StudentSortField.grade => a.grade.compareTo(b.grade),
        StudentSortField.pickup => a.pickup.toLowerCase().compareTo(
          b.pickup.toLowerCase(),
        ),
      };
      if (comparison == 0) comparison = a.id.compareTo(b.id);
      return _ascending ? comparison : -comparison;
    });
    return List.unmodifiable(result);
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void filterSchool(String? value) {
    if (_school == value) return;
    _school = value;
    notifyListeners();
  }

  void filterGrade(int? value) {
    if (_grade == value) return;
    _grade = value;
    notifyListeners();
  }

  void filterStatus(StudentStatus? value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void sortBy(StudentSortField field) {
    _ascending = _sortField == field ? !_ascending : true;
    _sortField = field;
    notifyListeners();
  }

  void resetFilters() {
    if (!hasFilters) return;
    _query = '';
    _school = null;
    _grade = null;
    _status = null;
    notifyListeners();
  }
}
