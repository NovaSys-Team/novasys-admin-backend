import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/driver_record.dart';
import 'driver_status_badge.dart';

class DriversTable extends StatefulWidget {
  const DriversTable({
    super.key,
    required this.drivers,
    required this.onDetails,
  });
  final List<DriverRecord> drivers;
  final ValueChanged<DriverRecord> onDetails;
  @override
  State<DriversTable> createState() => _DriversTableState();
}

class _DriversTableState extends State<DriversTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 1000;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        child: SingleChildScrollView(
          key: const ValueKey('drivers-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 1000 : constraints.maxWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(160.42),
                1: FlexColumnWidth(248.91),
                2: FlexColumnWidth(145.44),
                3: FlexColumnWidth(248.61),
                4: FlexColumnWidth(260.63),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                  children: [
                    for (final title in [
                      'Driver',
                      'Vehicle',
                      'Status',
                      'Documents',
                      'Action',
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.muted,
                          ),
                        ),
                      ),
                  ],
                ),
                for (final driver in widget.drivers)
                  TableRow(
                    key: ValueKey(driver.id),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AdminColors.border),
                      ),
                    ),
                    children: [
                      _cell(
                        Text(driver.name, style: const TextStyle(fontSize: 12)),
                      ),
                      _cell(
                        Text(
                          driver.vehicleLabel,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DriverStatusBadge(driver.status),
                        ),
                      ),
                      _cell(
                        Text(
                          driver.documentsLabel,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton(
                            onPressed: () => widget.onDetails(driver),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AdminColors.ink,
                              side: const BorderSide(color: AdminColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 12,
                              ),
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: Text(
                              driver.status == DriverStatus.verified
                                  ? 'View profile'
                                  : 'Review application',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
  Widget _cell(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    child: child,
  );
}
