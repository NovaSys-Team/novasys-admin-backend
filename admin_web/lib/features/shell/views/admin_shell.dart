import 'package:flutter/material.dart';

import '../../../core/theme/admin_theme.dart';
import '../../../shared/widgets/admin_widgets.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/views/attendance_view.dart';
import '../../overview/controllers/overview_controller.dart';
import '../../overview/views/overview_view.dart';
import '../../sos/controllers/sos_controller.dart';
import '../../sos/views/sos_view.dart';
import '../../trips/controllers/trips_controller.dart';
import '../../trips/views/trips_view.dart';
import '../controllers/shell_controller.dart';
import '../models/admin_destination.dart';
import 'admin_sidebar.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _controller = ShellController();
  final _overview = OverviewController();
  final _trips = TripsController();
  final _attendance = AttendanceController();
  final _sos = SosController();
  final _scaffold = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    _controller.dispose();
    _trips.dispose();
    _attendance.dispose();
    _sos.dispose();
    super.dispose();
  }

  void _select(AdminDestination destination) {
    _controller.select(destination);
    _scaffold.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < AdminSpace.drawerBreakpoint;
      return ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => Scaffold(
          key: _scaffold,
          drawer: compact
              ? Drawer(
                  width: AdminSpace.sidebar,
                  child: AdminSidebar(
                    selected: _controller.selected,
                    onSelect: _select,
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!compact)
                AdminSidebar(selected: _controller.selected, onSelect: _select),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(
                      destination: _controller.selected,
                      compact: compact,
                      onMenu: () => _scaffold.currentState?.openDrawer(),
                      onSelect: _select,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey(_controller.selected),
                        padding: EdgeInsets.all(
                          constraints.maxWidth < 600 ? 18 : AdminSpace.page,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_controller.selected ==
                                AdminDestination.overview)
                              OverviewView(
                                controller: _overview,
                                onSelect: _select,
                              )
                            else if (_controller.selected ==
                                AdminDestination.trips)
                              TripsView(controller: _trips)
                            else if (_controller.selected ==
                                AdminDestination.attendance)
                              AttendanceView(controller: _attendance)
                            else if (_controller.selected ==
                                AdminDestination.emergency)
                              SosView(controller: _sos)
                            else
                              _Placeholder(
                                destination: _controller.selected,
                                onBack: () =>
                                    _select(AdminDestination.overview),
                              ),
                            const SizedBox(height: 48),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 20,
                              runSpacing: 10,
                              children: [
                                Text(
                                  'NovaSys · Connected journeys. Clearer decisions.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  'Sample data · administrator preview',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.destination,
    required this.compact,
    required this.onMenu,
    required this.onSelect,
  });
  final AdminDestination destination;
  final bool compact;
  final VoidCallback onMenu;
  final ValueChanged<AdminDestination> onSelect;
  @override
  Widget build(BuildContext context) => Container(
    height: 78,
    padding: EdgeInsets.symmetric(horizontal: compact ? 12 : AdminSpace.page),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: AdminColors.border)),
    ),
    child: Row(
      children: [
        if (compact)
          IconButton(
            tooltip: 'Open navigation',
            onPressed: onMenu,
            icon: const Icon(Icons.menu),
          ),
        if (MediaQuery.sizeOf(context).width > 520)
          const Text(
            'Workspace',
            style: TextStyle(fontSize: 11, color: AdminColors.muted),
          ),
        if (MediaQuery.sizeOf(context).width > 520)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text('/', style: TextStyle(color: AdminColors.muted)),
          ),
        Expanded(
          child: Text(
            destination.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => onSelect(AdminDestination.notifications),
          icon: const Icon(Icons.notifications_outlined, size: 20),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 18,
          backgroundColor: AdminColors.banner,
          child: Text(
            'AD',
            style: TextStyle(
              fontSize: 11,
              color: AdminColors.teal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (MediaQuery.sizeOf(context).width > 650) ...[
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Administrator',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'Full workspace access',
                style: TextStyle(fontSize: 9, color: AdminColors.muted),
              ),
            ],
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Administrator preview'),
                content: const Text(
                  'This preview uses local sample data. There is no signed-in session.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            child: const Text(
              'Sign out',
              style: TextStyle(color: AdminColors.ink),
            ),
          ),
        ],
      ],
    ),
  );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.destination, required this.onBack});
  final AdminDestination destination;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'NOVASYS / CONTROL CENTER',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: 20),
      Text(
        destination.label,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 28),
      AdminPanel(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Icon(destination.icon, size: 40, color: AdminColors.teal),
              const SizedBox(height: 20),
              Text(
                '${destination.label} is coming soon',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'This destination is planned for a future phase.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ActionLink('Back to Overview', onPressed: onBack),
            ],
          ),
        ),
      ),
    ],
  );
}
