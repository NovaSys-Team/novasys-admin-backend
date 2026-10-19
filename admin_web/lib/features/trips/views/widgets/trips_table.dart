import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/trip.dart';
import 'trip_status_badge.dart';

class TripsTable extends StatefulWidget {
  const TripsTable({super.key, required this.trips, required this.onDetails});
  final List<Trip> trips;
  final ValueChanged<Trip> onDetails;
  @override
  State<TripsTable> createState() => _TripsTableState();
}

class _TripsTableState extends State<TripsTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 900;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        notificationPredicate: (notification) =>
            notification.metrics.axis == Axis.horizontal,
        child: SingleChildScrollView(
          key: const ValueKey('trips-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 900 : constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(167.88),
                    1: FlexColumnWidth(203.28),
                    2: FlexColumnWidth(432.69),
                    3: FlexColumnWidth(260.16),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                      children: [
                        for (final title in [
                          'Trip',
                          'Status',
                          'Attendance',
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
                    for (final trip in widget.trips)
                      TableRow(
                        key: ValueKey(trip.id),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AdminColors.border),
                          ),
                        ),
                        children: [
                          _cell(
                            Text(
                              trip.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          _cell(TripStatusBadge(trip.status)),
                          _cell(
                            Text(
                              trip.attendanceLabel,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton(
                                onPressed: () => widget.onDetails(trip),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AdminColors.ink,
                                  side: const BorderSide(
                                    color: AdminColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(fontSize: 11),
                                ),
                                child: const Text('View details'),
                              ),
                            ),
                          ),
                        ],
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    child: child,
  );
}
