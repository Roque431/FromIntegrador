/// Modelo para representar un profesionista (abogado) recomendado
class ProfesionistaModel {
  final String id;
  final String nombre;
  final List<String> especialidades;
  final double rating;
  final int totalCalificaciones;
  final int experienciaAnios;
  final String ciudad;
  final String descripcion;
  final bool verificado;
  final String? fotoProfesional;

  const ProfesionistaModel({
    required this.id,
    required this.nombre,
    this.especialidades = const [],
    this.rating = 0.0,
    this.totalCalificaciones = 0,
    this.experienciaAnios = 0,
    this.ciudad = '',
    this.descripcion = '',
    this.verificado = false,
    this.fotoProfesional,
  });

  factory ProfesionistaModel.fromJson(Map<String, dynamic> json) {
    return ProfesionistaModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      especialidades: json['especialidades'] != null
          ? List<String>.from(json['especialidades'])
          : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalCalificaciones: json['totalCalificaciones'] ?? json['total_calificaciones'] ?? 0,
      experienciaAnios: json['experienciaAnios'] ?? json['experiencia_anios'] ?? 0,
      ciudad: json['ciudad'] ?? '',
      descripcion: json['descripcion'] ?? '',
      verificado: json['verificado'] ?? false,
      fotoProfesional: json['fotoProfesional'] ?? json['foto_profesional'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'especialidades': especialidades,
      'rating': rating,
      'totalCalificaciones': totalCalificaciones,
      'experienciaAnios': experienciaAnios,
      'ciudad': ciudad,
      'descripcion': descripcion,
      'verificado': verificado,
      if (fotoProfesional != null) 'fotoProfesional': fotoProfesional,
    };
  }

  /// Genera las estrellas de rating como texto
  String get ratingEstrellas {
    final estrellas = rating.round().clamp(0, 5);
    return '⭐' * estrellas;
  }

  /// Obtiene las iniciales del nombre para el avatar
  String get iniciales {
    final parts = nombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }
}
