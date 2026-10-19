import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/trips_controller.dart';
import '../models/trip.dart';
import 'widgets/trip_status_badge.dart';
import 'widgets/trips_table.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key, required this.controller});
  final TripsController controller;
  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  late final _search = TextEditingController(text: widget.controller.query);
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
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
                'Trips',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 14),
              const Text(
                'Monitor each school run and its attendance checkpoints.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: RecordSearchField(
                    controller: _search,
                    onChanged: widget.controller.search,
                  ),
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final trips = widget.controller.visibleTrips;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TripsTable(trips: trips, onDetails: _showDetails),
                        if (trips.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            child: Column(
                              children: [
                                const Text(
                                  'No trips match your search.',
                                  style: TextStyle(color: AdminColors.muted),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    _search.clear();
                                    widget.controller.search('');
                                  },
                                  child: const Text('Clear search'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  void _showDetails(Trip trip) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('${trip.name} trip'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '19 October 2026 · Sample school run',
                style: TextStyle(fontSize: 12, color: AdminColors.muted),
              ),
              const SizedBox(height: 20),
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TripStatusBadge(trip.status),
              const SizedBox(height: 24),
              const Text(
                'Attendance checkpoints',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (final (index, attendance) in trip.attendance.indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Student ${index + 1}: ${attendance.label}'),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
