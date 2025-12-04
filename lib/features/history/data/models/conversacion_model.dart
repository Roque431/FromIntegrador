class ConversacionModel {
  final String id;
  final String? titulo;
  final String? clusterPrincipal;
  final int totalMensajes;
  final DateTime fechaInicio;
  final DateTime fechaUltimoMensaje;
  final bool activa;
  final String? ultimoMensaje;

  ConversacionModel({
    required this.id,
    this.titulo,
    this.clusterPrincipal,
    this.totalMensajes = 0,
    required this.fechaInicio,
    required this.fechaUltimoMensaje,
    this.activa = true,
    this.ultimoMensaje,
  });

  factory ConversacionModel.fromJson(Map<String, dynamic> json) {
    return ConversacionModel(
      id: json['id'] ?? '',
      titulo: json['titulo'],
      clusterPrincipal: json['clusterPrincipal'],
      totalMensajes: json['totalMensajes'] ?? 0,
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime.now(),
      fechaUltimoMensaje: DateTime.tryParse(json['fechaUltimoMensaje'] ?? '') ?? DateTime.now(),
      activa: json['activa'] ?? true,
      ultimoMensaje: json['ultimoMensaje'],
    );
  }

  String get fechaFormateada {
    return '${fechaUltimoMensaje.day.toString().padLeft(2, '0')}/${fechaUltimoMensaje.month.toString().padLeft(2, '0')}/${fechaUltimoMensaje.year}';
  }

  /// Texto descriptivo del cluster
  String get clusterDescripcion {
    switch (clusterPrincipal) {
      case 'C1':
        return 'Accidentes';
      case 'C2':
        return 'Multas';
      case 'C3':
        return 'Documentos';
      case 'C4':
        return 'Alcoholemia';
      case 'C5':
        return 'Derechos';
      default:
        return 'General';
    }
  }
}

class MensajeModel {
  final String id;
  final String rol;
  final String mensaje;
  final String? cluster;
  final String? sentimiento;
  final String? intencion;
  final DateTime fecha;

  MensajeModel({
    required this.id,
    required this.rol,
    required this.mensaje,
    this.cluster,
    this.sentimiento,
    this.intencion,
    required this.fecha,
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) {
    return MensajeModel(
      id: json['id'] ?? '',
      rol: json['rol'] ?? 'user',
      mensaje: json['mensaje'] ?? '',
      cluster: json['cluster'],
      sentimiento: json['sentimiento'],
      intencion: json['intencion'],
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
    );
  }

  bool get esUsuario => rol == 'user';
  bool get esAsistente => rol == 'assistant';
  bool get esSistema => rol == 'system';
}

class ConversacionDetalleModel {
  final String id;
  final String usuarioId;
  final String? usuarioNombre;
  final String? titulo;
  final String? clusterPrincipal;
  final int totalMensajes;
  final DateTime fechaInicio;
  final DateTime fechaUltimoMensaje;
  final bool activa;
  final List<MensajeModel> mensajes;

  ConversacionDetalleModel({
    required this.id,
    required this.usuarioId,
    this.usuarioNombre,
    this.titulo,
    this.clusterPrincipal,
    this.totalMensajes = 0,
    required this.fechaInicio,
    required this.fechaUltimoMensaje,
    this.activa = true,
    this.mensajes = const [],
  });

  factory ConversacionDetalleModel.fromJson(Map<String, dynamic> json) {
    final conversacion = json['conversacion'] ?? {};
    final mensajesJson = json['mensajes'] as List? ?? [];

    return ConversacionDetalleModel(
      id: conversacion['id'] ?? '',
      usuarioId: conversacion['usuarioId'] ?? '',
      usuarioNombre: conversacion['usuarioNombre'],
      titulo: conversacion['titulo'],
      clusterPrincipal: conversacion['clusterPrincipal'],
      totalMensajes: conversacion['totalMensajes'] ?? 0,
      fechaInicio: DateTime.tryParse(conversacion['fechaInicio'] ?? '') ?? DateTime.now(),
      fechaUltimoMensaje: DateTime.tryParse(conversacion['fechaUltimoMensaje'] ?? '') ?? DateTime.now(),
      activa: conversacion['activa'] ?? true,
      mensajes: mensajesJson.map((m) => MensajeModel.fromJson(m)).toList(),
    );
  }
}
