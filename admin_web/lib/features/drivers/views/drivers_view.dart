import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/drivers_controller.dart';
import '../models/driver_record.dart';
import 'widgets/driver_profile_dialog.dart';
import 'widgets/drivers_table.dart';

class DriversView extends StatefulWidget {
  const DriversView({super.key, required this.controller});
  final DriversController controller;
  @override
  State<DriversView> createState() => _DriversViewState();
}

class _DriversViewState extends State<DriversView> {
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
      final drivers = controller.visibleDrivers;
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
                    'Drivers',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Manage drivers across your school transport network.',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF4F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'New drivers stay pending until licence, registration and insurance are reviewed.',
                      style: TextStyle(fontSize: 12, color: AdminColors.teal),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        child: _filter<DriverStatus>(
                          label: 'Driver status',
                          value: controller.status,
                          values: DriverStatus.values,
                          labelFor: (v) => v.label,
                          onChanged: controller.filterStatus,
                        ),
                      ),
                      SizedBox(
                        width: 210,
                        child: _filter<DriverDocumentFilter>(
                          label: 'Documents',
                          value: controller.documentFilter,
                          values: DriverDocumentFilter.values,
                          labelFor: (v) => v.label,
                          onChanged: controller.filterDocuments,
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
                  DriversTable(
                    drivers: drivers,
                    onDetails: (driver) => showDialog<void>(
                      context: context,
                      builder: (context) => DriverProfileDialog(driver: driver),
                    ),
                  ),
                  if (drivers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          const Text(
                            'No drivers match your search or filters.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AdminColors.muted),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Show all drivers'),
                          ),
                        ],
                      ),
                    ),
                ],
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
