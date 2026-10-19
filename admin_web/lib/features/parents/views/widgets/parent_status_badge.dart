import 'package:flutter/material.dart';

import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/parent_record.dart';

class ParentStatusBadge extends StatelessWidget {
  const ParentStatusBadge(this.status, {super.key});
  final ParentStatus status;
  @override
  Widget build(BuildContext context) => StatusBadge(
    status.label,
    tone: status == ParentStatus.active ? BadgeTone.green : BadgeTone.amber,
  );
}
