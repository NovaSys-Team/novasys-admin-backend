enum ParentStatus {
  active('Active'),
  inactive('Inactive');

  const ParentStatus(this.label);
  final String label;
}

enum ParentChildrenFilter {
  withChildren('With children'),
  withoutChildren('Without children');

  const ParentChildrenFilter(this.label);
  final String label;
}

class ParentChild {
  const ParentChild({
    required this.id,
    required this.name,
    required this.school,
    required this.grade,
  });
  final String id;
  final String name;
  final String school;
  final String grade;
}

class ParentRecord {
  ParentRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required List<ParentChild> children,
  }) : children = List.unmodifiable(children);
  final String id;
  final String name;
  final String email;
  final ParentStatus status;
  final List<ParentChild> children;
}
