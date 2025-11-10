import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_colors.dart';

/// Gestiona la configuración del tema desde variables de entorno
class ThemeConfig {
  /// Convierte un string hexadecimal a Color
  static Color _hexToColor(String? hexColor, Color fallback) {
    try {
      if (hexColor == null || hexColor.trim().isEmpty) {
        return fallback;
      }

      var hex = hexColor.trim();
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }

      if (hex.length == 6) {
        hex = 'FF$hex'; // Añadir alpha si no está presente
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      debugPrint('Error parsing color "$hexColor": $e');
      return fallback;
    }
  }

  /// Carga los colores desde las variables de entorno (.env)
  /// Si no existen, usa los colores por defecto
  static AppColors loadColorsFromEnv() {
    return AppColors(
      primary: _hexToColor(
        dotenv.env['PRIMARY_COLOR'],
        AppColors.defaultColors.primary,
      ),
      secondary: _hexToColor(
        dotenv.env['SECONDARY_COLOR'],
        AppColors.defaultColors.secondary,
      ),
      tertiary: _hexToColor(
        dotenv.env['TERTIARY_COLOR'],
        AppColors.defaultColors.tertiary,
      ),
      accent: _hexToColor(
        dotenv.env['ACCENT_COLOR'],
        AppColors.defaultColors.accent,
      ),
    );
  }
}