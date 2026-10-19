import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/attendance/controllers/attendance_controller.dart';
import 'package:novasys_admin/features/attendance/models/attendance_record.dart';
import 'package:novasys_admin/features/attendance/views/attendance_view.dart';
import 'package:novasys_admin/features/attendance/views/widgets/attendance_widgets.dart';

void main() {
  test('search and filters combine, reset and retain whole-day totals', () {
    final controller = AttendanceController();
    addTearDown(controller.dispose);
    expect(controller.summary.total, 3);
    expect(controller.summary.expected, 2);
    expect(controller.summary.confirmed, 0);
    expect(controller.summary.absent, 1);
    controller.search(' PERERA ');
    expect(controller.visibleRecords.single.student, 'Aanya Perera');
    controller.filterStatus(AttendanceStatus.absent);
    expect(controller.visibleRecords, isEmpty);
    controller.search('');
    expect(controller.visibleRecords.single.student, 'Sethum Jayasinghe');
    controller.filterRun(SchoolRun.afternoon);
    expect(controller.visibleRecords, isEmpty);
    expect(controller.summary.total, 3);
    controller.reset();
    expect(controller.visibleRecords.length, 3);
    expect(controller.query, isEmpty);
    expect(controller.status, isNull);
    expect(controller.run, isNull);
    expect(controller.hasFilters, isFalse);
  });

  test('confirmed totals use explicit boarded and dropped-off states', () {
    final controller = AttendanceController(
      records: const [
        AttendanceRecord(
          id: '1',
          student: 'First',
          run: SchoolRun.morning,
          status: AttendanceStatus.boarded,
        ),
        AttendanceRecord(
          id: '2',
          student: 'Second',
          run: SchoolRun.afternoon,
          status: AttendanceStatus.droppedOff,
        ),
      ],
    );
    addTearDown(controller.dispose);
    expect(controller.summary.confirmed, 2);
    controller.search('dropped');
    expect(controller.visibleRecords.single.id, '2');
    controller.reset();
    controller.search('afternoon');
    expect(controller.visibleRecords.single.id, '2');
  });

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Attendance navigation, search and filters at $width', (
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
      await tester.tap(find.byKey(const ValueKey('nav-attendance')));
      await tester.pumpAndSettle();
      expect(find.byType(AttendanceView), findsOneWidget);
      expect(find.byType(AttendanceStatusBadge), findsNWidgets(3));
      expect(find.text('Aanya Perera'), findsOneWidget);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'unknown');
      await tester.pumpAndSettle();
      expect(
        find.text('No attendance records match your search or filters.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      final statusFilter = find.byType(DropdownButton<AttendanceStatus>);
      await tester.ensureVisible(statusFilter);
      await tester.tap(statusFilter);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Absent').last);
      await tester.pumpAndSettle();
      expect(find.text('Sethum Jayasinghe'), findsOneWidget);
      expect(find.text('Aanya Perera'), findsNothing);
      final runFilter = find.byType(DropdownButton<SchoolRun>);
      await tester.ensureVisible(runFilter);
      await tester.tap(runFilter);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Afternoon').last);
      await tester.pumpAndSettle();
      expect(
        find.text('No attendance records match your search or filters.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      expect(find.byType(AttendanceStatusBadge), findsNWidgets(3));
      await tester.ensureVisible(
        find.byKey(const ValueKey('attendance-table-scroll')),
      );
      if (width < 1440) {
        await tester.drag(
          find.byKey(const ValueKey('attendance-table-scroll')),
          const Offset(-850, 0),
        );
        await tester.pumpAndSettle();
      }
      expect(find.text('None reported'), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Attendance query survives navigating through Trips and Overview',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      await tester.tap(find.byKey(const ValueKey('nav-attendance')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Dineth');
      await tester.tap(find.byKey(const ValueKey('nav-trips')));
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('nav-overview')));
      await tester.pumpAndSettle();
      expect(find.text('Operations overview'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('nav-attendance')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Dineth',
      );
      expect(find.text('Dineth Silva'), findsOneWidget);
      expect(find.text('Aanya Perera'), findsNothing);
    },
  );
}
