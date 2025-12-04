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

  /// Paleta de colores por defecto (LexIA) - Tema Claro
  static const AppColors defaultColors = AppColors(
    primary: Color(0xFFF8F4EF),    // Fondo de Pantalla (beige claro)
    secondary: Color(0xFFD19A86),  // Botones de Acción (terracota)
    tertiary: Color(0xFF3D2E28),   // Texto Principal / Iconos (marrón oscuro)
    accent: Color(0xFFE8D9CE),     // Acentos Sutiles / Bordes (beige)
  );

  /// Paleta de colores para Tema Oscuro
  static const AppColors darkColors = AppColors(
    primary: Color(0xFF1A1512),    // Fondo de Pantalla (marrón muy oscuro)
    secondary: Color(0xFFE5A896),  // Botones de Acción (terracota más brillante)
    tertiary: Color(0xFFF5EDE8),   // Texto Principal / Iconos (beige muy claro)
    accent: Color(0xFF3D322C),     // Acentos Sutiles / Bordes (marrón medio)
  );

  /// Colores adicionales para estados y acciones
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  /// Colores de superficie para cards y contenedores
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A231F);

  /// Colores para inputs
  static const Color inputBackgroundLight = Color(0xFFFAFAFA);
  static const Color inputBackgroundDark = Color(0xFF352D28);
  static const Color inputBorderLight = Color(0xFFD0C4BA);
  static const Color inputBorderDark = Color(0xFF4A3F38);
}