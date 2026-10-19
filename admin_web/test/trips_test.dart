import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/trips/controllers/trips_controller.dart';
import 'package:novasys_admin/features/trips/models/trip.dart';
import 'package:novasys_admin/features/trips/views/trips_view.dart';

void main() {
  test('search is case-insensitive, trimmed and covers visible columns', () {
    final controller = TripsController(
      trips: [
        Trip(
          id: 'am',
          name: 'Morning',
          status: TripStatus.notStarted,
          attendance: [TripAttendance.expected, TripAttendance.absent],
        ),
        Trip(
          id: 'pm',
          name: 'Afternoon',
          status: TripStatus.completed,
          attendance: [TripAttendance.droppedOff],
        ),
      ],
    );
    addTearDown(controller.dispose);
    for (final query in [' MORNING ', 'not STARTED', 'Absent']) {
      controller.search(query);
      expect(controller.visibleTrips.single.id, 'am');
    }
    controller.search('completed');
    expect(controller.visibleTrips.single.id, 'pm');
    controller.search('unknown');
    expect(controller.visibleTrips, isEmpty);
    controller.search('');
    expect(controller.visibleTrips.length, 2);
  });

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Trips search, details and responsive table at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      if (width < 1000) {
        await tester.tap(find.byTooltip('Open navigation'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(const ValueKey('nav-trips')));
      await tester.pumpAndSettle();
      expect(find.byType(TripsView), findsOneWidget);
      expect(find.text('Expected / Expected / Absent'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'no match');
      await tester.pumpAndSettle();
      expect(find.text('No trips match your search.'), findsOneWidget);
      expect(find.text('View details'), findsNothing);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsOneWidget);
      await tester.enterText(find.byType(TextField), ' ABSENT ');
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsOneWidget);
      if (width < 1440) {
        await tester.drag(
          find.byKey(const ValueKey('trips-table-scroll')),
          const Offset(-900, 0),
        );
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();
      expect(find.text('Morning trip'), findsOneWidget);
      expect(find.text('Student 3: Absent'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Trips query persists across sidebar navigation', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NovaSysApp());
    await tester.tap(find.byKey(const ValueKey('nav-trips')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'unmatched');
    await tester.tap(find.byKey(const ValueKey('nav-overview')));
    await tester.pumpAndSettle();
    expect(find.text('Operations overview'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('nav-trips')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'unmatched',
    );
    expect(find.text('No trips match your search.'), findsOneWidget);
  });
}
