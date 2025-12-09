class ChatSessionModel {
  final String id;
  final String usuarioId;
  final String? titulo;
  final String? clusterPrincipal;
  final int totalMensajes;
  final DateTime fechaInicio;
  final DateTime fechaUltimoMensaje;
  final bool activa;

  ChatSessionModel({
    required this.id,
    required this.usuarioId,
    this.titulo,
    this.clusterPrincipal,
    required this.totalMensajes,
    required this.fechaInicio,
    required this.fechaUltimoMensaje,
    required this.activa,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? json['usuario_id'] ?? '',
      titulo: json['titulo'],
      clusterPrincipal: json['clusterPrincipal'] ?? json['cluster_principal'],
      totalMensajes: json['totalMensajes'] ?? json['total_mensajes'] ?? 0,
      fechaInicio: DateTime.parse(
        json['fechaInicio'] ?? json['fecha_inicio'] ?? DateTime.now().toIso8601String(),
      ),
      fechaUltimoMensaje: DateTime.parse(
        json['fechaUltimoMensaje'] ?? json['fecha_ultimo_mensaje'] ?? DateTime.now().toIso8601String(),
      ),
      activa: json['activa'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'titulo': titulo,
      'clusterPrincipal': clusterPrincipal,
      'totalMensajes': totalMensajes,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaUltimoMensaje': fechaUltimoMensaje.toIso8601String(),
      'activa': activa,
    };
  }

  // Helper para mostrar fecha formateada
  String get fechaFormateada {
    final now = DateTime.now();
    final diff = now.difference(fechaUltimoMensaje);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays}d';

    return '${fechaUltimoMensaje.day}/${fechaUltimoMensaje.month}/${fechaUltimoMensaje.year}';
  }

  // Helper para título por defecto
  String get tituloDisplay {
    if (titulo != null && titulo!.isNotEmpty) {
      return titulo!;
    }
    return 'Conversación ${fechaInicio.day}/${fechaInicio.month}';
  }
}