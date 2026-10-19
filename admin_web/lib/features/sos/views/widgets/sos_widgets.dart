import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/sos_alert.dart';

class SosStatusBadge extends StatelessWidget {
  const SosStatusBadge(this.status, {super.key});
  final SosStatus status;
  @override
  Widget build(BuildContext context) => StatusBadge(
    status.label,
    tone: switch (status) {
      SosStatus.open => BadgeTone.red,
      SosStatus.acknowledged => BadgeTone.amber,
      SosStatus.resolved => BadgeTone.green,
    },
  );
}

class SosSummaryCards extends StatelessWidget {
  const SosSummaryCards({super.key, required this.alerts});
  final List<SosAlert> alerts;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 4
          : constraints.maxWidth >= 450
          ? 2
          : 1;
      final counts = {
        'Total demo alerts': alerts.length,
        for (final status in SosStatus.values)
          status.label: alerts.where((alert) => alert.status == status).length,
      };
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final entry in counts.entries)
            SizedBox(
              width: (constraints.maxWidth - (columns - 1) * 16) / columns,
              child: AdminPanel(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AdminColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      entry.value.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Demo data · all records',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

class SosAlertCard extends StatelessWidget {
  const SosAlertCard({super.key, required this.alert, required this.onDetails});
  final SosAlert alert;
  final VoidCallback onDetails;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AdminColors.border)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${alert.id} · ${alert.timeLabel}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            StatusBadge(
              alert.priority.label,
              tone: alert.priority == SosPriority.critical
                  ? BadgeTone.red
                  : BadgeTone.amber,
            ),
            SosStatusBadge(alert.status),
          ],
        ),
        const SizedBox(height: 12),
        Text(alert.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          '${alert.driver} · ${alert.vehicle}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(alert.route, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        ActionLink('View demo details', onPressed: onDetails),
      ],
    ),
  );
}
