class ComentarioModel {
  final String id;
  final String publicacionId;
  final String usuarioId;
  final String autorNombre;
  final String? autorFoto;
  final String contenido;
  final DateTime fecha;
  final int likes;

  ComentarioModel({
    required this.id,
    required this.publicacionId,
    required this.usuarioId,
    required this.autorNombre,
    this.autorFoto,
    required this.contenido,
    required this.fecha,
    this.likes = 0,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      id: json['id'] ?? '',
      publicacionId: json['publicacionId'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      autorNombre: json['autorNombre'] ?? 'Usuario',
      autorFoto: json['autorFoto'],
      contenido: json['contenido'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publicacionId': publicacionId,
      'usuarioId': usuarioId,
      'autorNombre': autorNombre,
      'autorFoto': autorFoto,
      'contenido': contenido,
      'fecha': fecha.toIso8601String(),
      'likes': likes,
    };
  }

  String get autorInitials {
    final parts = autorNombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return autorNombre.isNotEmpty ? autorNombre[0].toUpperCase() : '?';
  }

  String get fechaFormateada {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
