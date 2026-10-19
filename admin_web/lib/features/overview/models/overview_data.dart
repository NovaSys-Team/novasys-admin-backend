import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_widgets.dart';
import '../../shell/models/admin_destination.dart';

class OverviewStatistic {
  const OverviewStatistic(
    this.label,
    this.value,
    this.caption,
    this.icon,
    this.destination,
  );
  final String label;
  final int value;
  final String caption;
  final IconData icon;
  final AdminDestination destination;
}

class AttentionItem {
  const AttentionItem(
    this.title,
    this.description,
    this.badge,
    this.tone,
    this.destination,
  );
  final String title;
  final String description;
  final String badge;
  final BadgeTone tone;
  final AdminDestination destination;
}

class Journey {
  const Journey({
    required this.route,
    required this.service,
    required this.driver,
    required this.plate,
    required this.status,
  });
  final String route;
  final String service;
  final String driver;
  final String plate;
  final String status;
}

class FinanceSnapshot {
  const FinanceSnapshot({required this.invoiced, required this.collected});
  final int invoiced;
  final int collected;
  int get outstanding => invoiced - collected;
  double get collectionRate => invoiced == 0 ? 0 : collected / invoiced;
}

class ActivityItem {
  const ActivityItem(this.title, this.description);
  final String title;
  final String description;
}
