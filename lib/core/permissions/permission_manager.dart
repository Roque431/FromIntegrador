import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Estados de permisos de ubicación
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

/// Gestor de permisos para cumplir con MSTG-PLATFORM-1
/// Maneja permisos de forma segura y transparente para el usuario
class PermissionManager {
  
  /// Verifica y solicita permisos de ubicación de forma segura
  /// Cumple con MSTG-PLATFORM-1: solicitud transparente de permisos
  static Future<LocationPermissionStatus> requestLocationPermission() async {
    try {
      // Verificar si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print('⚠️ Servicios de ubicación deshabilitados');
        }
        return LocationPermissionStatus.serviceDisabled;
      }

      // Verificar permisos actuales
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Solicitar permiso si fue denegado
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('⚠️ Permisos de ubicación denegados');
          }
          return LocationPermissionStatus.denied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('❌ Permisos de ubicación denegados permanentemente');
        }
        return LocationPermissionStatus.deniedForever;
      }

      // Permiso concedido
      if (kDebugMode) {
        print('✅ Permisos de ubicación concedidos');
      }
      return LocationPermissionStatus.granted;

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error solicitando permisos de ubicación: $e');
      }
      return LocationPermissionStatus.error;
    }
  }

  /// Obtiene la ubicación actual de forma segura
  static Future<Position?> getCurrentLocation() async {
    try {
      final permissionStatus = await requestLocationPermission();
      
      if (permissionStatus != LocationPermissionStatus.granted) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (kDebugMode) {
        print('📍 Ubicación obtenida: ${position.latitude}, ${position.longitude}');
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo ubicación: $e');
      }
      return null;
    }
  }

  /// Verifica si la app tiene permisos de ubicación
  static Future<bool> hasLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando permisos: $e');
      }
      return false;
    }
  }

  /// Abre la configuración de la app para que el usuario pueda habilitar permisos
  static Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error abriendo configuración: $e');
      }
    }
  }

  /// Explica al usuario por qué se necesitan los permisos
  /// Importante para transparencia según MSTG-PLATFORM-1
  static String getLocationPermissionRationale() {
    return '''Necesitamos acceso a tu ubicación para:

• Mostrarte oficinas legales cercanas en el mapa
• Proporcionarte servicios de orientación legal local
• Mejorar la precisión de las recomendaciones

Tu ubicación se usa solo para estos propósitos y no se comparte con terceros.''';
  }

  /// Información sobre qué datos se recopilan
  static String getDataCollectionInfo() {
    return '''Datos de ubicación recopilados:

• Coordenadas GPS (latitud/longitud)
• Solo cuando uses el mapa legal
• No se almacena permanentemente
• No se comparte con terceros

Puedes revocar estos permisos en cualquier momento desde la configuración de tu dispositivo.''';
  }
}