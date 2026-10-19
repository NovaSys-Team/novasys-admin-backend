import 'package:flutter/foundation.dart';

import '../models/sos_alert.dart';

class SosController extends ChangeNotifier {
  final List<SosAlert> _alerts = [
    SosAlert(
      id: 'DEMO-SOS-001',
      title: 'Driver assistance requested',
      driver: 'Sunil Perera',
      vehicle: 'WP NC–4821',
      route: 'Nugegoda → Royal College',
      location: 'Temple Road, Nugegoda',
      description: 'Fictional driver assistance scenario for reviewing the SOS interface.',
      raisedAt: DateTime(2026, 10, 19, 7, 10),
      priority: SosPriority.critical,
      status: SosStatus.open,
    ),
    SosAlert(
      id: 'DEMO-SOS-002',
      title: 'Vehicle stopped on route',
      driver: 'Demo Driver B',
      vehicle: 'DEMO–002',
      route: 'Colombo → Demo School',
      location: 'Demo stop, Colombo',
      description: 'Fictional vehicle stop. Acknowledged in the sample data.',
      raisedAt: DateTime(2026, 10, 19, 7, 5),
      priority: SosPriority.high,
      status: SosStatus.acknowledged,
    ),
    SosAlert(
      id: 'DEMO-SOS-003',
      title: 'Route assistance completed',
      driver: 'Demo Driver C',
      vehicle: 'DEMO–003',
      route: 'Demo morning route',
      location: 'Demo school entrance',
      description: 'Fictional scenario marked resolved for interface testing.',
      raisedAt: DateTime(2026, 10, 19, 6, 55),
      priority: SosPriority.moderate,
      status: SosStatus.resolved,
    ),
  ];
  bool _showDemo = false;
  bool get showDemo => _showDemo;
  String _query = '';
  String get query => _query;
  SosStatus? _status;
  SosStatus? get status => _status;
  SosPriority? _priority;
  SosPriority? get priority => _priority;
  bool get hasFilters =>
      _query.isNotEmpty || _status != null || _priority != null;
  List<SosAlert> get alerts =>
      List.unmodifiable(_showDemo ? _alerts : <SosAlert>[]);
  int count(SosStatus status) =>
      alerts.where((alert) => alert.status == status).length;
  SosAlert alertById(String id) =>
      _alerts.firstWhere((alert) => alert.id == id);
  List<SosAlert> get visibleAlerts {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      alerts.where(
        (alert) =>
            (_status == null || alert.status == _status) &&
            (_priority == null || alert.priority == _priority) &&
            '${alert.id} ${alert.title} ${alert.driver} ${alert.vehicle} ${alert.route} ${alert.location} ${alert.status.label} ${alert.priority.label}'
                .toLowerCase()
                .contains(query),
      ),
    );
  }

  void setShowDemo(bool value) {
    if (_showDemo == value) return;
    _showDemo = value;
    notifyListeners();
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void filterStatus(SosStatus? value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void filterPriority(SosPriority? value) {
    if (_priority == value) return;
    _priority = value;
    notifyListeners();
  }

  void resetFilters() {
    _query = '';
    _status = null;
    _priority = null;
    notifyListeners();
  }

  /// Session-local demo transitions. No dispatch or notification is performed.
  void advanceStatus(String id) {
    if (!_showDemo) return;
    final index = _alerts.indexWhere((alert) => alert.id == id);
    if (index < 0) return;
    final current = _alerts[index];
    if (current.status == SosStatus.resolved) return;
    _alerts[index] = current.withStatus(
      current.status == SosStatus.open
          ? SosStatus.acknowledged
          : SosStatus.resolved,
    );
    notifyListeners();
  }
}
