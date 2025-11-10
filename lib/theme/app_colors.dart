import 'package:flutter/material.dart';

/// Define los colores de la aplicación según la paleta de diseño
class AppColors {
  // Colores principales
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color accent;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.accent,
  });

  /// Paleta de colores por defecto (LexIA)
  static const AppColors defaultColors = AppColors(
    primary: Color(0xFFF8F4EF),    // Fondo de Pantalla
    secondary: Color(0xFFD19A86),  // Botones de Acción
    tertiary: Color(0xFF3D2E28),   // Texto Principal / Iconos
    accent: Color(0xFFE8D9CE),     // Acentos Sutiles / Bordes
  );
}