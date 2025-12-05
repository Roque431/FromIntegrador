// Enums para tipos de oficinas de tránsito
enum TransitOfficeType {
  smyt, // Secretaría de Movilidad y Transporte
  transitoMunicipal, // Tránsito Municipal
  seguridadPublica, // Seguridad Pública Municipal
  oficinaLicencias, // Oficina de Licencias
  oficinaInfracciones, // Oficina de Infracciones
  lineaDenuncia, // Línea de Denuncia
}

enum ServiceType {
  licenciasEstatales,
  concesionesTransporte,
  infraccionesTraficas,
  reglamentoLocal,
  recursosMultas,
  consultasDudas,
  denunciasCiudadanas,
}

class LegalLocation {
  final String id;
  final String nombre;
  final String tipo;
  final String? direccion;
  final String? ciudad;
  final String? estado;
  final String? telefono;
  final String? horario;
  final double latitud;
  final double longitud;
  final double? distanciaKm;
  final bool esPublico;

  LegalLocation({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.direccion,
    this.ciudad,
    this.estado,
    this.telefono,
    this.horario,
    required this.latitud,
    required this.longitud,
    this.distanciaKm,
    this.esPublico = true,
  });

  factory LegalLocation.fromJson(Map<String, dynamic> json) {
    return LegalLocation(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: json['estado'] as String?,
      telefono: json['telefono'] as String?,
      horario: json['horario'] as String?,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      distanciaKm: json['distancia_km'] != null ? (json['distancia_km'] as num).toDouble() : null,
      esPublico: json['es_publico'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'direccion': direccion,
      'ciudad': ciudad,
      'estado': estado,
      'telefono': telefono,
      'horario': horario,
      'latitud': latitud,
      'longitud': longitud,
      'distancia_km': distanciaKm,
      'es_publico': esPublico,
    };
  }
}

class NearbyLocationsResponse {
  final double latitud;
  final double longitud;
  final double distanciaKm;
  final int total;
  final List<LegalLocation> ubicaciones;

  NearbyLocationsResponse({
    required this.latitud,
    required this.longitud,
    required this.distanciaKm,
    required this.total,
    required this.ubicaciones,
  });

  factory NearbyLocationsResponse.fromJson(Map<String, dynamic> json) {
    return NearbyLocationsResponse(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      distanciaKm: (json['distancia_km'] as num).toDouble(),
      total: json['total'] as int,
      ubicaciones: (json['ubicaciones'] as List)
          .map((item) => LegalLocation.fromJson(item))
          .toList(),
    );
  }
}

class PublicOffice {
  final String nombre;
  final String? tipo;
  final String? direccion;
  final String? ciudad;
  final String? estado;
  final String? telefono;
  final String? horario;
  final double? latitud;
  final double? longitud;
  final bool esPublico;

  PublicOffice({
    required this.nombre,
    this.tipo,
    this.direccion,
    this.ciudad,
    this.estado,
    this.telefono,
    this.horario,
    this.latitud,
    this.longitud,
    this.esPublico = true,
  });

  factory PublicOffice.fromJson(Map<String, dynamic> json) {
    return PublicOffice(
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String?,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: json['estado'] as String?,
      telefono: json['telefono'] as String?,
      horario: json['horario'] as String?,
      latitud: json['latitud'] != null ? (json['latitud'] as num).toDouble() : null,
      longitud: json['longitud'] != null ? (json['longitud'] as num).toDouble() : null,
      esPublico: json['es_publico'] ?? true,
    );
  }
}

class AdvisoryResponse {
  final String plan;
  final String estado;
  final String? tema;
  final String mensaje;
  final List<PublicOffice> oficinas;

  AdvisoryResponse({
    required this.plan,
    required this.estado,
    this.tema,
    required this.mensaje,
    required this.oficinas,
  });

  factory AdvisoryResponse.fromJson(Map<String, dynamic> json) {
    return AdvisoryResponse(
      plan: json['plan'] as String,
      estado: json['estado'] as String,
      tema: json['tema'] as String?,
      mensaje: json['mensaje'] as String,
      oficinas: (json['oficinas'] as List)
          .map((item) => PublicOffice.fromJson(item))
          .toList(),
    );
  }
}

// Modelo específico para oficinas de tránsito en Tuxtla Gutiérrez
class TransitOffice {
  final String id;
  final String nombre;
  final TransitOfficeType tipo;
  final String descripcion;
  final String? direccion;
  final String? telefono;
  final String? email;
  final String? sitioWeb;
  final String? redesSociales;
  final String? horarioAtencion;
  final String? imagenUrl;
  final double latitud;
  final double longitud;
  final double? distanciaKm;
  final List<ServiceType> serviciosOfrecidos;
  final bool atiendeSabados;
  final bool tieneLineaDenuncia;
  final String? numeroLineaDenuncia;
  final String? procedimientoAtencion;

