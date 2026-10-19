import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/trip.dart';

class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge(this.status, {super.key});
  final TripStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    // The reference renders the initial state as a plain text label.
    TripStatus.notStarted => Text(
      status.label,
      style: const TextStyle(fontSize: 12, color: AdminColors.ink),
    ),
    TripStatus.inProgress => StatusBadge(status.label, tone: BadgeTone.amber),
    TripStatus.completed => StatusBadge(status.label),
    TripStatus.cancelled => StatusBadge(status.label, tone: BadgeTone.red),
  };
}
