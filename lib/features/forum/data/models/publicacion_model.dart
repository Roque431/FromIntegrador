class PublicacionModel {
  final String id;
  final String usuarioId;
  final String autorNombre;
  final String? autorFoto;
  final String titulo;
  final String contenido;
  final String categoriaId;
  final String categoriaNombre;
  final DateTime fecha;
  final int vistas;
  final int likes;
  final int comentarios;
  final bool yaLeDioLike;

  PublicacionModel({
    required this.id,
    required this.usuarioId,
    required this.autorNombre,
    this.autorFoto,
    required this.titulo,
    required this.contenido,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.fecha,
    this.vistas = 0,
    this.likes = 0,
    this.comentarios = 0,
    this.yaLeDioLike = false,
  });

  factory PublicacionModel.fromJson(Map<String, dynamic> json) {
    return PublicacionModel(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      autorNombre: json['autorNombre'] ?? 'Usuario',
      autorFoto: json['autorFoto'],
      titulo: json['titulo'] ?? '',
      contenido: json['contenido'] ?? '',
      categoriaId: json['categoriaId'] ?? '',
      categoriaNombre: json['categoriaNombre'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      vistas: json['vistas'] ?? 0,
      likes: json['likes'] ?? 0,
      comentarios: json['comentarios'] ?? 0,
      yaLeDioLike: json['yaLeDioLike'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'autorNombre': autorNombre,
      'autorFoto': autorFoto,
      'titulo': titulo,
      'contenido': contenido,
      'categoriaId': categoriaId,
      'categoriaNombre': categoriaNombre,
      'fecha': fecha.toIso8601String(),
      'vistas': vistas,
      'likes': likes,
      'comentarios': comentarios,
      'yaLeDioLike': yaLeDioLike,
    };
  }

  /// Copia con nuevos valores
  PublicacionModel copyWith({
    String? id,
    String? usuarioId,
    String? autorNombre,
    String? autorFoto,
    String? titulo,
    String? contenido,
    String? categoriaId,
    String? categoriaNombre,
    DateTime? fecha,
    int? vistas,
    int? likes,
    int? comentarios,
    bool? yaLeDioLike,
  }) {
    return PublicacionModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      autorNombre: autorNombre ?? this.autorNombre,
      autorFoto: autorFoto ?? this.autorFoto,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      categoriaId: categoriaId ?? this.categoriaId,
      categoriaNombre: categoriaNombre ?? this.categoriaNombre,
      fecha: fecha ?? this.fecha,
      vistas: vistas ?? this.vistas,
      likes: likes ?? this.likes,
      comentarios: comentarios ?? this.comentarios,
      yaLeDioLike: yaLeDioLike ?? this.yaLeDioLike,
    );
  }

  /// Genera las iniciales del autor
  String get autorInitials {
    final parts = autorNombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return autorNombre.isNotEmpty ? autorNombre[0].toUpperCase() : '?';
  }

  /// Formatea la fecha
  String get fechaFormateada {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
