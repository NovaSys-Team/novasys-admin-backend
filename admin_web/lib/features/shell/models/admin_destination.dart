import 'package:flutter/material.dart';

enum AdminDestination {
  overview('Overview', 'WORKSPACE', Icons.dashboard_outlined),
  trips('Trips', 'WORKSPACE', Icons.directions_bus_outlined),
  attendance('Attendance', 'WORKSPACE', Icons.fact_check_outlined),
  emergency('Emergency center', 'WORKSPACE', Icons.health_and_safety_outlined),
  parents('Parents', 'PEOPLE & NETWORK', Icons.people_outline),
  students('Students', 'PEOPLE & NETWORK', Icons.school_outlined),
  drivers('Drivers', 'PEOPLE & NETWORK', Icons.badge_outlined),
  verification(
    'Verification',
    'PEOPLE & NETWORK',
    Icons.verified_user_outlined,
  ),
  vehicles('Vehicles', 'PEOPLE & NETWORK', Icons.airport_shuttle_outlined),
  schools('Schools', 'PEOPLE & NETWORK', Icons.apartment_outlined),
  routes('Routes & geofences', 'PEOPLE & NETWORK', Icons.route_outlined),
  assignments('Assignments', 'PEOPLE & NETWORK', Icons.assignment_outlined),
  requests('Service requests', 'PEOPLE & NETWORK', Icons.inbox_outlined),
  payments('Payments', 'FINANCE & SUPPORT', Icons.credit_card_outlined),
  settlements(
    'Settlements',
    'FINANCE & SUPPORT',
    Icons.account_balance_wallet_outlined,
  ),
  complaints('Complaints', 'FINANCE & SUPPORT', Icons.chat_bubble_outline),
  ratings('Ratings', 'FINANCE & SUPPORT', Icons.star_outline),
  notifications(
    'Notifications',
    'FINANCE & SUPPORT',
    Icons.notifications_outlined,
  ),
  reports('Reports', 'ADMINISTRATION', Icons.bar_chart_outlined),
  audit('Audit log', 'ADMINISTRATION', Icons.history_outlined),
  access(
    'Access & roles',
    'ADMINISTRATION',
    Icons.admin_panel_settings_outlined,
  ),
  settings('Settings', 'ADMINISTRATION', Icons.settings_outlined);

  const AdminDestination(this.label, this.group, this.icon);
  final String label;
  final String group;
  final IconData icon;
}
