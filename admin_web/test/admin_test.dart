import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/overview/controllers/overview_controller.dart';
import 'package:novasys_admin/features/shell/controllers/shell_controller.dart';
import 'package:novasys_admin/features/shell/models/admin_destination.dart';

void main() {
  test('selection only notifies when the destination changes', () {
    final controller = ShellController();
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);
    controller.select(AdminDestination.trips);
    controller.select(AdminDestination.trips);
    expect(controller.selected, AdminDestination.trips);
    expect(notifications, 1);
  });

  test('mock finance and overview counts are consistent', () {
    final controller = OverviewController();
    expect(controller.finance.outstanding, 8000);
    expect(controller.finance.collectionRate, 0);
    expect(controller.currency(controller.finance.outstanding), 'LKR 8,000');
    expect(controller.statistics.map((e) => e.value), [0, 1, 1, 0]);
    expect(AdminDestination.values.length, 22);
  });

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Overview renders without overflow at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      expect(find.text('Operations overview'), findsOneWidget);
      expect(find.text('Every journey. One clear view.'), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView).last,
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'all sidebar destinations open placeholders and Overview returns',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1440);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      for (final destination in AdminDestination.values.skip(1)) {
        final nav = find.byKey(ValueKey('nav-${destination.name}'));
        await tester.ensureVisible(nav);
        await tester.tap(nav);
        await tester.pumpAndSettle();
        expect(
          find.text('${destination.label} is coming soon'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.text('Back to Overview'));
      await tester.pumpAndSettle();
      expect(find.text('Operations overview'), findsOneWidget);
    },
  );

  testWidgets('small screens navigate through a dismissible drawer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NovaSysApp());
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-trips')));
    await tester.pumpAndSettle();
    expect(find.text('Trips is coming soon'), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    await tester.tap(find.text('Back to Overview'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('View school runs'));
    await tester.tap(find.text('View school runs'));
    await tester.pumpAndSettle();
    expect(find.text('Trips is coming soon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
