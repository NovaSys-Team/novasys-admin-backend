import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_widgets.dart';
import '../../shell/models/admin_destination.dart';
import '../models/overview_data.dart';

/// Immutable, deterministic mock data for the Phase 1 administrator preview.
class OverviewController {
  final date = DateTime(2026, 10, 19);
  String get dateLabel => '${date.day} Oct ${date.year}';
  String get operationsLabel =>
      'MONDAY, ${date.day} OCTOBER ${date.year} · MORNING OPERATIONS';
  final statistics = const [
    OverviewStatistic(
      'Active trips',
      0,
      'Current sample run',
      Icons.directions_bus_outlined,
      AdminDestination.trips,
    ),
    OverviewStatistic(
      'Students',
      1,
      'Registered child profiles',
      Icons.school_outlined,
      AdminDestination.students,
    ),
    OverviewStatistic(
      'Pending requests',
      1,
      'Awaiting a driver decision',
      Icons.inbox_outlined,
      AdminDestination.requests,
    ),
    OverviewStatistic(
      'Open incidents',
      0,
      'Requires administrator attention',
      Icons.health_and_safety_outlined,
      AdminDestination.emergency,
    ),
  ];
  final attention = const [
    AttentionItem(
      'No open emergency alerts',
      'Your emergency queue is clear.',
      'Clear',
      BadgeTone.green,
      AdminDestination.emergency,
    ),
    AttentionItem(
      'Driver verification',
      'Review eligibility and document status.',
      'Review',
      BadgeTone.amber,
      AdminDestination.verification,
    ),
    AttentionItem(
      'Transport requests',
      '1 request(s) awaiting a decision.',
      '1',
      BadgeTone.green,
      AdminDestination.requests,
    ),
    AttentionItem(
      'Support inbox',
      '0 message(s) from the community.',
      'Open',
      BadgeTone.red,
      AdminDestination.complaints,
    ),
  ];
  final journey = const Journey(
    route: 'Nugegoda → Royal College',
    service: 'School run · Morning',
    driver: 'Sunil Perera',
    plate: 'WP NC–4821',
    status: 'Scheduled',
  );
  final finance = const FinanceSnapshot(invoiced: 8000, collected: 0);
  final activity = const ActivityItem(
    'Your workspace is ready.',
    'Administrator actions appear here as you explore.',
  );
  String currency(int value) =>
      'LKR ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
}
