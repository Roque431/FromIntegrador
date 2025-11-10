import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Genera el tema de la aplicación basado en los colores proporcionados
class AppTheme {
  final AppColors colors;

  const AppTheme(this.colors);

  /// Genera el ColorScheme para el tema claro
  ColorScheme _buildLightColorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: colors.secondary,
      brightness: Brightness.light,
    );

    return base.copyWith(
      primary: colors.primary,          // Fondo de pantalla
      secondary: colors.secondary,      // Botones de acción
      tertiary: colors.tertiary,        // Texto principal / Iconos
      surface: Colors.white,            // Superficie de cards
      onPrimary: colors.tertiary,       // Texto sobre primary
      onSecondary: Colors.white,        // Texto sobre botones secondary
      onSurface: colors.tertiary,       // Texto sobre surface
      outline: colors.accent,           // Bordes sutiles
    );
  }

  /// Genera el ColorScheme para el tema oscuro
  ColorScheme _buildDarkColorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: colors.secondary,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      primary: const Color(0xFF1A1A1A),
      secondary: colors.secondary,
      tertiary: Colors.white,
      surface: const Color(0xFF2A2A2A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      outline: colors.accent.withValues(alpha: 0.3),
    );
  }

  /// ThemeData para modo claro
  ThemeData get lightTheme {
    final colorScheme = _buildLightColorScheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.primary,
      
      // Personalización adicional
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.tertiary,
        elevation: 0,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.secondary, width: 2),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// ThemeData para modo oscuro
  ThemeData get darkTheme {
    final colorScheme = _buildDarkColorScheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.primary,
    );
  }
}
