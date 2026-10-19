import 'package:flutter/foundation.dart';

import '../models/driver_record.dart';

class DriversController extends ChangeNotifier {
  DriversController({List<DriverRecord>? drivers})
    : _drivers = List.unmodifiable(
        drivers ??
            [
              DriverRecord(
                id: 'driver-001',
                name: 'Sunil Perera',
                email: 'sunil@example.test',
                vehicle: 'WP NC–4821',
                status: DriverStatus.verified,
                documents: const [
                  DriverDocument(
                    type: DriverDocumentType.licence,
                    status: DriverDocumentStatus.reviewed,
                  ),
                  DriverDocument(
                    type: DriverDocumentType.registration,
                    status: DriverDocumentStatus.reviewed,
                  ),
                  DriverDocument(
                    type: DriverDocumentType.insurance,
                    status: DriverDocumentStatus.reviewed,
                  ),
                ],
              ),
              DriverRecord(
                id: 'driver-002',
                name: 'New driver',
                email: 'newdriver@example.test',
                status: DriverStatus.pending,
                documents: [],
              ),
            ],
      );
  final List<DriverRecord> _drivers;
  String _query = '';
  String get query => _query;
  DriverStatus? _status;
  DriverStatus? get status => _status;
  DriverDocumentFilter? _documentFilter;
  DriverDocumentFilter? get documentFilter => _documentFilter;
  bool get hasFilters =>
      _query.isNotEmpty || _status != null || _documentFilter != null;

  List<DriverRecord> get visibleDrivers {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      _drivers.where((driver) {
        final matchesDocuments = switch (_documentFilter) {
          null => true,
          DriverDocumentFilter.complete => driver.hasCompleteDocuments,
          DriverDocumentFilter.incomplete => !driver.hasCompleteDocuments,
        };
        return (_status == null || driver.status == _status) &&
            matchesDocuments &&
            '${driver.name} ${driver.email} ${driver.vehicleLabel} ${driver.status.label} ${driver.documentsLabel}'
                .toLowerCase()
                .contains(query);
      }),
    );
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void filterStatus(DriverStatus? value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void filterDocuments(DriverDocumentFilter? value) {
    if (_documentFilter == value) return;
    _documentFilter = value;
    notifyListeners();
  }

  void resetFilters() {
    if (!hasFilters) return;
    _query = '';
    _status = null;
    _documentFilter = null;
    notifyListeners();
  }
}
