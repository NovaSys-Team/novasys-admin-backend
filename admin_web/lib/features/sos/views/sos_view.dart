import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../../shared/widgets/record_search_field.dart';
import '../controllers/sos_controller.dart';
import '../models/sos_alert.dart';
import 'widgets/sos_widgets.dart';

class SosView extends StatefulWidget {
  const SosView({super.key, required this.controller});
  final SosController controller;
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
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
      final alerts = controller.visibleAlerts;
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
                    'Emergency center',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Manage sos across your school transport network.',
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
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '19 Oct 2026'),
                      TextSpan(
                        text: '  · Morning',
                        style: TextStyle(color: AdminColors.muted),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (!controller.showDemo)
            const AdminPanel(
              child: SizedBox(
                height: 332,
                child: Padding(
                  padding: EdgeInsets.only(top: 65),
                  child: Column(
                    children: [
                      Text(
                        'No emergency alerts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Alerts raised from an active driver trip appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AdminColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AdminColors.banner,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Demo only · No emergency dispatch or notifications.',
                  style: TextStyle(fontSize: 11, color: AdminColors.teal),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Show demo alerts',
                      style: TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      label: 'Show demo alerts',
                      child: Switch(
                        value: controller.showDemo,
                        onChanged: controller.setShowDemo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (controller.showDemo) ...[
            const SizedBox(height: 24),
            SosSummaryCards(alerts: controller.alerts),
            const SizedBox(height: 24),
            AdminPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PanelHeading(
                    title: 'Demo alert records',
                    subtitle: 'Fictional scenarios · session-only changes',
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
                        child: _filter<SosStatus>(
                          label: 'Status',
                          value: controller.status,
                          values: SosStatus.values,
                          labelFor: (v) => v.label,
                          onChanged: controller.filterStatus,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: _filter<SosPriority>(
                          label: 'Priority',
                          value: controller.priority,
                          values: SosPriority.values,
                          labelFor: (v) => v.label,
                          onChanged: controller.filterPriority,
                        ),
                      ),
                      if (controller.hasFilters)
                        TextButton(
                          onPressed: _reset,
                          child: const Text('Reset filters'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final alert in alerts)
                    SosAlertCard(
                      alert: alert,
                      onDetails: () => _details(alert.id),
                    ),
                  if (alerts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          const Text(
                            'No demo alerts match your search or filters.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Show all demo alerts'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      );
    },
  );

  Widget _filter<T>({
    required String label,
    required T? value,
    required List<T> values,
    required String Function(T) labelFor,
    required ValueChanged<T?> onChanged,
  }) => InputDecorator(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11, color: AdminColors.muted),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        isDense: true,
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: AdminColors.ink),
        items: [
          DropdownMenuItem<T>(value: null, child: const Text('All')),
          for (final v in values)
            DropdownMenuItem<T>(value: v, child: Text(labelFor(v))),
        ],
        onChanged: onChanged,
      ),
    ),
  );

  void _details(String id) => showDialog<void>(
    context: context,
    builder: (context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final alert = widget.controller.alertById(id);
        return AlertDialog(
          title: const Text('Demo alert details'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fictional scenario. Changes affect this session only. No dispatch or notifications.',
                    style: TextStyle(fontSize: 12, color: AdminColors.teal),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    alert.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      SosStatusBadge(alert.status),
                      StatusBadge(alert.priority.label, tone: BadgeTone.amber),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${alert.id}\n19 October 2026 · ${alert.timeLabel}\n${alert.driver} · ${alert.vehicle}\n${alert.route}\n${alert.location}',
                    style: const TextStyle(fontSize: 12, height: 1.8),
                  ),
                  const SizedBox(height: 16),
                  Text(alert.description),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (alert.status != SosStatus.resolved)
              TextButton(
                onPressed: () => widget.controller.advanceStatus(id),
                child: Text(
                  alert.status == SosStatus.open
                      ? 'Acknowledge demo'
                      : 'Resolve demo',
                ),
              ),
          ],
        );
      },
    ),
  );
}
