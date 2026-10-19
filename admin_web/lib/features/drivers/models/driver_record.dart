enum DriverStatus {
  verified('Verified'),
  pending('Pending');

  const DriverStatus(this.label);
  final String label;
}

enum DriverDocumentType {
  licence('Driving licence'),
  registration('Vehicle registration'),
  insurance('Vehicle insurance');

  const DriverDocumentType(this.label);
  final String label;
}

enum DriverDocumentStatus {
  awaitingReview('Awaiting review'),
  reviewed('Reviewed');

  const DriverDocumentStatus(this.label);
  final String label;
}

enum DriverDocumentFilter {
  complete('Complete documents'),
  incomplete('Missing documents');

  const DriverDocumentFilter(this.label);
  final String label;
}

class DriverDocument {
  const DriverDocument({required this.type, required this.status});
  final DriverDocumentType type;
  final DriverDocumentStatus status;
}

class DriverRecord {
  DriverRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.vehicle,
    required List<DriverDocument> documents,
  }) : documents = List.unmodifiable(documents);
  final String id;
  final String name;
  final String email;
  final DriverStatus status;
  final String? vehicle;
  final List<DriverDocument> documents;
  String get vehicleLabel => vehicle ?? 'Awaiting registration';
  bool get hasCompleteDocuments => DriverDocumentType.values.every(
    (type) => documents.any((document) => document.type == type),
  );
  String get documentsLabel => documents.isEmpty
      ? '0 selected'
      : '${documents.length} sample document${documents.length == 1 ? '' : 's'}';
}
