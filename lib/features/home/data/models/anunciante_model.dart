/// Modelo para representar un anunciante/servicio (grúas, talleres, etc.)
class AnuncianteModel {
  final String id;
  final String nombreComercial;
  final String categoriaServicio;
  final String descripcion;
  final String direccion;
  final String telefono;
  final double rating;
  final bool disponible24h;
  final double? distanciaKm;

  const AnuncianteModel({
    required this.id,
    required this.nombreComercial,
    required this.categoriaServicio,
    this.descripcion = '',
    this.direccion = '',
    this.telefono = '',
    this.rating = 0.0,
    this.disponible24h = false,
    this.distanciaKm,
  });

  factory AnuncianteModel.fromJson(Map<String, dynamic> json) {
    return AnuncianteModel(
      id: json['id']?.toString() ?? '',
      nombreComercial: json['nombreComercial'] ?? json['nombre_comercial'] ?? '',
      categoriaServicio: json['categoriaServicio'] ?? json['categoria_servicio'] ?? '',
      descripcion: json['descripcion'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? json['telefono_comercial'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      disponible24h: json['disponible24h'] ?? json['disponible_24h'] ?? false,
      distanciaKm: (json['distanciaKm'] ?? json['distancia_km'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreComercial': nombreComercial,
      'categoriaServicio': categoriaServicio,
      'descripcion': descripcion,
      'direccion': direccion,
      'telefono': telefono,
      'rating': rating,
      'disponible24h': disponible24h,
      if (distanciaKm != null) 'distanciaKm': distanciaKm,
    };
  }

  /// Genera las estrellas de rating como texto
  String get ratingEstrellas {
    final estrellas = rating.round().clamp(0, 5);
    return '⭐' * estrellas;
  }

  /// Ícono según la categoría de servicio
  String get iconoCategoria {
    switch (categoriaServicio.toLowerCase()) {
      case 'grua':
      case 'grúa':
        return '🚛';
      case 'taller':
        return '🔧';
      case 'ajustador':
        return '📋';
      case 'seguro':
      case 'aseguradora':
        return '🛡️';
      default:
        return '🏪';
    }
  }
}
