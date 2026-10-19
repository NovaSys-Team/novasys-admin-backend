import 'package:flutter/material.dart';

import '../../../../core/theme/admin_theme.dart';
import '../../models/parent_record.dart';
import 'parent_status_badge.dart';

class ParentsTable extends StatefulWidget {
  const ParentsTable({
    super.key,
    required this.parents,
    required this.onDetails,
  });
  final List<ParentRecord> parents;
  final ValueChanged<ParentRecord> onDetails;
  @override
  State<ParentsTable> createState() => _ParentsTableState();
}

class _ParentsTableState extends State<ParentsTable> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scrolls = constraints.maxWidth < 900;
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: scrolls,
        child: SingleChildScrollView(
          key: const ValueKey('parents-table-scroll'),
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: scrolls ? 16 : 0),
          child: SizedBox(
            width: scrolls ? 900 : constraints.maxWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(251.63),
                1: FlexColumnWidth(350.55),
                2: FlexColumnWidth(190.44),
                3: FlexColumnWidth(271.39),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF7F9FB)),
                  children: [
                    for (final title in [
                      'Parent',
                      'Email',
                      'Children',
                      'Action',
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        child: Text(
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
                for (final parent in widget.parents)
                  TableRow(
                    key: ValueKey(parent.id),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AdminColors.border),
                      ),
                    ),
                    children: [
                      _cell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parent.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            ParentStatusBadge(parent.status),
                          ],
                        ),
                      ),
                      _cell(
                        Text(
                          parent.email,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Text(
                          '${parent.children.length}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      _cell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton(
                            onPressed: () => widget.onDetails(parent),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AdminColors.ink,
                              side: const BorderSide(color: AdminColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 12,
                              ),
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text('View details'),
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    child: child,
  );
}
