import 'package:flutter/material.dart';

import 'core/theme/admin_theme.dart';
import 'features/shell/views/admin_shell.dart';

void main() => runApp(const NovaSysApp());

class NovaSysApp extends StatelessWidget {
  const NovaSysApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NovaSys Control Center',
    debugShowCheckedModeBanner: false,
    theme: AdminTheme.light,
    home: const AdminShell(),
  );
}
