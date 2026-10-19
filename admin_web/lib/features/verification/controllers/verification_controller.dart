import 'package:flutter/foundation.dart';

import '../models/verification_mock_data.dart';
import '../models/verification_request.dart';

class VerificationController extends ChangeNotifier {
  VerificationController({
    List<VerificationRequest>? requests,
    DateTime Function()? now,
  }) : _requests = List.of(requests ?? verificationMockRequests()),
       _now = now ?? DateTime.now;
  final List<VerificationRequest> _requests;
  final DateTime Function() _now;
  String _query = '';
  String get query => _query;
  VerificationStatus? _status;
  VerificationStatus? get status => _status;
  String? _selectedId;
  String? get selectedId => _selectedId;
  bool get hasFilters => _query.isNotEmpty || _status != null;
  VerificationRequest requestById(String id) =>
      _requests.firstWhere((r) => r.id == id);
  int count(VerificationStatus status) =>
      _requests.where((r) => r.status == status).length;
  List<VerificationRequest> get visibleRequests {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      _requests.where(
        (r) =>
            (_status == null || r.status == _status) &&
            '${r.driver} ${r.driverId} ${r.phone} ${r.email} ${r.vehicle ?? ''} ${r.status.label}'
                .toLowerCase()
                .contains(query),
      ),
    );
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void filterStatus(VerificationStatus? value) {
    _status = value;
    notifyListeners();
  }

  void resetFilters() {
    _query = '';
    _status = null;
    notifyListeners();
  }

  void openRequest(String id) {
    requestById(id);
    _selectedId = id;
    notifyListeners();
  }

  void closeRequest() {
    _selectedId = null;
    notifyListeners();
  }

  void saveNote(String id, VerificationDocumentType type, String note) {
    _updateDocument(id, type, (doc) => doc.withNote(note), reopen: false);
  }

  /// Returns an actionable error or null on success. All outcomes are mock only.
  String? reviewDocument(
    String id,
    VerificationDocumentType type,
    DocumentReviewStatus status,
  ) {
    final request = requestById(id);
    final document = request.document(type);
    if (document == null) {
      return 'This document is missing and cannot be reviewed.';
    }
    if (status == DocumentReviewStatus.rejected &&
        document.note.trim().isEmpty) {
      return 'Enter a review note before rejecting this document.';
    }
    _updateDocument(
      id,
      type,
      (doc) => doc.withDecision(status, _now()),
      reopen: true,
    );
    return null;
  }

  void _updateDocument(
    String id,
    VerificationDocumentType type,
    VerificationDocument Function(VerificationDocument) update, {
    required bool reopen,
  }) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index < 0 || _requests[index].document(type) == null) return;
    final request = _requests[index];
    _requests[index] = request.copyWith(
      documents: [
        for (final doc in request.documents)
          doc.type == type ? update(doc) : doc,
      ],
      status: reopen ? VerificationStatus.underReview : request.status,
      rejectionReason: reopen ? '' : request.rejectionReason,
      clearDecision: reopen,
    );
    notifyListeners();
  }

  String? approve(String id) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index < 0) return 'Verification request not found.';
    if (!_requests[index].canApprove) {
      return 'Approve every required document before approving the driver.';
    }
    _requests[index] = _requests[index].copyWith(
      status: VerificationStatus.approved,
      rejectionReason: '',
      decidedAt: _now(),
    );
    notifyListeners();
    return null;
  }

  String? reject(String id, String reason) {
    if (reason.trim().isEmpty) return 'A rejection reason is required.';
    final index = _requests.indexWhere((r) => r.id == id);
    if (index < 0) return 'Verification request not found.';
    if (_requests[index].status == VerificationStatus.approved) {
      return 'Reopen a document for review before changing an approved outcome.';
    }
    _requests[index] = _requests[index].copyWith(
      status: VerificationStatus.rejected,
      rejectionReason: reason.trim(),
      decidedAt: _now(),
    );
    notifyListeners();
    return null;
  }
}
