import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/verification/controllers/verification_controller.dart';
import 'package:novasys_admin/features/verification/models/verification_request.dart';
import 'package:novasys_admin/features/verification/models/verification_mock_data.dart';
import 'package:novasys_admin/features/verification/views/widgets/document_preview.dart';
import 'package:novasys_admin/features/verification/views/widgets/verification_review_panel.dart';

void main() {
  test(
    'all required document sides, review eligibility and missing submissions',
    () {
      final controller = VerificationController();
      addTearDown(controller.dispose);
      const id = 'verification-002';
      expect(controller.requestById(id).requiredTypes.length, 7);
      expect(controller.requestById(id).missingCount, 1);
      expect(
        controller.reviewDocument(
          id,
          VerificationDocumentType.nicBack,
          DocumentReviewStatus.approved,
        ),
        isNotNull,
      );
      for (final doc in controller.requestById(id).documents) {
        expect(
          controller.reviewDocument(
            id,
            doc.type,
            DocumentReviewStatus.approved,
          ),
          isNull,
        );
      }
      expect(controller.approve(id), isNotNull);
      expect(controller.requestById(id).progress, lessThan(1));
    },
  );

  test('notes, rejection reason, reviewer timestamps and revisiting a rejected document', () {
    final now = DateTime(2026, 10, 20, 9);
    final controller = VerificationController(now: () => now);
    addTearDown(controller.dispose);
    const id = 'verification-001';
    const type = VerificationDocumentType.nicFront;
    expect(
      controller.reviewDocument(id, type, DocumentReviewStatus.rejected),
      isNotNull,
    );
    controller.saveNote(id, type, 'Unreadable sample front image');
    expect(
      controller.reviewDocument(id, type, DocumentReviewStatus.rejected),
      isNull,
    );
    expect(controller.requestById(id).document(type)!.reviewedAt, now);
    expect(
      controller.requestById(id).document(type)!.reviewer,
      'Administrator · demo',
    );
    expect(controller.requestById(id).count(DocumentReviewStatus.rejected), 1);
    controller.openRequest(id);
    controller.closeRequest();
    controller.openRequest(id);
    expect(
      controller.requestById(id).document(type)!.note,
      'Unreadable sample front image',
    );
    expect(controller.reject(id, '   '), isNotNull);
    expect(controller.reject(id, '  Needs clearer documents  '), isNull);
    expect(
      controller.requestById(id).rejectionReason,
      'Needs clearer documents',
    );
    expect(
      controller.reviewDocument(id, type, DocumentReviewStatus.approved),
      isNull,
    );
    expect(controller.requestById(id).status, VerificationStatus.underReview);
    expect(controller.requestById(id).rejectionReason, isEmpty);
    for (final document in controller.requestById(id).documents) {
      controller.reviewDocument(
        id,
        document.type,
        DocumentReviewStatus.approved,
      );
    }
    expect(controller.requestById(id).canApprove, isTrue);
    expect(controller.requestById(id).progress, 1);
    expect(controller.approve(id), isNull);
    expect(controller.requestById(id).status, VerificationStatus.approved);
    controller.reviewDocument(id, type, DocumentReviewStatus.pending);
    expect(controller.requestById(id).status, VerificationStatus.underReview);
    expect(controller.requestById(id).decidedAt, isNull);
    expect(controller.requestById(id).document(type)!.reviewedAt, isNull);
    expect(controller.approve(id), isNotNull);
  });

  test(
    'police clearance required only by request policy; filters and totals',
    () {
      final sample = verificationMockRequests().first;
      final request = VerificationRequest(
        id: 'police',
        driverId: 'DEMO',
        driver: 'Demo',
        phone: 'Demo',
        email: 'demo@example.test',
        submittedAt: sample.submittedAt,
        status: VerificationStatus.pending,
        documents: sample.documents,
        policeRequired: true,
      );
      final controller = VerificationController(requests: [request]);
      addTearDown(controller.dispose);
      for (final doc in request.documents) {
        controller.reviewDocument(
          'police',
          doc.type,
          DocumentReviewStatus.approved,
        );
      }
      expect(controller.approve('police'), isNotNull);
      expect(controller.requestById('police').requiredTypes.length, 8);
      final samples = VerificationController();
      addTearDown(samples.dispose);
      for (final status in VerificationStatus.values) {
        expect(samples.count(status), 1);
      }
      samples.search(' SUNIL ');
      expect(samples.visibleRequests.single.driverId, 'DEMO-DRV-001');
      samples.filterStatus(VerificationStatus.pending);
      expect(samples.visibleRequests, isEmpty);
      samples.resetFilters();
      expect(samples.visibleRequests.length, 4);
    },
  );

  Future<void> openVerification(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NovaSysApp());
    if (width < 1000) {
      await tester.tap(find.byTooltip('Open navigation'));
      await tester.pumpAndSettle();
    }
    final nav = find.byKey(const ValueKey('nav-verification'));
    await tester.ensureVisible(nav);
    await tester.tap(nav);
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets(
      'document review, image/PDF previews, notes and rejection at $width',
      (tester) async {
        await openVerification(tester, width);
        await tester.ensureVisible(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'unknown');
        await tester.pumpAndSettle();
        expect(
          find.text('No verification requests match your search or filters.'),
          findsOneWidget,
        );
        await tester.tap(find.byTooltip('Clear search'));
        await tester.pumpAndSettle();
        await tapVisible(
          tester,
          find.byKey(const ValueKey('review-verification-001')),
        );
        expect(find.byType(VerificationReviewPanel), findsOneWidget);
        await tapVisible(
          tester,
          find.byKey(const ValueKey('preview-nicFront')),
        );
        expect(find.byType(DocumentPreview), findsOneWidget);
        await tester.tap(find.byTooltip('Zoom in'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Zoom out'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Close preview'));
        await tester.pumpAndSettle();
        await tapVisible(
          tester,
          find.byKey(const ValueKey('preview-registration')),
        );
        expect(find.text('Page 1 of 2 · PDF placeholder'), findsOneWidget);
        await tester.tap(find.text('Next page'));
        await tester.pumpAndSettle();
        expect(find.text('Page 2 of 2 · PDF placeholder'), findsOneWidget);
        await tester.tap(find.text('Close preview'));
        await tester.pumpAndSettle();
        final note = find.byKey(const ValueKey('note-nicFront'));
        await tester.ensureVisible(note);
        await tester.enterText(note, 'Demo image is unclear');
        await tester.pumpAndSettle();
        await tapVisible(tester, find.byKey(const ValueKey('reject-nicFront')));
        await tapVisible(
          tester,
          find.byKey(const ValueKey('approve-nicFront')),
        );
        await tapVisible(tester, find.byKey(const ValueKey('reject-driver')));
        await tester.tap(find.text('Confirm mock rejection'));
        await tester.pumpAndSettle();
        expect(find.text('A rejection reason is required.'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('driver-rejection-reason')),
          'Demo: clearer submissions needed',
        );
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        await tapVisible(tester, find.byKey(const ValueKey('reject-driver')));
        await tester.enterText(
          find.byKey(const ValueKey('driver-rejection-reason')),
          'Demo: clearer submissions needed',
        );
        await tester.tap(find.text('Confirm mock rejection'));
        await tester.pumpAndSettle();
        await tapVisible(tester, find.text('Back to verification requests'));
        await tapVisible(
          tester,
          find.byKey(const ValueKey('review-verification-001')),
        );
        expect(
          find.text(
            'Driver rejection reason: Demo: clearer submissions needed',
          ),
          findsOneWidget,
        );
        await tester.ensureVisible(note);
        expect(
          tester.widget<TextField>(note).controller!.text,
          'Demo image is unclear',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('approve all documents then confirm overall driver approval', (
    tester,
  ) async {
    await openVerification(tester, 1440);
    await tapVisible(
      tester,
      find.byKey(const ValueKey('review-verification-001')),
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('approve-driver')))
          .onPressed,
      isNull,
    );
    for (final type in VerificationDocumentType.values.where(
      (type) => type != VerificationDocumentType.police,
    )) {
      await tapVisible(tester, find.byKey(ValueKey('approve-${type.name}')));
    }
    await tapVisible(tester, find.byKey(const ValueKey('approve-driver')));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const ValueKey('approve-driver')));
    await tester.tap(find.text('Confirm mock approval'));
    await tester.pumpAndSettle();
    expect(
      find.text('Mock driver approval saved for this session.'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Back to verification requests'));
    for (final entry in {
      'overview': 'Operations overview',
      'trips': 'View details',
      'attendance': 'Aanya Perera',
      'emergency': 'No emergency alerts',
      'parents': 'Nethmi Perera',
      'students': 'Dineth Silva',
      'drivers': 'Review application',
    }.entries) {
      await tapVisible(tester, find.byKey(ValueKey('nav-${entry.key}')));
      expect(find.text(entry.value), findsOneWidget);
    }
    await tapVisible(tester, find.byKey(const ValueKey('nav-verification')));
    await tapVisible(
      tester,
      find.byKey(const ValueKey('review-verification-001')),
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('approve-driver')))
          .onPressed,
      isNull,
    );
    expect(find.textContaining('Mock outcome: Approved'), findsOneWidget);
  });
}