  const TransitOffice({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    this.direccion,
    this.telefono,
    this.email,
    this.sitioWeb,
    this.redesSociales,
    this.horarioAtencion,
    this.imagenUrl,
    required this.latitud,
    required this.longitud,
    this.distanciaKm,
    required this.serviciosOfrecidos,
    this.atiendeSabados = false,
    this.tieneLineaDenuncia = false,
    this.numeroLineaDenuncia,
    this.procedimientoAtencion,
  });

  factory TransitOffice.fromJson(Map<String, dynamic> json) {
    return TransitOffice(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipo: TransitOfficeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['tipo'],
        orElse: () => TransitOfficeType.transitoMunicipal,
      ),
      descripcion: json['descripcion'] as String,
      direccion: json['direccion'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      sitioWeb: json['sitio_web'] as String?,
      redesSociales: json['redes_sociales'] as String?,
      horarioAtencion: json['horario_atencion'] as String?,
      imagenUrl: json['imagen_url'] as String?,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      distanciaKm: json['distancia_km'] != null ? (json['distancia_km'] as num).toDouble() : null,
      serviciosOfrecidos: (json['servicios_ofrecidos'] as List<dynamic>?)
          ?.map((service) => ServiceType.values.firstWhere(
                (e) => e.toString().split('.').last == service,
                orElse: () => ServiceType.consultasDudas,
              ))
          .toList() ?? [],
      atiendeSabados: json['atiende_sabados'] ?? false,
      tieneLineaDenuncia: json['tiene_linea_denuncia'] ?? false,
      numeroLineaDenuncia: json['numero_linea_denuncia'] as String?,
      procedimientoAtencion: json['procedimiento_atencion'] as String?,
    );
  }

  // Método para obtener descripción del tipo de oficina
  String get tipoDescripcion {
    switch (tipo) {
      case TransitOfficeType.smyt:
        return 'Secretaría de Movilidad y Transporte (SMYT)';
      case TransitOfficeType.transitoMunicipal:
        return 'Dirección de Tránsito Municipal';
      case TransitOfficeType.seguridadPublica:
        return 'Secretaría de Seguridad Pública';
      case TransitOfficeType.oficinaLicencias:
        return 'Oficina de Licencias de Conducir';
      case TransitOfficeType.oficinaInfracciones:
        return 'Oficina de Infracciones de Tránsito';
      case TransitOfficeType.lineaDenuncia:
        return 'Línea de Denuncia Ciudadana';
    }
  }

  // Método para obtener servicios en formato legible
  List<String> get serviciosDescripcion {
    return serviciosOfrecidos.map((servicio) {
      switch (servicio) {
        case ServiceType.licenciasEstatales:
          return 'Licencias de Conducir Estatales';
        case ServiceType.concesionesTransporte:
          return 'Concesiones de Transporte';
        case ServiceType.infraccionesTraficas:
          return 'Multas e Infracciones';
        case ServiceType.reglamentoLocal:
          return 'Reglamento Municipal';
        case ServiceType.recursosMultas:
          return 'Recursos contra Multas';
        case ServiceType.consultasDudas:
          return 'Consultas y Dudas';
        case ServiceType.denunciasCiudadanas:
          return 'Denuncias Ciudadanas';
      }
    }).toList();
  }

  // Método para verificar si está cerca del usuario
  bool get estaCerca => distanciaKm != null && distanciaKm! <= 5.0;
}

// Respuesta para búsqueda de oficinas de tránsito
class TransitOfficesResponse {
  final double latitudUsuario;
  final double longitudUsuario;
  final String ciudad;
  final String estado;
  final int total;
  final List<TransitOffice> oficinas;

  const TransitOfficesResponse({
    required this.latitudUsuario,
    required this.longitudUsuario,
    required this.ciudad,
    required this.estado,
    required this.total,
    required this.oficinas,
  });

  factory TransitOfficesResponse.fromJson(Map<String, dynamic> json) {
    return TransitOfficesResponse(
      latitudUsuario: (json['latitud_usuario'] as num).toDouble(),
      longitudUsuario: (json['longitud_usuario'] as num).toDouble(),
      ciudad: json['ciudad'] as String,
      estado: json['estado'] as String,
      total: json['total'] as int,
      oficinas: (json['oficinas'] as List)
          .map((item) => TransitOffice.fromJson(item))
          .toList(),
    );
  }
}
