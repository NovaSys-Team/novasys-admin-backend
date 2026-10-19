import 'package:flutter/material.dart';

import '../../../../shared/widgets/admin_widgets.dart';
import '../../models/verification_request.dart';

class VerificationStatusBadge extends StatelessWidget {
  const VerificationStatusBadge(this.request, {super.key});
  final VerificationRequest request;
  @override
  Widget build(BuildContext context) => StatusBadge(
    request.status.label,
    tone: switch (request.status) {
      VerificationStatus.approved => BadgeTone.green,
      VerificationStatus.rejected => BadgeTone.red,
      _ => BadgeTone.amber,
    },
  );
}

class DocumentStatusBadge extends StatelessWidget {
  const DocumentStatusBadge(this.status, {super.key});
  final DocumentReviewStatus status;
  @override
  Widget build(BuildContext context) => StatusBadge(
    status.label,
    tone: switch (status) {
      DocumentReviewStatus.approved => BadgeTone.green,
      DocumentReviewStatus.rejected => BadgeTone.red,
      DocumentReviewStatus.pending => BadgeTone.amber,
    },
  );
}
