import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../shell/models/admin_destination.dart';
import '../controllers/overview_controller.dart';
import '../models/overview_data.dart';
import 'widgets/journey_map.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({
    super.key,
    required this.controller,
    required this.onSelect,
  });
  final OverviewController controller;
  final ValueChanged<AdminDestination> onSelect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      final columns = constraints.maxWidth >= 900
          ? 4
          : constraints.maxWidth >= 500
          ? 2
          : 1;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NOVASYS / CONTROL CENTER',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(letterSpacing: 1.7, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operations overview',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your school transport network, at a glance.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AdminColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: controller.dateLabel),
                      const TextSpan(
                        text: '  · Morning',
                        style: TextStyle(color: AdminColors.muted),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _HeroBanner(controller: controller, onSelect: onSelect),
          const SizedBox(height: 22),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final stat in controller.statistics)
                SizedBox(
                  width: (constraints.maxWidth - (columns - 1) * 16) / columns,
                  child: _StatisticCard(
                    stat: stat,
                    onTap: () => onSelect(stat.destination),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 40),
          _PanelPair(
            wide: wide,
            left: _journey(context),
            right: _attention(context),
          ),
          const SizedBox(height: 40),
          _PanelPair(
            wide: wide,
            left: _finance(context),
            right: _activity(context),
          ),
        ],
      );
    },
  );

  Widget _journey(BuildContext context) => AdminPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeading(
          title: 'Journey monitor',
          subtitle: 'Assigned route · illustrative map',
          action: StatusBadge(controller.journey.status),
        ),
        const SizedBox(height: 28),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 270,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const JourneyMap(),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.journey.route,
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'AM / PM service',
                          style: TextStyle(
                            fontSize: 9,
                            color: AdminColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF4F4),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.directions_bus_outlined,
                    color: AdminColors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.journey.service,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${controller.journey.driver} · ${controller.journey.plate}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ActionLink(
              'Inspect trip',
              onPressed: () => onSelect(AdminDestination.trips),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _attention(BuildContext context) => AdminPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PanelHeading(
          title: 'Needs attention',
          subtitle: 'Prioritize the next action',
          action: Icon(Icons.circle, size: 7, color: Color(0xFF60A997)),
        ),
        const SizedBox(height: 28),
        for (final item in controller.attention)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelect(item.destination),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(minHeight: 78),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: item == controller.attention.last
                      ? null
                      : const Border(
                          bottom: BorderSide(color: AdminColors.border),
                        ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusBadge(item.badge, tone: item.tone),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 30),
      ],
    ),
  );

  Widget _finance(BuildContext context) => AdminPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeading(
          title: 'Finance snapshot',
          subtitle: 'October 2026 · sample invoice',
          action: ActionLink(
            'Payments',
            onPressed: () => onSelect(AdminDestination.payments),
          ),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 16,
            children: [
              for (final entry in {
                'Invoiced': controller.finance.invoiced,
                'Collected': controller.finance.collected,
                'Outstanding': controller.finance.outstanding,
              }.entries)
                SizedBox(
                  width: constraints.maxWidth < 370
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 24) / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        controller.currency(entry.value),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          value: controller.finance.collectionRate,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: const Color(0xFFEDF1F4),
          color: AdminColors.teal,
        ),
        const SizedBox(height: 16),
        Text(
          '${(controller.finance.collectionRate * 100).round()}% collected · Pending reconciliation',
          style: const TextStyle(fontSize: 10),
        ),
        const SizedBox(height: 8),
        ActionLink(
          'Review driver settlement',
          onPressed: () => onSelect(AdminDestination.settlements),
        ),
      ],
    ),
  );

  Widget _activity(BuildContext context) => AdminPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeading(
          title: 'Recent activity',
          subtitle: 'Changes across your workspace',
          action: ActionLink(
            'Audit log',
            onPressed: () => onSelect(AdminDestination.audit),
          ),
        ),
        const SizedBox(height: 48),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(Icons.circle, size: 7, color: Color(0xFF60A997)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.activity.title,
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.activity.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 64),
      ],
    ),
  );
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.controller, required this.onSelect});
  final OverviewController controller;
  final ValueChanged<AdminDestination> onSelect;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(29),
    decoration: BoxDecoration(
      color: AdminColors.banner,
      borderRadius: BorderRadius.circular(13),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.operationsLabel,
              style: const TextStyle(
                fontSize: 9,
                letterSpacing: 1.2,
                color: Color(0xFF6F8292),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Every journey. One clear view.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -.6,
                color: Color(0xFF17444E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Keep students moving safely, and your team one step ahead.',
              style: TextStyle(fontSize: 11, color: Color(0xFF5C7880)),
            ),
          ],
        );
        final button = FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AdminColors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onPressed: () => onSelect(AdminDestination.trips),
          icon: const Icon(Icons.arrow_forward, size: 15),
          iconAlignment: IconAlignment.end,
          label: const Text('View school runs', style: TextStyle(fontSize: 11)),
        );
        return constraints.maxWidth >= 720
            ? Row(
                children: [
                  Expanded(child: copy),
                  const SizedBox(width: 20),
                  button,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 20), button],
              );
      },
    ),
  );
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.stat, required this.onTap});
  final OverviewStatistic stat;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${stat.label}: ${stat.value}',
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(color: AdminColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stat.label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF687C8C),
                      ),
                    ),
                  ),
                  Icon(stat.icon, size: 19, color: AdminColors.teal),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                stat.value.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(stat.caption, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PanelPair extends StatelessWidget {
  const _PanelPair({
    required this.wide,
    required this.left,
    required this.right,
  });
  final bool wide;
  final Widget left;
  final Widget right;
  @override
  Widget build(BuildContext context) => wide
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 155, child: left),
            const SizedBox(width: 22),
            Expanded(flex: 100, child: right),
          ],
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [left, const SizedBox(height: 22), right],
        );
}
