import 'consultation_model.dart';

class ChatMessageResponse {
  final String response;
  final String sessionId;
  final ConsultationModel? consultation;
  final DateTime timestamp;
  final String? consultationId;
  final List<Map<String, dynamic>>? documentosReferenciados;

  const ChatMessageResponse({
    required this.response,
    required this.sessionId,
    this.consultation,
    required this.timestamp,
    this.consultationId,
    this.documentosReferenciados,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    // El backend devuelve directamente la consulta con estos campos:
    // id, usuario_id, texto_original, respuesta_generada, session_id, documentos_referenciados, fecha_creacion
    
    return ChatMessageResponse(
      response: json['respuesta_generada'] ?? json['response'] ?? json['message'] ?? '',
      sessionId: json['session_id'] ?? json['sessionId'] ?? '',
      consultationId: json['id']?.toString(),
      documentosReferenciados: json['documentos_referenciados'] != null 
          ? List<Map<String, dynamic>>.from(json['documentos_referenciados'])
          : null,
      consultation: ConsultationModel.fromJson({
        'id': json['id']?.toString() ?? '',
        'user_id': json['usuario_id']?.toString() ?? '',
        'query': json['texto_original'] ?? '',
        'response': json['respuesta_generada'] ?? '',
        'session_id': json['session_id'] ?? '',
        'createdAt': json['fecha_creacion'],
      }),
      timestamp: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : (json['timestamp'] != null 
              ? DateTime.parse(json['timestamp'])
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'sessionId': sessionId,
      if (consultation != null) 'consultation': consultation!.toJson(),
      'timestamp': timestamp.toIso8601String(),
      if (consultationId != null) 'id': consultationId,
      if (documentosReferenciados != null) 'documentos_referenciados': documentosReferenciados,
    };
  }
}
