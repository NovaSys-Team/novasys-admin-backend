import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/parents_controller.dart';
import '../models/parent_record.dart';
import 'widgets/parent_profile_dialog.dart';
import 'widgets/parents_table.dart';

class ParentsView extends StatefulWidget {
  const ParentsView({super.key, required this.controller});
  final ParentsController controller;
  @override
  State<ParentsView> createState() => _ParentsViewState();
}

class _ParentsViewState extends State<ParentsView> {
  late final _search = TextEditingController(text: widget.controller.query);
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    widget.controller.resetFilters();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      final parents = controller.visibleParents;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NOVASYS / CONTROL CENTER',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parents',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Manage parents across your school transport network.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AdminColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '19 Oct 2026'),
                      TextSpan(
                        text: '  · Morning',
                        style: TextStyle(color: AdminColors.muted),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AdminPanel(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 332),
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: RecordSearchField(
                            controller: _search,
                            onChanged: controller.search,
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: _filter<ParentStatus>(
                            label: 'Parent status',
                            value: controller.status,
                            values: ParentStatus.values,
                            labelFor: (value) => value.label,
                            onChanged: controller.filterStatus,
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: _filter<ParentChildrenFilter>(
                            label: 'Linked children',
                            value: controller.childrenFilter,
                            values: ParentChildrenFilter.values,
                            labelFor: (value) => value.label,
                            onChanged: controller.filterChildren,
                          ),
                        ),
                        if (controller.hasFilters)
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Reset filters'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ParentsTable(
                      parents: parents,
                      onDetails: (parent) => showDialog<void>(
                        context: context,
                        builder: (context) =>
                            ParentProfileDialog(parent: parent),
                      ),
                    ),
                    if (parents.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            const Text(
                              'No parents match your search or filters.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AdminColors.muted),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _reset,
                              child: const Text('Show all parents'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _filter<T>({
    required String label,
    required T? value,
    required List<T> values,
    required String Function(T) labelFor,
    required ValueChanged<T?> onChanged,
  }) => InputDecorator(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11, color: AdminColors.muted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        isDense: true,
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: AdminColors.ink),
        items: [
          DropdownMenuItem<T>(value: null, child: const Text('All')),
          for (final option in values)
            DropdownMenuItem<T>(value: option, child: Text(labelFor(option))),
        ],
        onChanged: onChanged,
      ),
    ),
  );
}
