class ConsultationModel {
  final String id;
  final String usuarioId;
  final String textoOriginal;
  final String? respuestaGenerada;
  final String? grupoTematicoId;
  final DateTime fechaConsulta;
  final DateTime? fechaRespuesta;
  final String? modeloUtilizado;
  final String? tokensUtilizados;
  final String? tiempoProcesamiento;

  const ConsultationModel({
    required this.id,
    required this.usuarioId,
    required this.textoOriginal,
    this.respuestaGenerada,
    this.grupoTematicoId,
    required this.fechaConsulta,
    this.fechaRespuesta,
    this.modeloUtilizado,
    this.tokensUtilizados,
    this.tiempoProcesamiento,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      textoOriginal: json['texto_original'] as String,
      respuestaGenerada: json['respuesta_generada'] as String?,
      grupoTematicoId: json['grupo_tematico_id'] as String?,
      fechaConsulta: DateTime.parse(json['fecha_consulta'] as String),
      fechaRespuesta: json['fecha_respuesta'] != null
          ? DateTime.parse(json['fecha_respuesta'] as String)
          : null,
      modeloUtilizado: json['modelo_utilizado'] as String?,
      tokensUtilizados: json['tokens_utilizados'] as String?,
      tiempoProcesamiento: json['tiempo_procesamiento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'texto_original': textoOriginal,
      if (respuestaGenerada != null) 'respuesta_generada': respuestaGenerada,
      if (grupoTematicoId != null) 'grupo_tematico_id': grupoTematicoId,
      'fecha_consulta': fechaConsulta.toIso8601String(),
      if (fechaRespuesta != null) 'fecha_respuesta': fechaRespuesta!.toIso8601String(),
      if (modeloUtilizado != null) 'modelo_utilizado': modeloUtilizado,
      if (tokensUtilizados != null) 'tokens_utilizados': tokensUtilizados,
      if (tiempoProcesamiento != null) 'tiempo_procesamiento': tiempoProcesamiento,
    };
  }
}


class ConsultationResponseModel {
  final String id;
  final String textoOriginal;
  final String respuestaGenerada;
  final List<DocumentReference> documentosRelevantes;
  final String modeloUtilizado;
  final String tiempoProcesamiento;
  final String? sessionId;
  final List<String> followUpQuestions;
  final String? categoria;
  final double? categoriaConfianza;
  final bool? canComment;
  final UsageInfo? usageInfo;

  const ConsultationResponseModel({
    required this.id,
    required this.textoOriginal,
    required this.respuestaGenerada,
    this.documentosRelevantes = const [],
    required this.modeloUtilizado,
    required this.tiempoProcesamiento,
    this.sessionId,
    this.followUpQuestions = const [],
    this.categoria,
    this.categoriaConfianza,
    this.canComment,
    this.usageInfo,
  });

  factory ConsultationResponseModel.fromJson(Map<String, dynamic> json) {
    return ConsultationResponseModel(
      id: json['id'] as String,
      textoOriginal: json['texto_original'] as String,
      respuestaGenerada: json['respuesta_generada'] as String,
      documentosRelevantes: (json['documentos_relevantes'] as List<dynamic>?)
              ?.map((doc) => DocumentReference.fromJson(doc as Map<String, dynamic>))
              .toList() ??
          [],
      modeloUtilizado: json['modelo_utilizado'] as String,
      tiempoProcesamiento: json['tiempo_procesamiento'] as String,
      sessionId: json['session_id'] as String?,
      followUpQuestions: (json['follow_up_questions'] as List<dynamic>?)
              ?.map((q) => q as String)
              .toList() ??
          [],
      categoria: json['categoria'] as String?,
      categoriaConfianza: (json['categoria_confianza'] as num?)?.toDouble(),
      canComment: json['can_comment'] as bool?,
      usageInfo: json['usage_info'] != null
          ? UsageInfo.fromJson(json['usage_info'] as Map<String, dynamic>)
          : null,
    );
  }
}


class DocumentReference {
  final String id;
  final String title;
  final String? url;
  final double? score;

  const DocumentReference({
    required this.id,
    required this.title,
    this.url,
    this.score,
  });

  factory DocumentReference.fromJson(Map<String, dynamic> json) {
    return DocumentReference(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }
}


class UsageInfo {
  final int usage;
  final int limit;
  final int remaining;

  const UsageInfo({
    required this.usage,
    required this.limit,
    required this.remaining,
  });

  factory UsageInfo.fromJson(Map<String, dynamic> json) {
    return UsageInfo(
      usage: json['usage'] as int,
      limit: json['limit'] as int,
      remaining: json['remaining'] as int,
    );
  }

  bool get isLimitReached => remaining <= 0;
  double get usagePercentage => limit > 0 ? (usage / limit) * 100 : 0;
}


class CreateConsultationRequest {
  final String textoOriginal;

  const CreateConsultationRequest({
    required this.textoOriginal,
  });

  Map<String, dynamic> toJson() {
    return {
      'texto_original': textoOriginal,
    };
  }
}
