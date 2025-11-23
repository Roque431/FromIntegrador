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
