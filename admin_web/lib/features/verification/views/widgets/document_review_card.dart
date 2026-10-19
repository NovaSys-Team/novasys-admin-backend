import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../../../shared/widgets/admin_widgets.dart';
import '../../controllers/verification_controller.dart';
import '../../models/verification_request.dart';
import 'document_preview.dart';
import 'verification_status_badge.dart';

class DocumentReviewCard extends StatefulWidget {
  const DocumentReviewCard({
    super.key,
    required this.controller,
    required this.requestId,
    required this.type,
  });
  final VerificationController controller;
  final String requestId;
  final VerificationDocumentType type;
  @override
  State<DocumentReviewCard> createState() => _DocumentReviewCardState();
}

class _DocumentReviewCardState extends State<DocumentReviewCard> {
  late final _note = TextEditingController(
    text:
        widget.controller
            .requestById(widget.requestId)
            .document(widget.type)
            ?.note ??
        '',
  );
  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _decide(DocumentReviewStatus status) {
    final error = widget.controller.reviewDocument(
      widget.requestId,
      widget.type,
      status,
    );
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Document marked ${status.label.toLowerCase()} · demo only.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.controller.requestById(widget.requestId);
    final document = request.document(widget.type);
    final required = request.requiredTypes.contains(widget.type);
    return AdminPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.type.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            required
                ? 'Required document'
                : 'Optional · not required for this request',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (document == null) ...[
            const StatusBadge('Missing', tone: BadgeTone.amber),
            const SizedBox(height: 16),
            const Text(
              'No submission is available to inspect. A missing document cannot be approved.',
              style: TextStyle(fontSize: 12, color: AdminColors.muted),
            ),
          ] else ...[
            Align(
              alignment: Alignment.centerLeft,
              child: DocumentStatusBadge(document.status),
            ),
            const SizedBox(height: 12),
            DocumentThumbnail(document: document),
            const SizedBox(height: 12),
            Text(
              'Document number: ${document.number ?? 'Not provided'}\nUploaded: ${verificationDate(document.uploadedAt)}\nExpiry: ${verificationDate(document.expiresAt)}',
              style: const TextStyle(
                fontSize: 11,
                height: 1.8,
                color: AdminColors.muted,
              ),
            ),
            if (document.reviewedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Reviewed ${verificationDate(document.reviewedAt)} · ${document.reviewer}',
                  style: const TextStyle(fontSize: 10, color: AdminColors.teal),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              key: ValueKey('note-${widget.type.name}'),
              controller: _note,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Review note / rejection reason',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: (value) => widget.controller.saveNote(
                widget.requestId,
                widget.type,
                value,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  key: ValueKey('pending-${widget.type.name}'),
                  onPressed: () => _decide(DocumentReviewStatus.pending),
                  child: const Text('Mark pending'),
                ),
                TextButton(
                  key: ValueKey('approve-${widget.type.name}'),
                  onPressed: () => _decide(DocumentReviewStatus.approved),
                  child: const Text('Approve document'),
                ),
                TextButton(
                  key: ValueKey('reject-${widget.type.name}'),
                  style: TextButton.styleFrom(foregroundColor: AdminColors.red),
                  onPressed: () => _decide(DocumentReviewStatus.rejected),
                  child: const Text('Reject document'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
