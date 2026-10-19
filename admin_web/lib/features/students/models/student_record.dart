enum StudentStatus {
  active('Active'),
  pending('Pending');

  const StudentStatus(this.label);
  final String label;
}

enum StudentSortField { name, school, grade, pickup }

class StudentRecord {
  const StudentRecord({
    required this.id,
    required this.name,
    required this.school,
    required this.grade,
    required this.pickup,
    required this.parentName,
    required this.parentEmail,
    required this.status,
  });
  final String id;
  final String name;
  final String school;
  final int grade;
  final String pickup;
  final String parentName;
  final String parentEmail;
  final StudentStatus status;
}

class StudentSummary {
  const StudentSummary({
    required this.total,
    required this.active,
    required this.pending,
    required this.schools,
  });
  final int total;
  final int active;
  final int pending;
  final int schools;
}
