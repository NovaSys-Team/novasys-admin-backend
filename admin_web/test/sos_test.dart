import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/sos/controllers/sos_controller.dart';
import 'package:novasys_admin/features/sos/models/sos_alert.dart';
import 'package:novasys_admin/features/sos/views/sos_view.dart';
import 'package:novasys_admin/features/sos/views/widgets/sos_widgets.dart';

void main() {
  test('empty by default; demo filters combine and reset', () {
    final controller = SosController();
    addTearDown(controller.dispose);
    expect(controller.alerts, isEmpty);
    controller.advanceStatus('DEMO-SOS-001');
    expect(controller.alertById('DEMO-SOS-001').status, SosStatus.open);
    controller.setShowDemo(true);
    expect(controller.alerts.length, 3);
    expect(controller.count(SosStatus.open), 1);
    controller.search(' PERERA ');
    expect(controller.visibleAlerts.single.id, 'DEMO-SOS-001');
    controller.filterStatus(SosStatus.resolved);
    expect(controller.visibleAlerts, isEmpty);
    controller.resetFilters();
    controller.filterPriority(SosPriority.high);
    expect(controller.visibleAlerts.single.id, 'DEMO-SOS-002');
    controller.search('vehicle');
    expect(controller.visibleAlerts.length, 1);
    controller.filterStatus(SosStatus.open);
    expect(controller.visibleAlerts, isEmpty);
    controller.resetFilters();
    expect(controller.visibleAlerts.length, 3);
    controller.setShowDemo(false);
    expect(controller.visibleAlerts, isEmpty);
  });

  test(
    'local transitions update totals and filtered records without reopening',
    () {
      final controller = SosController()..setShowDemo(true);
      addTearDown(controller.dispose);
      controller.filterStatus(SosStatus.open);
      controller.advanceStatus('DEMO-SOS-001');
      expect(controller.visibleAlerts, isEmpty);
      expect(controller.count(SosStatus.open), 0);
      expect(controller.count(SosStatus.acknowledged), 2);
      controller.advanceStatus('DEMO-SOS-001');
      expect(controller.alertById('DEMO-SOS-001').status, SosStatus.resolved);
      controller.advanceStatus('DEMO-SOS-001');
      controller.advanceStatus('unknown');
      expect(controller.count(SosStatus.resolved), 2);
    },
  );

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('SOS empty state, demo search, filters and details at $width', (
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
      await tester.tap(find.byKey(const ValueKey('nav-emergency')));
      await tester.pumpAndSettle();
      expect(find.byType(SosView), findsOneWidget);
      expect(find.text('No emergency alerts'), findsOneWidget);
      expect(find.byType(SosAlertCard), findsNothing);
      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.byType(SosAlertCard), findsNWidgets(3));
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'unknown');
      await tester.pumpAndSettle();
      expect(
        find.text('No demo alerts match your search or filters.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      final priority = find.byType(DropdownButton<SosPriority>);
      await tester.ensureVisible(priority);
      await tester.tap(priority);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Critical').last);
      await tester.pumpAndSettle();
      expect(find.byType(SosAlertCard), findsOneWidget);
      final status = find.byType(DropdownButton<SosStatus>);
      await tester.ensureVisible(status);
      await tester.tap(status);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Resolved').last);
      await tester.pumpAndSettle();
      expect(find.byType(SosAlertCard), findsNothing);
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('View demo details').first);
      await tester.tap(find.text('View demo details').first);
      await tester.pumpAndSettle();
      expect(find.text('Demo alert details'), findsOneWidget);
      await tester.tap(find.text('Acknowledge demo'));
      await tester.pumpAndSettle();
      expect(find.text('Resolve demo'), findsOneWidget);
      await tester.tap(find.text('Resolve demo'));
      await tester.pumpAndSettle();
      expect(find.text('Resolve demo'), findsNothing);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.text('No emergency alerts'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('SOS state persists alongside existing pages', (tester) async {
    tester.view.physicalSize = const Size(1440, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NovaSysApp());
    await tester.tap(find.byKey(const ValueKey('nav-emergency')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Sunil');
    for (final entry in {
      'overview': 'Operations overview',
      'trips': 'View details',
      'attendance': 'Aanya Perera',
    }.entries) {
      await tester.tap(find.byKey(ValueKey('nav-${entry.key}')));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
    }
    await tester.tap(find.byKey(const ValueKey('nav-emergency')));
    await tester.pumpAndSettle();
    expect(find.byType(SosAlertCard), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Sunil',
    );
  });
}
