import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/driver_record.dart';
import 'driver_status_badge.dart';

class DriverProfileDialog extends StatelessWidget {
  const DriverProfileDialog({super.key, required this.driver});
  final DriverRecord driver;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      driver.status == DriverStatus.verified
          ? 'Driver profile'
          : 'Driver application',
    ),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sample driver record · read-only preview',
              style: TextStyle(fontSize: 11, color: AdminColors.teal),
            ),
            const SizedBox(height: 20),
            Text(driver.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            DriverStatusBadge(driver.status),
            const SizedBox(height: 20),
            Text(driver.email),
            const SizedBox(height: 12),
            Text(driver.vehicleLabel),
            const SizedBox(height: 24),
            Text(
              'Required documents',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sample metadata only. No document files are attached.',
              style: TextStyle(fontSize: 11, color: AdminColors.muted),
            ),
            const SizedBox(height: 16),
            for (final type in DriverDocumentType.values) _documentRow(type),
            if (driver.status == DriverStatus.pending) ...[
              const SizedBox(height: 16),
              const Text(
                'This application remains pending until licence, registration and insurance are reviewed.',
                style: TextStyle(fontSize: 12, color: AdminColors.muted),
              ),
            ],
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
  );

  Widget _documentRow(DriverDocumentType type) {
    final matches = driver.documents.where((document) => document.type == type);
    final document = matches.isEmpty ? null : matches.first;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(type.label, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: StatusBadge(
              document?.status.label ?? 'Missing',
              tone: document?.status == DriverDocumentStatus.reviewed
                  ? BadgeTone.green
                  : BadgeTone.amber,
            ),
          ),
        ],
      ),
    );
  }
}
