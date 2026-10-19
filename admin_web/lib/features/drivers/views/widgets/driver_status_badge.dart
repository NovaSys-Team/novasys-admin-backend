import 'package:flutter/material.dart';

import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/driver_record.dart';

class DriverStatusBadge extends StatelessWidget {
  const DriverStatusBadge(this.status, {super.key});
  final DriverStatus status;
  @override
  Widget build(BuildContext context) => StatusBadge(
    status.label,
    tone: status == DriverStatus.verified ? BadgeTone.green : BadgeTone.amber,
  );
}
