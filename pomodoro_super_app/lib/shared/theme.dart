import 'package:flutter/material.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF6C63FF),
    brightness: brightness,
  );
  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    ),
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
    ),
  );
}