import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../controllers/verification_controller.dart';
import '../../models/verification_request.dart';
import 'document_review_card.dart';
import 'verification_status_badge.dart';

class VerificationReviewPanel extends StatelessWidget {
  const VerificationReviewPanel({
    super.key,
    required this.controller,
    required this.requestId,
  });
  final VerificationController controller;
  final String requestId;
  @override
  Widget build(BuildContext context) {
    final request = controller.requestById(requestId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: controller.closeRequest,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to verification requests'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Review submitted documents',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Demo only · Placeholders and local review decisions. No real verification or trip access changes.',
          style: TextStyle(fontSize: 12, color: AdminColors.teal),
        ),
        const SizedBox(height: 24),
        AdminPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AdminColors.banner,
                child: Icon(
                  Icons.person_outline,
                  size: 32,
                  color: AdminColors.teal,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Photo placeholder',
                style: TextStyle(fontSize: 9, color: AdminColors.muted),
              ),
              const SizedBox(height: 16),
              Text(
                request.driver,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              VerificationStatusBadge(request),
              const SizedBox(height: 16),
              Text(
                'Driver ID: ${request.driverId}\nContact: ${request.phone}\nEmail: ${request.email}\nVehicle: ${request.vehicle ?? 'Not supplied'}\nSubmitted: ${verificationDate(request.submittedAt)}',
                style: const TextStyle(fontSize: 12, height: 1.8),
              ),
              if (request.decidedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Mock outcome: ${request.status.label} · ${verificationDate(request.decidedAt)} · Administrator · demo',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.teal,
                    ),
                  ),
                ),
              if (request.rejectionReason.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Driver rejection reason: ${request.rejectionReason}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AdminColors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AdminPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Required document review progress',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '${request.count(DocumentReviewStatus.approved)} approved · ${request.pendingCount} pending (including ${request.missingCount} missing) · ${request.count(DocumentReviewStatus.rejected)} rejected',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: request.progress,
                minHeight: 8,
                color: AdminColors.teal,
                backgroundColor: AdminColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 12),
              Text(
                '${request.count(DocumentReviewStatus.approved)} of ${request.requiredTypes.length} required documents approved. Re-reviewing a document reopens the overall request.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900 ? 2 : 1;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                for (final type in VerificationDocumentType.values)
                  SizedBox(
                    width:
                        (constraints.maxWidth - (columns - 1) * 20) / columns,
                    child: DocumentReviewCard(
                      key: ValueKey('$requestId-${type.name}'),
                      controller: controller,
                      requestId: requestId,
                      type: type,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        AdminPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall driver verification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (!request.canApprove &&
                  request.status != VerificationStatus.approved)
                const Text(
                  'Approve all required documents before approving this driver.',
                  style: TextStyle(fontSize: 12, color: AdminColors.muted),
                ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    key: const ValueKey('approve-driver'),
                    onPressed: request.canApprove
                        ? () => _confirm(context, approve: true)
                        : null,
                    child: const Text('Approve Driver'),
                  ),
                  OutlinedButton(
                    key: const ValueKey('reject-driver'),
                    onPressed: request.status == VerificationStatus.approved
                        ? null
                        : () => _confirm(context, approve: false),
                    child: const Text('Reject Driver'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirm(BuildContext context, {required bool approve}) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _DecisionConfirmation(approve: approve),
    );
    if (reason == null || !context.mounted) return;
    final error = approve
        ? controller.approve(requestId)
        : controller.reject(requestId, reason);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ??
              'Mock driver ${approve ? 'approval' : 'rejection'} saved for this session.',
        ),
      ),
    );
  }
}

class _DecisionConfirmation extends StatefulWidget {
  const _DecisionConfirmation({required this.approve});
  final bool approve;
  @override
  State<_DecisionConfirmation> createState() => _DecisionConfirmationState();
}

class _DecisionConfirmationState extends State<_DecisionConfirmation> {
  final _reason = TextEditingController();
  String? _error;
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.approve ? 'Approve Driver · demo?' : 'Reject Driver · demo?',
    ),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This records a local mock decision only. It does not verify identity, grant access or notify the driver.',
            ),
            if (!widget.approve) ...[
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('driver-rejection-reason'),
                controller: _reason,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Rejection reason (required)',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          if (!widget.approve && _reason.text.trim().isEmpty) {
            setState(() => _error = 'A rejection reason is required.');
            return;
          }
          Navigator.pop(context, widget.approve ? '' : _reason.text.trim());
        },
        child: Text(
          widget.approve ? 'Confirm mock approval' : 'Confirm mock rejection',
        ),
      ),
    ],
  );
}
