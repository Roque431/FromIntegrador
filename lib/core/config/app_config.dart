/// Configuración de la versión de la aplicación LexIA
class AppConfig {
  // Información de versión
  static const String appName = 'LexIA';
  static const String appVersion = '2.1.0';
  static const String buildNumber = '21';
  static const String releaseDate = 'Diciembre 2025';

  // URLs y endpoints
  static const String baseUrl = 'http://localhost';
  static const String apiVersion = 'v1';

  // Configuración de características
  static const bool forumEnabled = true;
  static const bool chatPrivadoEnabled = true;
  static const bool profesionalPortalEnabled = true;
  static const bool analyticsEnabled = true;

  // Información del soporte
  static const String supportEmail = 'soporte@lexia.com';
  static const String supportPhone = '+1 (555) 123-4567';
  static const String supportChat24_7 = 'Disponible 24/7';

  // Límites de la aplicación
  static const int maxCharactersPerMessage = 5000;
  static const int maxFileUploadSizeMB = 50;
  static const int maxPublicationsPerDay = 10;
  static const int maxProfilePhotoSizeMB = 5;

  // Configuración de UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 0.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeNormal = 24.0;
  static const double iconSizeLarge = 40.0;
}

/// Tipos de usuarios en LexIA
enum UserType {
  ciudadano,
  abogado,
  anunciante,
  administrador;

  String get displayName {
    switch (this) {
      case UserType.ciudadano:
        return 'Ciudadano';
      case UserType.abogado:
        return 'Abogado';
      case UserType.anunciante:
        return 'Anunciante';
      case UserType.administrador:
        return 'Administrador';
    }
  }
}

/// Estados de verificación profesional
enum ProfessionalStatus {
  pendiente,
  verificado,
  rechazado,
  suspendido;

  String get displayName {
    switch (this) {
      case ProfessionalStatus.pendiente:
        return 'Pendiente';
      case ProfessionalStatus.verificado:
        return 'Verificado';
      case ProfessionalStatus.rechazado:
        return 'Rechazado';
      case ProfessionalStatus.suspendido:
        return 'Suspendido';
    }
  }
}

/// Categorías del foro
enum ForumCategory {
  accidentes,
  alcoholemia,
  documentacion,
  estacionamiento,
  excesoVelocidad,
  general;

  String get nombre {
    switch (this) {
      case ForumCategory.accidentes:
        return 'Accidentes';
      case ForumCategory.alcoholemia:
        return 'Alcoholemia';
      case ForumCategory.documentacion:
        return 'Documentación';
      case ForumCategory.estacionamiento:
        return 'Estacionamiento';
      case ForumCategory.excesoVelocidad:
        return 'Exceso de velocidad';
      case ForumCategory.general:
        return 'General';
    }
  }

  String get descripcion {
    switch (this) {
      case ForumCategory.accidentes:
        return 'Accidentes de tránsito';
      case ForumCategory.alcoholemia:
        return 'Controles de alcohol';
      case ForumCategory.documentacion:
        return 'Problemas con documentos del vehículo';
      case ForumCategory.estacionamiento:
        return 'Problemas de estacionamiento';
      case ForumCategory.excesoVelocidad:
        return 'Infracciones por velocidad y semáforos';
      case ForumCategory.general:
        return 'Consultas generales';
    }
  }
}
