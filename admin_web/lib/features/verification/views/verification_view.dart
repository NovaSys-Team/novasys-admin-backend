import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/verification_controller.dart';
import '../models/verification_request.dart';
import 'widgets/verification_review_panel.dart';
import 'widgets/verification_table.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key, required this.controller});
  final VerificationController controller;
  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  late final _search = TextEditingController(text: widget.controller.query);
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    widget.controller.resetFilters();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      if (controller.selectedId != null) {
        return VerificationReviewPanel(
          key: ValueKey(controller.selectedId),
          controller: controller,
          requestId: controller.selectedId!,
        );
      }
      final requests = controller.visibleRequests;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NOVASYS / CONTROL CENTER',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Verification',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 14),
          const Text(
            'Review driver eligibility and every submitted document.',
            style: TextStyle(fontSize: 12, color: AdminColors.muted),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 850
                  ? 4
                  : constraints.maxWidth >= 450
                  ? 2
                  : 1;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final status in VerificationStatus.values)
                    SizedBox(
                      width:
                          (constraints.maxWidth - (columns - 1) * 16) / columns,
                      child: AdminPanel(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AdminColors.muted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              controller
                                  .count(status)
                                  .toString()
                                  .padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sample requests · all records',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          AdminPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AdminColors.banner,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Demo document review · All required documents must be approved before the driver. Local mock decisions only.',
                    style: TextStyle(fontSize: 12, color: AdminColors.teal),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: RecordSearchField(
                        controller: _search,
                        onChanged: controller.search,
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Verification status',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<VerificationStatus>(
                            value: controller.status,
                            isExpanded: true,
                            isDense: true,
                            hint: const Text(
                              'All statuses',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AdminColors.ink,
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All statuses'),
                              ),
                              for (final status in VerificationStatus.values)
                                DropdownMenuItem(
                                  value: status,
                                  child: Text(status.label),
                                ),
                            ],
                            onChanged: controller.filterStatus,
                          ),
                        ),
                      ),
                    ),
                    if (controller.hasFilters)
                      TextButton(
                        onPressed: _reset,
                        child: const Text('Reset filters'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                VerificationTable(
                  requests: requests,
                  onReview: (request) {
                    final scroll = Scrollable.maybeOf(context);
                    controller.openRequest(request.id);
                    scroll?.position.jumpTo(0);
                  },
                ),
                if (requests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      children: [
                        const Text(
                          'No verification requests match your search or filters.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _reset,
                          child: const Text('Show all requests'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
