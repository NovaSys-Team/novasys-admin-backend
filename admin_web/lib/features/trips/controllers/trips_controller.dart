import 'package:flutter/foundation.dart';

import '../models/trip.dart';

class TripsController extends ChangeNotifier {
  TripsController({List<Trip>? trips})
    : _trips = List.unmodifiable(
        trips ??
            [
              Trip(
                id: 'morning-2026-10-19',
                name: 'Morning',
                status: TripStatus.notStarted,
                attendance: [
                  TripAttendance.expected,
                  TripAttendance.expected,
                  TripAttendance.absent,
                ],
              ),
            ],
      );

  final List<Trip> _trips;
  String _query = '';
  String get query => _query;

  List<Trip> get visibleTrips {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      _trips.where(
        (trip) => '${trip.name} ${trip.status.label} ${trip.attendanceLabel}'
            .toLowerCase()
            .contains(query),
      ),
    );
  }

  void search(String query) {
    if (_query == query) return;
    _query = query;
    notifyListeners();
  }
}
