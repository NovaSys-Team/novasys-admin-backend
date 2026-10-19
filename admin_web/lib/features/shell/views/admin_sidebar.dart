import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../models/admin_destination.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selected,
    required this.onSelect,
  });
  final AdminDestination selected;
  final ValueChanged<AdminDestination> onSelect;

  @override
  Widget build(BuildContext context) => Container(
    width: AdminSpace.sidebar,
    color: AdminColors.navy,
    child: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_bus_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NovaSys',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'CONTROL CENTER',
                        style: TextStyle(
                          color: Color(0xFF9EB7C6),
                          fontSize: 8,
                          letterSpacing: 2.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Color(0xFFD6EEEE),
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontSize: 13,
                        color: AdminColors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'School transport',
                          style: TextStyle(
                            color: Color(0xFFE5EFF5),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Administrator workspace',
                          style: TextStyle(
                            color: Color(0xFF99B1C4),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            for (final group
                in AdminDestination.values.map((e) => e.group).toSet()) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 18, 0, 10),
                child: Text(
                  group,
                  style: const TextStyle(
                    color: Color(0xFF7893AA),
                    fontSize: 9,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              for (final destination in AdminDestination.values.where(
                (e) => e.group == group,
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Material(
                    color: selected == destination
                        ? const Color(0xFF234764)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                      key: ValueKey('nav-${destination.name}'),
                      dense: true,
                      minTileHeight: 38,
                      horizontalTitleGap: 12,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      selected: selected == destination,
                      selectedColor: Colors.white,
                      iconColor: const Color(0xFFA6BDCF),
                      textColor: const Color(0xFFBDCDDA),
                      leading: Icon(destination.icon, size: 17),
                      title: Text(
                        destination.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: destination == AdminDestination.requests
                          ? const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            )
                          : null,
                      onTap: () => onSelect(destination),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 24),
            const Divider(color: Colors.white12),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: Color(0xFF60A997)),
                  SizedBox(width: 8),
                  Text(
                    'Prototype workspace',
                    style: TextStyle(fontSize: 9, color: Color(0xFF99B1C4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
