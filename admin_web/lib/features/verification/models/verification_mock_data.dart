import 'verification_request.dart';

/// Fictional metadata and watermarked placeholders, never real credentials.
List<VerificationRequest> verificationMockRequests() {
  final date = DateTime(2026, 10, 19);
  List<VerificationDocument> documents({
    bool approved = false,
    bool rejected = false,
  }) => [
    for (final type in VerificationDocumentType.values.where(
      (t) => t != VerificationDocumentType.police,
    ))
      VerificationDocument(
        type: type,
        format: type.index < 4 ? DocumentFormat.image : DocumentFormat.pdf,
        uploadedAt: date,
        expiresAt:
            [
              VerificationDocumentType.insurance,
              VerificationDocumentType.revenue,
              VerificationDocumentType.licenceFront,
            ].contains(type)
            ? DateTime(2027, 10, 19)
            : null,
        pageCount: type == VerificationDocumentType.registration ? 2 : 1,
        status: approved
            ? DocumentReviewStatus.approved
            : rejected && type == VerificationDocumentType.nicFront
            ? DocumentReviewStatus.rejected
            : DocumentReviewStatus.pending,
        note: rejected && type == VerificationDocumentType.nicFront
            ? 'Demo: please provide a clearer front image.'
            : '',
        reviewedAt:
            approved || rejected && type == VerificationDocumentType.nicFront
            ? date
            : null,
        reviewer:
            approved || rejected && type == VerificationDocumentType.nicFront
            ? 'Administrator · demo'
            : null,
      ),
  ];
  return [
    VerificationRequest(
      id: 'verification-001',
      driverId: 'DEMO-DRV-001',
      driver: 'Sunil Perera',
      phone: 'Demo · 07X XXX 0001',
      email: 'sunil@example.test',
      vehicle: 'WP NC–4821 · School van',
      submittedAt: date,
      status: VerificationStatus.underReview,
      documents: documents(),
    ),
    VerificationRequest(
      id: 'verification-002',
      driverId: 'DEMO-DRV-002',
      driver: 'Nimal Silva',
      phone: 'Demo · 07X XXX 0002',
      email: 'nimal@example.test',
      submittedAt: date,
      status: VerificationStatus.pending,
      documents: documents()
          .where((doc) => doc.type != VerificationDocumentType.nicBack)
          .toList(),
    ),
    VerificationRequest(
      id: 'verification-003',
      driverId: 'DEMO-DRV-003',
      driver: 'Kamal Fernando',
      phone: 'Demo · 07X XXX 0003',
      email: 'kamal@example.test',
      vehicle: 'DEMO–003 · School van',
      submittedAt: date,
      status: VerificationStatus.approved,
      documents: documents(approved: true),
      decidedAt: date,
    ),
    VerificationRequest(
      id: 'verification-004',
      driverId: 'DEMO-DRV-004',
      driver: 'Ruwan Jayasinghe',
      phone: 'Demo · 07X XXX 0004',
      email: 'ruwan@example.test',
      submittedAt: date,
      status: VerificationStatus.rejected,
      documents: documents(rejected: true),
      rejectionReason: 'Demo: NIC image needs resubmission.',
      decidedAt: date,
    ),
  ];
}
