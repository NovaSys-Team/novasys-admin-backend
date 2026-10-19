import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/verification_request.dart';
import 'verification_status_badge.dart';

class VerificationTable extends StatefulWidget {
  const VerificationTable({
    super.key,
    required this.requests,
    required this.onReview,
  });
  final List<VerificationRequest> requests;
  final ValueChanged<VerificationRequest> onReview;
  @override
  State<VerificationTable> createState() => _VerificationTableState();
}

class _VerificationTableState extends State<VerificationTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 1200;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        child: SingleChildScrollView(
          key: const ValueKey('verification-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 1200 : constraints.maxWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(170),
                1: FlexColumnWidth(150),
                2: FlexColumnWidth(180),
                3: FlexColumnWidth(130),
                4: FlexColumnWidth(170),
                5: FlexColumnWidth(160),
                6: FlexColumnWidth(240),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                  children: [
                    for (final title in [
                      'Driver Name',
                      'Driver ID',
                      'Contact Number',
                      'Submitted Date',
                      'Documents Submitted',
                      'Verification Status',
                      'Actions',
                    ])
                      _cell(
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.muted,
                          ),
                        ),
                      ),
                  ],
                ),
                for (final request in widget.requests)
                  TableRow(
                    key: ValueKey(request.id),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AdminColors.border),
                      ),
                    ),
                    children: [
                      _cell(Text(request.driver)),
                      _cell(Text(request.driverId)),
                      _cell(Text(request.phone)),
                      _cell(Text(verificationDate(request.submittedAt))),
                      _cell(
                        Text(
                          '${request.requiredTypes.length - request.missingCount}/${request.requiredTypes.length} required\n${request.missingCount} missing',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: VerificationStatusBadge(request),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton(
                            key: ValueKey('review-${request.id}'),
                            onPressed: () => widget.onReview(request),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AdminColors.teal,
                              side: const BorderSide(color: AdminColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Review Documents',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
  Widget _cell(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    child: child,
  );
}
