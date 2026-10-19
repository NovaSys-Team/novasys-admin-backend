import 'package:flutter/foundation.dart';

import '../models/parent_record.dart';

class ParentsController extends ChangeNotifier {
  ParentsController({List<ParentRecord>? parents})
    : _parents = List.unmodifiable(
        parents ??
            [
              ParentRecord(
                id: 'parent-001',
                name: 'Nethmi Perera',
                email: 'nethmi@example.test',
                status: ParentStatus.active,
                children: const [
                  ParentChild(
                    id: 'child-001',
                    name: 'Aanya Perera',
                    school: 'Royal College',
                    grade: '4',
                  ),
                ],
              ),
            ],
      );
  final List<ParentRecord> _parents;
  String _query = '';
  String get query => _query;
  ParentStatus? _status;
  ParentStatus? get status => _status;
  ParentChildrenFilter? _childrenFilter;
  ParentChildrenFilter? get childrenFilter => _childrenFilter;
  bool get hasFilters =>
      _query.isNotEmpty || _status != null || _childrenFilter != null;

  List<ParentRecord> get visibleParents {
    final query = _query.trim().toLowerCase();
    return List.unmodifiable(
      _parents.where((parent) {
        final matchesChildren = switch (_childrenFilter) {
          null => true,
          ParentChildrenFilter.withChildren => parent.children.isNotEmpty,
          ParentChildrenFilter.withoutChildren => parent.children.isEmpty,
        };
        final searchText =
            '${parent.name} ${parent.email} ${parent.status.label} ${parent.children.length} ${parent.children.map((child) => '${child.name} ${child.school}').join(' ')}';
        return (_status == null || parent.status == _status) &&
            matchesChildren &&
            searchText.toLowerCase().contains(query);
      }),
    );
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  void filterStatus(ParentStatus? value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  void filterChildren(ParentChildrenFilter? value) {
    if (_childrenFilter == value) return;
    _childrenFilter = value;
    notifyListeners();
  }

  void resetFilters() {
    if (!hasFilters) return;
    _query = '';
    _status = null;
    _childrenFilter = null;
    notifyListeners();
  }
}
