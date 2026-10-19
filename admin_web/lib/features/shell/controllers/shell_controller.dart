import 'package:flutter/foundation.dart';

import '../models/admin_destination.dart';

class ShellController extends ChangeNotifier {
  AdminDestination _selected = AdminDestination.overview;
  AdminDestination get selected => _selected;
  void select(AdminDestination destination) {
    if (_selected == destination) return;
    _selected = destination;
    notifyListeners();
  }
}
