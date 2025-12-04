class MensajePrivadoModel {
  final String id;
  final String ciudadanoId;
  final String abogadoId;
  final String remitenteId;
  final String contenido;
  final DateTime fecha;
  final bool leido;

  // Datos opcionales del remitente
  final String? nombreRemitente;
  final String? fotoRemitente;

  MensajePrivadoModel({
    required this.id,
    required this.ciudadanoId,
    required this.abogadoId,
    required this.remitenteId,
    required this.contenido,
    required this.fecha,
    this.leido = false,
    this.nombreRemitente,
    this.fotoRemitente,
  });

  factory MensajePrivadoModel.fromJson(Map<String, dynamic> json) {
    return MensajePrivadoModel(
      id: json['id'] ?? '',
      ciudadanoId: json['ciudadanoId'] ?? json['ciudadano_id'] ?? '',
      abogadoId: json['abogadoId'] ?? json['abogado_id'] ?? '',
      remitenteId: json['remitenteId'] ?? json['remitente_id'] ?? '',
      contenido: json['contenido'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      leido: json['leido'] ?? false,
      nombreRemitente: json['nombreRemitente'] ?? json['nombre_remitente'],
      fotoRemitente: json['fotoRemitente'] ?? json['foto_remitente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ciudadanoId': ciudadanoId,
      'abogadoId': abogadoId,
      'remitenteId': remitenteId,
      'contenido': contenido,
      'fecha': fecha.toIso8601String(),
      'leido': leido,
    };
  }

  bool esMio(String usuarioId) => remitenteId == usuarioId;

  String get fechaFormateada {
    final now = DateTime.now();
    final diff = now.difference(fecha);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';

    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String get horaFormateada {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}

class ConversacionPrivadaModel {
  final String ciudadanoId;
  final String abogadoId;
  final String otroUsuarioId;
  final String otroUsuarioNombre;
  final String? otroUsuarioFoto;
  final String? ultimoMensaje;
  final DateTime? fechaUltimoMensaje;
  final int mensajesNoLeidos;
  final bool esAbogado; // Para saber si el otro usuario es abogado

  ConversacionPrivadaModel({
    required this.ciudadanoId,
    required this.abogadoId,
    required this.otroUsuarioId,
    required this.otroUsuarioNombre,
    this.otroUsuarioFoto,
    this.ultimoMensaje,
    this.fechaUltimoMensaje,
    this.mensajesNoLeidos = 0,
    this.esAbogado = false,
  });

  // ID generado a partir de ciudadano y abogado
  String get id => '${ciudadanoId}_$abogadoId';

  factory ConversacionPrivadaModel.fromJson(Map<String, dynamic> json) {
    return ConversacionPrivadaModel(
      ciudadanoId: json['ciudadanoId'] ?? json['ciudadano_id'] ?? '',
      abogadoId: json['abogadoId'] ?? json['abogado_id'] ?? '',
      otroUsuarioId: json['otroUsuarioId'] ?? json['otro_usuario_id'] ?? '',
      otroUsuarioNombre: json['otroUsuarioNombre'] ?? json['otro_usuario_nombre'] ?? 'Usuario',
      otroUsuarioFoto: json['otroUsuarioFoto'] ?? json['otro_usuario_foto'],
      ultimoMensaje: json['ultimoMensaje'] ?? json['ultimo_mensaje'],
      fechaUltimoMensaje: json['fechaUltimoMensaje'] != null 
          ? DateTime.tryParse(json['fechaUltimoMensaje'])
          : json['fecha_ultimo_mensaje'] != null
              ? DateTime.tryParse(json['fecha_ultimo_mensaje'])
              : null,
      mensajesNoLeidos: json['noLeidos'] ?? json['mensajesNoLeidos'] ?? json['mensajes_no_leidos'] ?? json['no_leidos'] ?? 0,
      esAbogado: json['esAbogado'] ?? json['es_abogado'] ?? false,
    );
  }

  String get iniciales {
    final parts = otroUsuarioNombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return otroUsuarioNombre.substring(0, 2).toUpperCase();
  }

  String get fechaFormateada {
    if (fechaUltimoMensaje == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(fechaUltimoMensaje!);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    if (diff.inDays < 7) return '${diff.inDays} d';

    return '${fechaUltimoMensaje!.day}/${fechaUltimoMensaje!.month}';
  }
}
