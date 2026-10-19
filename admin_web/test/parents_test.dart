import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/core/theme/admin_theme.dart';
import 'package:novasys_admin/features/parents/controllers/parents_controller.dart';
import 'package:novasys_admin/features/parents/models/parent_record.dart';
import 'package:novasys_admin/features/parents/views/parents_view.dart';
import 'package:novasys_admin/features/parents/views/widgets/parent_profile_dialog.dart';

void main() {
  test(
    'parent search matches name, email and child, with combined filters',
    () {
      final sample = ParentsController();
      final controller = ParentsController(
        parents: [
          sample.visibleParents.single,
          ParentRecord(
            id: 'no-child',
            name: 'Demo Parent',
            email: 'demo@example.test',
            status: ParentStatus.inactive,
            children: [],
          ),
        ],
      );
      addTearDown(sample.dispose);
      addTearDown(controller.dispose);
      for (final query in [
        ' NETHMI ',
        'nethmi@example.test',
        'Aanya',
        'royal college',
      ]) {
        controller.search(query);
        expect(controller.visibleParents.single.id, 'parent-001');
      }
      controller.filterStatus(ParentStatus.inactive);
      expect(controller.visibleParents, isEmpty);
      controller.search('');
      expect(controller.visibleParents.single.id, 'no-child');
      controller.filterChildren(ParentChildrenFilter.withChildren);
      expect(controller.visibleParents, isEmpty);
      controller.filterChildren(ParentChildrenFilter.withoutChildren);
      expect(controller.visibleParents.single.id, 'no-child');
      controller.resetFilters();
      expect(controller.visibleParents.length, 2);
      expect(controller.hasFilters, isFalse);
    },
  );

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Parents search, filters and profile at $width', (
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
      final nav = find.byKey(const ValueKey('nav-parents'));
      await tester.ensureVisible(nav);
      await tester.tap(nav);
      await tester.pumpAndSettle();
      expect(find.byType(ParentsView), findsOneWidget);
      expect(find.text('Nethmi Perera'), findsOneWidget);
      expect(find.text('nethmi@example.test'), findsOneWidget);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'unknown');
      await tester.pumpAndSettle();
      expect(
        find.text('No parents match your search or filters.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      final status = find.byType(DropdownButton<ParentStatus>);
      await tester.ensureVisible(status);
      await tester.tap(status);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inactive').last);
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsNothing);
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      final children = find.byType(DropdownButton<ParentChildrenFilter>);
      await tester.ensureVisible(children);
      await tester.tap(children);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Without children').last);
      await tester.pumpAndSettle();
      expect(find.text('View details'), findsNothing);
      await tester.ensureVisible(find.text('Show all parents'));
      await tester.tap(find.text('Show all parents'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('parents-table-scroll')),
      );
      if (width < 1440) {
        await tester.drag(
          find.byKey(const ValueKey('parents-table-scroll')),
          const Offset(-900, 0),
        );
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();
      expect(find.text('Parent profile'), findsOneWidget);
      expect(find.text('Aanya Perera'), findsOneWidget);
      expect(find.text('Royal College · Grade 4'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(ParentProfileDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('profile handles an inactive parent without children', (
    tester,
  ) async {
    final parent = ParentRecord(
      id: 'empty',
      name: 'Demo Parent',
      email: 'demo@example.test',
      status: ParentStatus.inactive,
      children: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AdminTheme.light,
        home: Scaffold(body: ParentProfileDialog(parent: parent)),
      ),
    );
    expect(find.text('Inactive'), findsOneWidget);
    expect(find.text('Linked children (0)'), findsOneWidget);
    expect(find.text('No linked children.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Parents query persists while existing destinations remain available',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      await tester.tap(find.byKey(const ValueKey('nav-parents')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'nethmi');
      for (final entry in {
        'overview': 'Operations overview',
        'trips': 'View details',
        'attendance': 'Aanya Perera',
        'emergency': 'No emergency alerts',
      }.entries) {
        await tester.tap(find.byKey(ValueKey('nav-${entry.key}')));
        await tester.pumpAndSettle();
        expect(find.text(entry.value), findsOneWidget);
      }
      await tester.tap(find.byKey(const ValueKey('nav-parents')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'nethmi',
      );
      expect(find.text('Nethmi Perera'), findsOneWidget);
    },
  );
}
