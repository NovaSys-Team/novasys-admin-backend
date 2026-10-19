enum VerificationStatus {
  pending('Pending'),
  underReview('Under Review'),
  approved('Approved'),
  rejected('Rejected');

  const VerificationStatus(this.label);
  final String label;
}

enum DocumentReviewStatus {
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected');

  const DocumentReviewStatus(this.label);
  final String label;
}

enum VerificationDocumentType {
  nicFront('NIC · front'),
  nicBack('NIC · back'),
  licenceFront('Driving licence · front'),
  licenceBack('Driving licence · back'),
  registration('Vehicle Registration Certificate'),
  insurance('Vehicle Insurance Certificate'),
  revenue('Revenue Licence'),
  police('Police Clearance Certificate');

  const VerificationDocumentType(this.label);
  final String label;
}

enum DocumentFormat { image, pdf }

class VerificationDocument {
  const VerificationDocument({
    required this.type,
    required this.format,
    required this.uploadedAt,
    this.number,
    this.expiresAt,
    this.status = DocumentReviewStatus.pending,
    this.note = '',
    this.reviewedAt,
    this.reviewer,
    this.pageCount = 1,
  });
  final VerificationDocumentType type;
  final DocumentFormat format;
  final DateTime uploadedAt;
  final String? number;
  final DateTime? expiresAt;
  final DocumentReviewStatus status;
  final String note;
  final DateTime? reviewedAt;
  final String? reviewer;
  final int pageCount;

  VerificationDocument withNote(String note) => VerificationDocument(
    type: type,
    format: format,
    uploadedAt: uploadedAt,
    number: number,
    expiresAt: expiresAt,
    status: status,
    note: note,
    reviewedAt: reviewedAt,
    reviewer: reviewer,
    pageCount: pageCount,
  );
  VerificationDocument withDecision(
    DocumentReviewStatus status,
    DateTime now,
  ) => VerificationDocument(
    type: type,
    format: format,
    uploadedAt: uploadedAt,
    number: number,
    expiresAt: expiresAt,
    status: status,
    note: note,
    reviewedAt: status == DocumentReviewStatus.pending ? null : now,
    reviewer: status == DocumentReviewStatus.pending
        ? null
        : 'Administrator · demo',
    pageCount: pageCount,
  );
}

class VerificationRequest {
  VerificationRequest({
    required this.id,
    required this.driverId,
    required this.driver,
    required this.phone,
    required this.email,
    required this.submittedAt,
    required this.status,
    required List<VerificationDocument> documents,
    this.vehicle,
    this.policeRequired = false,
    this.rejectionReason = '',
    this.decidedAt,
  }) : documents = List.unmodifiable(documents);
  final String id;
  final String driverId;
  final String driver;
  final String phone;
  final String email;
  final String? vehicle;
  final DateTime submittedAt;
  final VerificationStatus status;
  final bool policeRequired;
  final List<VerificationDocument> documents;
  final String rejectionReason;
  final DateTime? decidedAt;
  List<VerificationDocumentType> get requiredTypes => VerificationDocumentType
      .values
      .where(
        (type) => type != VerificationDocumentType.police || policeRequired,
      )
      .toList(growable: false);
  VerificationDocument? document(VerificationDocumentType type) {
    final matches = documents.where((doc) => doc.type == type);
    return matches.isEmpty ? null : matches.first;
  }

  int count(DocumentReviewStatus status) =>
      requiredTypes.where((type) => document(type)?.status == status).length;
  int get missingCount =>
      requiredTypes.where((type) => document(type) == null).length;
  int get pendingCount => count(DocumentReviewStatus.pending) + missingCount;
  double get progress =>
      count(DocumentReviewStatus.approved) / requiredTypes.length;
  bool get canApprove =>
      status != VerificationStatus.approved &&
      requiredTypes.every(
        (type) => document(type)?.status == DocumentReviewStatus.approved,
      );
  VerificationRequest copyWith({
    VerificationStatus? status,
    List<VerificationDocument>? documents,
    String? rejectionReason,
    DateTime? decidedAt,
    bool clearDecision = false,
  }) => VerificationRequest(
    id: id,
    driverId: driverId,
    driver: driver,
    phone: phone,
    email: email,
    vehicle: vehicle,
    submittedAt: submittedAt,
    policeRequired: policeRequired,
    status: status ?? this.status,
    documents: documents ?? this.documents,
    rejectionReason: rejectionReason ?? this.rejectionReason,
    decidedAt: clearDecision ? null : decidedAt ?? this.decidedAt,
  );
}

String verificationDate(DateTime? date) => date == null
    ? 'Not provided'
    : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
