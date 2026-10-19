import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/drivers/controllers/drivers_controller.dart';
import 'package:novasys_admin/features/drivers/models/driver_record.dart';
import 'package:novasys_admin/features/drivers/views/drivers_view.dart';
import 'package:novasys_admin/features/drivers/views/widgets/driver_profile_dialog.dart';
import 'package:novasys_admin/features/drivers/views/widgets/drivers_table.dart';

void main() {
  test('driver search and filters combine and reset', () {
    final controller = DriversController();
    addTearDown(controller.dispose);
    expect(controller.visibleDrivers.length, 2);
    for (final query in [' SUNIL ', '4821', 'sunil@example.test', 'verified']) {
      controller.search(query);
      expect(controller.visibleDrivers.single.id, 'driver-001');
    }
    controller.filterStatus(DriverStatus.pending);
    expect(controller.visibleDrivers, isEmpty);
    controller.search('');
    expect(controller.visibleDrivers.single.id, 'driver-002');
    controller.filterDocuments(DriverDocumentFilter.complete);
    expect(controller.visibleDrivers, isEmpty);
    controller.filterDocuments(DriverDocumentFilter.incomplete);
    expect(controller.visibleDrivers.single.documents, isEmpty);
    controller.resetFilters();
    expect(controller.hasFilters, isFalse);
    expect(controller.visibleDrivers.length, 2);
    expect(() => controller.visibleDrivers.clear(), throwsUnsupportedError);
  });

  test(
    'document completeness requires each document type, not just a count',
    () {
      final driver = DriverRecord(
        id: 'partial',
        name: 'Demo driver',
        email: 'demo@example.test',
        status: DriverStatus.pending,
        documents: const [
          DriverDocument(
            type: DriverDocumentType.licence,
            status: DriverDocumentStatus.awaitingReview,
          ),
          DriverDocument(
            type: DriverDocumentType.licence,
            status: DriverDocumentStatus.awaitingReview,
          ),
          DriverDocument(
            type: DriverDocumentType.registration,
            status: DriverDocumentStatus.awaitingReview,
          ),
        ],
      );
      expect(driver.hasCompleteDocuments, isFalse);
      expect(driver.vehicleLabel, 'Awaiting registration');
      final controller = DriversController(drivers: [driver]);
      addTearDown(controller.dispose);
      controller.filterDocuments(DriverDocumentFilter.incomplete);
      expect(controller.visibleDrivers.single, driver);
      controller.filterDocuments(DriverDocumentFilter.complete);
      expect(controller.visibleDrivers, isEmpty);
    },
  );

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Drivers search, filters, profile and application at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      if (width < 1000) {
        await tester.tap(find.byTooltip('Open navigation'));
        await tester.pumpAndSettle();
      }
      final nav = find.byKey(const ValueKey('nav-drivers'));
      await tester.ensureVisible(nav);
      await tester.tap(nav);
      await tester.pumpAndSettle();
      expect(find.byType(DriversView), findsOneWidget);
      expect(find.text('Sunil Perera'), findsOneWidget);
      expect(find.text('3 sample documents'), findsOneWidget);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'unknown');
      await tester.pumpAndSettle();
      expect(
        find.text('No drivers match your search or filters.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      final status = find.byType(DropdownButton<DriverStatus>);
      await tester.ensureVisible(status);
      await tester.tap(status);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pending').last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<DriversTable>(find.byType(DriversTable))
            .drivers
            .single
            .name,
        'New driver',
      );
      final documents = find.byType(DropdownButton<DriverDocumentFilter>);
      await tester.ensureVisible(documents);
      await tester.tap(documents);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Complete documents').last);
      await tester.pumpAndSettle();
      expect(
        find.text('No drivers match your search or filters.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('View profile'));
      await tester.tap(find.text('View profile'));
      await tester.pumpAndSettle();
      expect(find.text('Driver profile'), findsOneWidget);
      expect(find.text('sunil@example.test'), findsOneWidget);
      expect(find.text('Reviewed'), findsNWidgets(3));
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Review application'));
      await tester.tap(find.text('Review application'));
      await tester.pumpAndSettle();
      expect(find.text('Driver application'), findsOneWidget);
      expect(find.text('Missing'), findsNWidgets(3));
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(DriverProfileDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Drivers state persists and all prior pages remain available', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NovaSysApp());
    await tester.tap(find.byKey(const ValueKey('nav-drivers')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'sunil');
    for (final entry in {
      'overview': 'Operations overview',
      'trips': 'View details',
      'attendance': 'Aanya Perera',
      'emergency': 'No emergency alerts',
      'parents': 'Nethmi Perera',
      'students': 'Dineth Silva',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('nav-${entry.key}')));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
    }
    await tester.tap(find.byKey(const ValueKey('nav-drivers')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'sunil',
    );
    expect(find.text('Sunil Perera'), findsOneWidget);
    expect(find.text('New driver'), findsNothing);
  });
}
