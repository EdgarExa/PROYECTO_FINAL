import 'package:flutter/material.dart';

/// Tema visual (Material 3) de la aplicación.
class AppTheme {
  AppTheme._();

  static const Color _colorBase = Color(0xFF2E7D32);

  /// Tema claro con la paleta verde de la tienda.
  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(seedColor: _colorBase);
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.primary,
        foregroundColor: esquema.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
