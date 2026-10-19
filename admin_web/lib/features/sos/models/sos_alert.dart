enum SosStatus {
  open('Open'),
  acknowledged('Acknowledged'),
  resolved('Resolved');

  const SosStatus(this.label);
  final String label;
}

enum SosPriority {
  critical('Critical'),
  high('High'),
  moderate('Moderate');

  const SosPriority(this.label);
  final String label;
}

class SosAlert {
  const SosAlert({
    required this.id,
    required this.title,
    required this.driver,
    required this.vehicle,
    required this.route,
    required this.location,
    required this.description,
    required this.raisedAt,
    required this.priority,
    required this.status,
  });
  final String id;
  final String title;
  final String driver;
  final String vehicle;
  final String route;
  final String location;
  final String description;
  final DateTime raisedAt;
  final SosPriority priority;
  final SosStatus status;

  String get timeLabel =>
      '${raisedAt.hour.toString().padLeft(2, '0')}:${raisedAt.minute.toString().padLeft(2, '0')}';
  SosAlert withStatus(SosStatus value) => SosAlert(
    id: id,
    title: title,
    driver: driver,
    vehicle: vehicle,
    route: route,
    location: location,
    description: description,
    raisedAt: raisedAt,
    priority: priority,
    status: value,
  );
}
