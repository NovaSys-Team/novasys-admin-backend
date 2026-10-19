import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novasys_admin/main.dart';
import 'package:novasys_admin/features/students/controllers/students_controller.dart';
import 'package:novasys_admin/features/students/models/student_record.dart';
import 'package:novasys_admin/features/students/views/students_view.dart';
import 'package:novasys_admin/features/students/views/widgets/students_table.dart';
import 'package:novasys_admin/features/students/views/widgets/student_profile_dialog.dart';

void main() {
  test('search, combined filters, reset and whole-dataset summaries', () {
    final controller = StudentsController();
    addTearDown(controller.dispose);
    expect(controller.summary.total, 3);
    expect(controller.summary.active, 2);
    expect(controller.summary.pending, 1);
    expect(controller.summary.schools, 2);
    for (final query in [' AANYA ', 'temple road', 'nethmi@example.test']) {
      controller.search(query);
      expect(controller.visibleStudents.single.id, 'student-001');
    }
    controller.filterSchool('Ananda College');
    expect(controller.visibleStudents, isEmpty);
    controller.search('');
    controller.filterStatus(StudentStatus.pending);
    controller.filterGrade(10);
    expect(controller.visibleStudents.single.name, 'Sethum Jayasinghe');
    controller.filterGrade(4);
    expect(controller.visibleStudents, isEmpty);
    expect(controller.summary.total, 3);
    controller.resetFilters();
    expect(controller.visibleStudents.length, 3);
    expect(controller.hasFilters, isFalse);
  });

  test(
    'sorting uses numeric grades, stable ties, and does not mutate source',
    () {
      final controller = StudentsController();
      addTearDown(controller.dispose);
      controller.sortBy(StudentSortField.grade);
      expect(controller.visibleStudents.map((s) => s.grade), [4, 6, 10]);
      controller.sortBy(StudentSortField.grade);
      expect(controller.visibleStudents.map((s) => s.grade), [10, 6, 4]);
      controller.sortBy(StudentSortField.school);
      expect(controller.visibleStudents.map((s) => s.id), [
        'student-003',
        'student-001',
        'student-002',
      ]);
      controller.sortBy(StudentSortField.pickup);
      expect(controller.visibleStudents.first.name, 'Dineth Silva');
      controller.sortBy(StudentSortField.name);
      expect(controller.visibleStudents.first.name, 'Aanya Perera');
      controller.search('royal');
      expect(controller.visibleStudents.map((s) => s.name), [
        'Aanya Perera',
        'Dineth Silva',
      ]);
      controller.resetFilters();
      expect(controller.visibleStudents.length, 3);
      expect(() => controller.visibleStudents.clear(), throwsUnsupportedError);
    },
  );

  test('empty input has zero totals and empty filter options', () {
    final controller = StudentsController(students: []);
    addTearDown(controller.dispose);
    expect(controller.summary.total, 0);
    expect(controller.schools, isEmpty);
    expect(controller.grades, isEmpty);
    controller.sortBy(StudentSortField.grade);
    expect(controller.visibleStudents, isEmpty);
  });

  for (final width in [1440.0, 1024.0, 768.0, 390.0]) {
    testWidgets('Students filters, sorting and profile at $width', (
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
      final nav = find.byKey(const ValueKey('nav-students'));
      await tester.ensureVisible(nav);
      await tester.tap(nav);
      await tester.pumpAndSettle();
      expect(find.byType(StudentsView), findsOneWidget);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'unknown');
      await tester.pumpAndSettle();
      expect(
        find.text('No students match your search or filters.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      final school = find.byType(DropdownButton<String>);
      await tester.ensureVisible(school);
      await tester.tap(school);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Royal College').last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<StudentsTable>(find.byType(StudentsTable))
            .students
            .length,
        2,
      );
      final grade = find.byType(DropdownButton<int>);
      await tester.ensureVisible(grade);
      await tester.tap(grade);
      await tester.pumpAndSettle();
      await tester.tap(find.text('4').last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<StudentsTable>(find.byType(StudentsTable))
            .students
            .single
            .name,
        'Aanya Perera',
      );
      final status = find.byType(DropdownButton<StudentStatus>);
      await tester.ensureVisible(status);
      await tester.tap(status);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pending').last);
      await tester.pumpAndSettle();
      expect(
        find.text('No students match your search or filters.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      final sortGrade = find.byKey(const ValueKey('sort-grade'));
      await tester.ensureVisible(sortGrade);
      await tester.tap(sortGrade);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<StudentsTable>(find.byType(StudentsTable))
            .students
            .map((s) => s.grade),
        [4, 6, 10],
      );
      await tester.tap(sortGrade);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<StudentsTable>(find.byType(StudentsTable))
            .students
            .map((s) => s.grade),
        [10, 6, 4],
      );
      final profile = find.byKey(const ValueKey('student-profile-student-001'));
      await tester.ensureVisible(profile);
      await tester.tap(profile);
      await tester.pumpAndSettle();
      expect(find.text('Student profile'), findsOneWidget);
      expect(find.text('Nethmi Perera'), findsOneWidget);
      expect(find.text('nethmi@example.test'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(StudentProfileDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Students state persists and existing features remain available',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const NovaSysApp());
      await tester.tap(find.byKey(const ValueKey('nav-students')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'aanya');
      await tester.tap(find.byKey(const ValueKey('sort-name')));
      await tester.pumpAndSettle();
      for (final entry in {
        'overview': 'Operations overview',
        'trips': 'View details',
        'attendance': 'Aanya Perera',
        'emergency': 'No emergency alerts',
        'parents': 'Nethmi Perera',
      }.entries) {
        await tester.tap(find.byKey(ValueKey('nav-${entry.key}')));
        await tester.pumpAndSettle();
        expect(find.text(entry.value), findsOneWidget);
      }
      await tester.tap(find.byKey(const ValueKey('nav-students')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'aanya',
      );
      expect(
        tester.widget<StudentsTable>(find.byType(StudentsTable)).ascending,
        isFalse,
      );
      expect(find.text('Aanya Perera'), findsOneWidget);
    },
  );
}
