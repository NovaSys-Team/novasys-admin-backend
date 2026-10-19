import 'package:flutter/material.dart';

abstract final class AdminColors {
  static const navy = Color(0xFF0B2545);
  static const background = Color(0xFFF5F7FA);
  static const ink = Color(0xFF172033);
  static const muted = Color(0xFF7B8B99);
  static const teal = Color(0xFF246E75);
  static const banner = Color(0xFFE5EFF0);
  static const border = Color(0xFFE3E8EF);
  static const green = Color(0xFF277658);
  static const greenTint = Color(0xFFE5F4EB);
  static const amber = Color(0xFF946019);
  static const amberTint = Color(0xFFFFF0D4);
  static const red = Color(0xFFB64D40);
  static const redTint = Color(0xFFFFEBE7);
}

abstract final class AdminSpace {
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const page = 35.0;
  static const sidebar = 260.0;
  static const drawerBreakpoint = 1000.0;
}

abstract final class AdminTheme {
  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AdminColors.background,
    fontFamily: 'Segoe UI',
    colorScheme: ColorScheme.fromSeed(seedColor: AdminColors.teal),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 12, color: AdminColors.ink),
      bodySmall: TextStyle(fontSize: 10, color: AdminColors.muted),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -.3,
        color: AdminColors.ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -.8,
        color: AdminColors.ink,
      ),
    ),
    dividerColor: AdminColors.border,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AdminColors.teal,
        textStyle: const TextStyle(fontSize: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
